class UserProfileModel {
  final String id;
  final String? fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? dateOfBirth;
  final String? bio;
  final bool notificationsEnabled;
  final String theme; // 'light', 'dark', 'system'
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.id,
    this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.address,
    this.city,
    this.country,
    this.dateOfBirth,
    this.bio,
    this.notificationsEnabled = true,
    this.theme = 'system',
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      email: json['email'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth']) 
          : null,
      bio: json['bio'],
      notificationsEnabled: json['notifications_enabled'] ?? true,
      theme: json['theme'] ?? 'system',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'address': address,
      'city': city,
      'country': country,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'bio': bio,
      'notifications_enabled': notificationsEnabled,
      'theme': theme,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? bio,
    bool? notificationsEnabled,
    String? theme,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => fullName ?? email.split('@').first;
  
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final names = fullName!.trim().split(' ');
      if (names.length >= 2) {
        return '${names.first[0]}${names.last[0]}'.toUpperCase();
      } else {
        return names.first[0].toUpperCase();
      }
    }
    return email.isNotEmpty ? email[0].toUpperCase() : '?';
  }
}