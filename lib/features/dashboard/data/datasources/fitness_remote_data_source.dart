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

  Stream<List<DailyGoalModel>> streamDailyGoals() {
    final uid = _uid;
    if (uid == null) return Stream.value(_defaultGoals);

    final goalsRef = _userDoc(uid).collection('daily_goals');

    return goalsRef.snapshots().asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        await _seedDefaultGoals(uid);
        return _defaultGoals;
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
      batch.set(colRef.doc(item.id), item.toMap());
    }
    await batch.commit();
  }

  static const List<DailyGoalModel> _defaultGoals = <DailyGoalModel>[
    DailyGoalModel(
      id: 'push-ups-20',
      time: '07:10',
      title: 'Push up 20 times',
      isCompleted: false,
      gender: 'All',
      calorieReward: 25,
    ),
    DailyGoalModel(
      id: 'morning-jog',
      time: '08:15',
      title: '30-minute morning jog',
      isCompleted: false,
      gender: 'All',
      calorieReward: 150,
    ),
    DailyGoalModel(
      id: 'core-plank',
      time: '12:30',
      title: 'Core plank (3 sets x 60s)',
      isCompleted: false,
      gender: 'All',
      calorieReward: 45,
    ),
    DailyGoalModel(
      id: 'dumbbell-bench',
      time: '17:00',
      title: 'Dumbbell bench press',
      isCompleted: false,
      gender: 'Male',
      calorieReward: 90,
    ),
    DailyGoalModel(
      id: 'post-stretch',
      time: '18:30',
      title: 'Post-workout stretch',
      isCompleted: false,
      gender: 'All',
      calorieReward: 30,
    ),
  ];
}
