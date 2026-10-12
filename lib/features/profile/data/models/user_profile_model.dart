class UserProfileModel {
  const UserProfileModel({
    required this.fullName,
    required this.role,
    required this.phone,
    required this.badgeLevel,
    required this.bio,
    required this.skills,
    required this.socialLinks,
  });

  final String fullName;
  final String role;
  final String phone;
  final String badgeLevel;
  final String bio;
  final List<String> skills;
  final Map<String, String> socialLinks;

  UserProfileModel copyWith({
    String? fullName,
    String? role,
    String? phone,
    String? badgeLevel,
    String? bio,
    List<String>? skills,
    Map<String, String>? socialLinks,
  }) => UserProfileModel(
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    phone: phone ?? this.phone,
    badgeLevel: badgeLevel ?? this.badgeLevel,
    bio: bio ?? this.bio,
    skills: skills ?? this.skills,
    socialLinks: socialLinks ?? this.socialLinks,
  );
}
