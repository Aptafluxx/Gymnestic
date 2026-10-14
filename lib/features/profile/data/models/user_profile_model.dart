class UserProfileModel {
  final String fullName;
  final String role;
  final String phone;
  final String badgeLevel;
  final String bio;
  final List<String> skills;

  const UserProfileModel({
    required this.fullName,
    required this.role,
    required this.phone,
    required this.badgeLevel,
    required this.bio,
    required this.skills,
  });

  factory UserProfileModel.initial({String? authName}) {
    return UserProfileModel(
      fullName: authName?.isNotEmpty == true ? authName! : 'Athlete',
      role: '',
      phone: '',
      badgeLevel: 'BEGINNER',
      bio: '',
      skills: const [],
    );
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      fullName: map['fullName'] as String? ?? 'Athlete',
      role: map['role'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      badgeLevel: map['badgeLevel'] as String? ?? 'BEGINNER',
      bio: map['bio'] as String? ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'role': role,
      'phone': phone,
      'badgeLevel': badgeLevel,
      'bio': bio,
      'skills': skills,
    };
  }

  UserProfileModel copyWith({
    String? fullName,
    String? role,
    String? phone,
    String? badgeLevel,
    String? bio,
    List<String>? skills,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      badgeLevel: badgeLevel ?? this.badgeLevel,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
    );
  }
}
