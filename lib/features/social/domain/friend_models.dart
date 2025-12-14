enum FriendshipStatus {
  none,
  pending,
  accepted,
  blocked,
}

class SocialProfile {
  final String id;
  final String username;
  final String handle; // e.g., @cyber_ninja
  final String avatarUrl;
  final int level;
  final int xp;
  final FriendshipStatus status;
  final bool isOnline;

  const SocialProfile({
    required this.id,
    required this.username,
    required this.handle,
    required this.avatarUrl,
    required this.level,
    required this.xp,
    this.status = FriendshipStatus.none,
    this.isOnline = false,
  });

  // Factory for mocking
  factory SocialProfile.mock({
    required String id,
    required String username,
    required String handle,
    required String avatarUrl,
    int level = 1,
    FriendshipStatus status = FriendshipStatus.none,
  }) {
    return SocialProfile(
      id: id,
      username: username,
      handle: handle,
      avatarUrl: avatarUrl,
      level: level,
      xp: level * 1000, // Dummy XP logic
      status: status,
    );
  }

  factory SocialProfile.fromJson(Map<String, dynamic> json) {
    return SocialProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      handle: json['handle'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      status: _parseStatus(json['status'] as String?),
      isOnline: json['is_online'] as bool? ?? false,
    );
  }

  static FriendshipStatus _parseStatus(String? status) {
    switch (status) {
      case 'accepted': return FriendshipStatus.accepted;
      case 'pending': return FriendshipStatus.pending;
      case 'blocked': return FriendshipStatus.blocked;
      default: return FriendshipStatus.none;
    }
  }
}
