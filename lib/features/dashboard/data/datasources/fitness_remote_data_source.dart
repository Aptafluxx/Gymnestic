import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:gymnestic/features/dashboard/data/models/daily_record_model.dart';
import 'package:gymnestic/features/workouts/data/models/daily_goal_model.dart';

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

  Stream<DailyRecordModel> streamTodayRecord() {
    final uid = _uid;
    if (uid == null) return Stream.value(DailyRecordModel.empty(_todayKey));

    final docRef = _userDoc(uid).collection('daily_records').doc(_todayKey);

    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        docRef.set(DailyRecordModel.empty(_todayKey).toMap());
        return DailyRecordModel.empty(_todayKey);
      }
      return DailyRecordModel.fromMap(snapshot.id, snapshot.data()!);
    });
  }

  Stream<List<DailyRecordModel>> streamPastRecords({int days = 5}) {
    final uid = _uid;
    if (uid == null) return Stream.value(const []);

    return _userDoc(uid)
        .collection('daily_records')
        .orderBy('dateKey', descending: true)
        .limit(days)
        .snapshots()
        .map((snapshot) {
          final records = snapshot.docs
              .map((doc) => DailyRecordModel.fromMap(doc.id, doc.data()))
              .toList();
          return records.reversed.toList();
        });
  }

  Future<void> logHealthMetrics({required int bpm, required int weight}) async {
    final uid = _uid;
    if (uid == null) return;

    final docRef = _userDoc(uid).collection('daily_records').doc(_todayKey);
    await docRef.set({
      'bpm': bpm,
      'weight': weight,
      'dateKey': _todayKey,
    }, SetOptions(merge: true));
  }

  Future<void> toggleGoalCompletion({
    required DailyGoalModel goal,
    required bool isCompleted,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final batch = _firestore.batch();
    final goalRef = _userDoc(uid).collection('daily_goals').doc(goal.id);
    final recordRef = _userDoc(uid).collection('daily_records').doc(_todayKey);

    batch.update(goalRef, {'isCompleted': isCompleted});

    if (isCompleted) {
      batch.set(recordRef, {
        'dateKey': _todayKey,
        'kcalBurned': FieldValue.increment(goal.calorieReward),
        'completedGoalIds': FieldValue.arrayUnion([goal.id]),
      }, SetOptions(merge: true));
    } else {
      batch.set(recordRef, {
        'dateKey': _todayKey,
        'kcalBurned': FieldValue.increment(-goal.calorieReward),
        'completedGoalIds': FieldValue.arrayRemove([goal.id]),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  /// Streams goals specifically matching the chosen programId
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
        .snapshots()
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

  Stream<String> streamGenderPreference() {
    final uid = _uid;
    if (uid == null) return Stream.value('Male');

    return _userDoc(uid).snapshots().map((snapshot) {
      final gender = snapshot.data()?['genderPreference'];
      return gender == 'Female' ? 'Female' : 'Male';
    });
  }

  Future<void> saveGenderPreference(String gender) async {
    if (gender != 'Male' && gender != 'Female') {
      throw ArgumentError.value(gender, 'gender', 'Unsupported gender');
    }
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

  // Curated, unique goals for each specific activity program
  static const List<DailyGoalModel> _defaultGoals = <DailyGoalModel>[
    // 1. Beginner Program Goals
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

    // 2. Strength Training Goals
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

    // 3. Daily Stretch Goals
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
}
