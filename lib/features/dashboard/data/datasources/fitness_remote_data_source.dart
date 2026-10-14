import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymnestic/features/profile/data/models/user_profile_model.dart';
import 'package:intl/intl.dart';

import '../models/daily_record_model.dart';
import '../../../workouts/data/models/daily_goal_model.dart';

class FitnessRemoteDataSource {
  FitnessRemoteDataSource({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestoreOverride = firestore,
      _authOverride = auth;

  final FirebaseFirestore? _firestoreOverride;
  final FirebaseAuth? _authOverride;

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;

  String? get _uid {
    if (_authOverride == null && Firebase.apps.isEmpty) return null;
    return _auth.currentUser?.uid;
  }

  String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  // 1. STREAM TODAY'S RECORD (Necessary for real-time reactivity on active metrics)
  Stream<DailyRecordModel> streamTodayRecord() {
    final uid = _uid;
    if (uid == null) return Stream.value(DailyRecordModel.empty(_todayKey));

    final docRef = _userDoc(uid).collection('daily_records').doc(_todayKey);

    return docRef.snapshots(includeMetadataChanges: false).map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        // Only write if genuinely absent
        docRef.set(
          DailyRecordModel.empty(_todayKey).toMap(),
          SetOptions(merge: true),
        );
        return DailyRecordModel.empty(_todayKey);
      }
      return DailyRecordModel.fromMap(snapshot.id, snapshot.data()!);
    });
  }

  // 2. OPTIMIZATION: ONE-TIME FETCH FOR HISTORICAL CHART DATA
  // Replaces the open snapshot stream that caused 5 reads per click.
  // 1. One-time fetch for 5-day chart data with optional server bypass
  Future<List<DailyRecordModel>> fetchPastRecords({
    int days = 5,
    bool forceRefresh = false,
  }) async {
    final uid = _uid;
    if (uid == null) return const [];

    try {
      final query = _userDoc(uid)
          .collection('daily_records')
          .orderBy('dateKey', descending: true)
          .limit(days);

      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (forceRefresh) {
        // User explicitly pulled to refresh: query server directly
        snapshot = await query.get(
          const GetOptions(source: Source.serverAndCache),
        );
      } else {
        // Normal launch: attempt zero-cost cache read first
        try {
          snapshot = await query.get(const GetOptions(source: Source.cache));
          if (snapshot.docs.isEmpty) {
            snapshot = await query.get(const GetOptions(source: Source.server));
          }
        } catch (_) {
          snapshot = await query.get(
            const GetOptions(source: Source.serverAndCache),
          );
        }
      }

      final records = snapshot.docs
          .map((doc) => DailyRecordModel.fromMap(doc.id, doc.data()))
          .toList();

      return records.reversed.toList();
    } catch (_) {
      return const [];
    }
  }

  // 2. Fetch current week's records with optional server bypass
  Future<List<DailyRecordModel>> fetchCurrentWeekRecords({
    bool forceRefresh = false,
  }) async {
    final uid = _uid;
    if (uid == null) return const [];

    try {
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final mondayKey = DateFormat('yyyy-MM-dd').format(monday);

      final query = _userDoc(uid)
          .collection('daily_records')
          .where('dateKey', isGreaterThanOrEqualTo: mondayKey)
          .orderBy('dateKey', descending: false);

      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (forceRefresh) {
        // Force server fetch on pull-to-refresh
        snapshot = await query.get(
          const GetOptions(source: Source.serverAndCache),
        );
      } else {
        // Standard launch: cache first
        try {
          snapshot = await query.get(const GetOptions(source: Source.cache));
          if (snapshot.docs.isEmpty) {
            snapshot = await query.get(const GetOptions(source: Source.server));
          }
        } catch (_) {
          snapshot = await query.get(
            const GetOptions(source: Source.serverAndCache),
          );
        }
      }

      return snapshot.docs
          .map((doc) => DailyRecordModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  // 3. LOG HEALTH METRICS (Single targeted document merge write)
  /// Saves user-logged health metrics including distance and sleep to today's record
  Future<void> logHealthMetrics({
    required int bpm,
    required int weight,
    double? runningKm,
    int? sleepHours,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final docRef = _userDoc(uid).collection('daily_records').doc(_todayKey);
    final data = <String, dynamic>{
      'bpm': bpm,
      'weight': weight,
      'dateKey': _todayKey,
    };

    if (runningKm != null) data['runningKm'] = runningKm;
    if (sleepHours != null) data['sleepHours'] = sleepHours;

    await docRef.set(data, SetOptions(merge: true));
  }

  // 4. ATOMIC GOAL TOGGLE (Batch write: 1 round-trip network payload)
  /// Updates task state ONLY in today's daily record without modifying the master template
  Future<void> toggleGoalCompletion({
    required DailyGoalModel goal,
    required bool isCompleted,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final recordRef = _userDoc(uid).collection('daily_records').doc(_todayKey);

    if (isCompleted) {
      // Add goal ID to today's completed list and add calories
      await recordRef.set({
        'dateKey': _todayKey,
        'kcalBurned': FieldValue.increment(goal.calorieReward),
        'completedGoalIds': FieldValue.arrayUnion([goal.id]),
      }, SetOptions(merge: true));
    } else {
      // Remove goal ID from today's completed list and subtract calories
      await recordRef.set({
        'dateKey': _todayKey,
        'kcalBurned': FieldValue.increment(-goal.calorieReward),
        'completedGoalIds': FieldValue.arrayRemove([goal.id]),
      }, SetOptions(merge: true));
    }
  }

  // 5. STREAM DAILY GOALS (Only reads for the specific active programId)
  Stream<List<DailyGoalModel>> streamDailyGoals({required String programId}) {
    final uid = _uid;
    if (uid == null) {
      return Stream.value(
        _defaultGoals.where((g) => g.programId == programId).toList(),
      );
    }

    final goalsRef = _userDoc(uid).collection('daily_goals');

    return goalsRef
        .where('programId', isEqualTo: programId)
        .snapshots(includeMetadataChanges: false)
        .asyncMap((snapshot) async {
          if (snapshot.docs.isEmpty) {
            await _seedDefaultGoals(uid);
            return _defaultGoals
                .where((g) => g.programId == programId)
                .toList();
          }
          return snapshot.docs
              .map((doc) => DailyGoalModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // 6. OPTIMIZATION: ONE-TIME GENDER PREFERENCE FETCH
  // Eliminates continuous listeners on the root user document.
  Future<String> getGenderPreference() async {
    final uid = _uid;
    if (uid == null) return 'Male';

    try {
      final doc = await _userDoc(uid)
          .get(const GetOptions(source: Source.serverAndCache));
      return doc.data()?['genderPreference'] as String? ?? 'Male';
    } catch (_) {
      return 'Male';
    }
  }

  Future<void> saveGenderPreference(String gender) async {
    final uid = _uid;
    if (uid == null) return;

    await _userDoc(uid)
        .set({'genderPreference': gender}, SetOptions(merge: true));
  }

  Future<void> _seedDefaultGoals(String uid) async {
    final batch = _firestore.batch();
    final colRef = _userDoc(uid).collection('daily_goals');
    for (final item in _defaultGoals) {
      batch.set(colRef.doc(item.id), item.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  static const List<DailyGoalModel> _defaultGoals = <DailyGoalModel>[
    DailyGoalModel(
      id: 'beg-jump-rope',
      programId: 'beginner',
      time: '07:10',
      title: 'Warm-up jump rope (5 mins)',
      isCompleted: false,
      gender: 'All',
      calorieReward: 25,
    ),
    DailyGoalModel(
      id: 'beg-push-ups',
      programId: 'beginner',
      time: '08:15',
      title: 'Knee or wall push-ups x 15',
      isCompleted: false,
      gender: 'All',
      calorieReward: 20,
    ),
    DailyGoalModel(
      id: 'beg-squats',
      programId: 'beginner',
      time: '11:30',
      title: 'Bodyweight squats x 20',
      isCompleted: false,
      gender: 'All',
      calorieReward: 30,
    ),
    DailyGoalModel(
      id: 'beg-jog',
      programId: 'beginner',
      time: '17:00',
      title: 'Light walk or jog 15 minutes',
      isCompleted: false,
      gender: 'All',
      calorieReward: 80,
    ),
    DailyGoalModel(
      id: 'str-pushups-50',
      programId: 'strength',
      time: '07:00',
      title: 'Standard push-ups 50 times',
      isCompleted: false,
      gender: 'All',
      calorieReward: 60,
    ),
    DailyGoalModel(
      id: 'str-bench-press',
      programId: 'strength',
      time: '08:30',
      title: 'Dumbbell bench press (4 sets x 10)',
      isCompleted: false,
      gender: 'Male',
      calorieReward: 110,
    ),
    DailyGoalModel(
      id: 'str-deadlift',
      programId: 'strength',
      time: '12:00',
      title: 'Barbell deadlift (3 sets x 8)',
      isCompleted: false,
      gender: 'All',
      calorieReward: 140,
    ),
    DailyGoalModel(
      id: 'str-plank',
      programId: 'strength',
      time: '17:30',
      title: 'Core plank (3 sets x 90s)',
      isCompleted: false,
      gender: 'All',
      calorieReward: 50,
    ),
    DailyGoalModel(
      id: 'strt-morning-flow',
      programId: 'stretch',
      time: '06:30',
      title: 'Full-body morning yoga flow',
      isCompleted: false,
      gender: 'All',
      calorieReward: 40,
    ),
    DailyGoalModel(
      id: 'strt-hamstring',
      programId: 'stretch',
      time: '09:00',
      title: 'Hamstring & quad deep stretch',
      isCompleted: false,
      gender: 'All',
      calorieReward: 20,
    ),
    DailyGoalModel(
      id: 'strt-mobility',
      programId: 'stretch',
      time: '14:00',
      title: 'Spine & neck mobility exercises',
      isCompleted: false,
      gender: 'All',
      calorieReward: 25,
    ),
    DailyGoalModel(
      id: 'strt-breathing',
      programId: 'stretch',
      time: '21:00',
      title: 'Evening relaxation & breathwork',
      isCompleted: false,
      gender: 'All',
      calorieReward: 15,
    ),
  ];

  /// Streams the user's profile document and initializes it with real Auth data if missing
  Stream<UserProfileModel> streamUserProfile() {
    final uid = _uid;
    if (uid == null) return Stream.value(UserProfileModel.initial());

    final docRef = _userDoc(uid).collection('profile').doc('current');

    return docRef.snapshots(includeMetadataChanges: false).map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        // Extract real name or email prefix from Firebase Auth
        final user = _auth.currentUser;
        final displayName = user?.displayName?.trim();
        final emailPrefix = user?.email?.split('@').first.trim();
        final actualName = displayName?.isNotEmpty == true
            ? displayName
            : emailPrefix;

        // Generate profile with their actual name
        final initialProfile = UserProfileModel.initial(authName: actualName);

        docRef.set(initialProfile.toMap(), SetOptions(merge: true));
        return initialProfile;
      }
      return UserProfileModel.fromMap(snapshot.data()!);
    });
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final uid = _uid;
    if (uid == null) return;

    final docRef = _userDoc(uid).collection('profile').doc('current');
    await docRef.set(updates, SetOptions(merge: true));
  }
}
