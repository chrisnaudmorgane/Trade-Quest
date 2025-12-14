import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../domain/friend_models.dart';

class FriendService {
  static final FriendService _instance = FriendService._internal();
  factory FriendService() => _instance;
  FriendService._internal();

  SupabaseClient get _client => SupabaseService().client;
  String? get _currentUserId => _client.auth.currentUser?.id;

  // Real Data: Top Targets (Leaderboard by XP)
  Future<List<SocialProfile>> getTopTargets() async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .order('xp', ascending: false)
          .limit(10); // Check top 10

      final List<dynamic> data = response;
      return data.map((json) => SocialProfile.fromJson(_mapProfile(json))).toList();
    } catch (e) {
      print('Error fetching Top Targets: $e');
      return [];
    }
  }

  // Real Data: Detected Signals (Newest Users or Random)
  Future<List<SocialProfile>> getDetectedSignals() async {
    try {
      // Fetch users created recently or just standard profiles excluding current
      final response = await _client
          .from('profiles')
          .select()
          .neq('id', _currentUserId ?? '')
          .order('created_at', ascending: false)
          .limit(20);

      final List<dynamic> data = response;
      return data.map((json) => SocialProfile.fromJson(_mapProfile(json))).toList();
    } catch (e) {
      print('Error fetching Detected Signals: $e');
      return [];
    }
  }

  // Real Data: Friends
  Future<List<SocialProfile>> getFriends() async {
    final uid = _currentUserId;
    if (uid == null) return [];

    try {
      // Assuming a 'friendships' table exists: 
      // id, user_id, friend_id, status
      // We need to fetch profiles of friends. 
      // This is a complex join. For simplicity, we might query friendships then profiles.
      
      // 1. Get confirmed friend IDs
      final friendships = await _client
          .from('friendships')
          .select('friend_id')
          .eq('user_id', uid)
          .eq('status', 'accepted');

      final List<String> friendIds = (friendships as List)
          .map((f) => f['friend_id'] as String)
          .toList();

      if (friendIds.isEmpty) return [];

      // 2. Get Profiles for those IDs
      final profilesResponse = await _client
          .from('profiles')
          .select()
          .inFilter('id', friendIds);

      final List<dynamic> data = profilesResponse;
      return data.map((json) {
        var profile = _mapProfile(json);
        profile['status'] = 'accepted'; // Force status for UI
        return SocialProfile.fromJson(profile);
      }).toList();

    } catch (e) {
      print('Error fetching Friends (Table might not exist): $e');
      return [];
    }
  }

  // Helper to map Supabase 'profiles' to SocialProfile JSON format
  Map<String, dynamic> _mapProfile(Map<String, dynamic> raw) {
    return {
      'id': raw['id'],
      'username': raw['username'] ?? 'Unknown',
      'handle': '@${(raw['username'] as String?)?.replaceAll(' ', '').toLowerCase() ?? 'user'}',
      'avatar_url': raw['avatar_url'] ?? '',
      'level': _calculateLevel(raw['xp'] ?? 0),
      'xp': raw['xp'] ?? 0,
      'status': 'none', // Default, updated by caller if needed
    };
  }

  int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }
}
