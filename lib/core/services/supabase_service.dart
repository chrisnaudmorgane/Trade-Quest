import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> initialize({required String url, required String anonKey}) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  // Auth Methods
  User? get currentUser => client.auth.currentUser;

  Future<AuthResponse> signInAnonymously() async {
    return await client.auth.signInAnonymously();
  }

  Future<bool> signInWithGoogle() async {
    try {
      // Use kIsWeb check if needed, but for mobile deep link is key
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.tradequest://login-callback/',
      );

      // Note: This might not be awaited properly if deep link returns instantly
      // Ideally this goes into an AuthStateListener in main.dart or a Provider.
      // But for simple flow, we can check session after navigation
      return true;
    } catch (e) {
      print('Google Sign In Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Data Methods
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      // Return null or handle error if table doesn't exist yet
      return null;
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    String? country,
    String? phoneNumber,
    String? knowledgeLevel,
    List<String>? interests,
    String? incomeRange,
    String? financialGoal,
    String? fcmToken,
  }) async {
    final updates = {
      'id': userId,
      'updated_at': DateTime.now().toIso8601String(),
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (country != null) 'country': country,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (knowledgeLevel != null) 'knowledge_level': knowledgeLevel,
      if (interests != null) 'interests': interests,
      if (incomeRange != null) 'income_range': incomeRange,
      if (financialGoal != null) 'financial_goal': financialGoal,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
    await client.from('profiles').upsert(updates);
  }

  Future<void> ensureProfileExists({
      required String userId,
      required String email,
      String? username,
      String? avatarUrl,
  }) async {
    final existing = await getProfile(userId);
    if (existing == null) {
      // Create new profile
      final usernameFromEmail = email.split('@').first;
      await client.from('profiles').insert({
        'id': userId,
        'username': username ?? usernameFromEmail,
        'avatar_url': avatarUrl,
        'created_at': DateTime.now().toIso8601String(),
        'xp': 0,
        'rank': 0,
       });
    }
  }

  Future<void> updateUserXp(String userId, int amount) async {
    try {
      final profile = await getProfile(userId);
      if (profile != null) {
        final currentXp = profile['xp'] as int? ?? 0;
        final newXp = currentXp + amount;
        
        await client.from('profiles').update({
          'xp': newXp,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);
      }
    } catch (e) {
      print('Error updating XP: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({String timeFrame = 'weekly'}) async {
    try {
      // Example query - adjust based on actual schema
      final response = await client
          .from('profiles')
          .select('id, username, avatar_url, xp')
          .order('xp', ascending: false)
          .limit(50);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getQuests({String? category, String language = 'fr'}) async {
    try {
      var query = client.from('quests').select();
      
      // Filter by language
      query = query.eq('language', language);

      if (category != null && category != 'All Quests') {
        query = query.eq('category', category);
      }
      
      // Privacy Logic: Show public quests (user_id is null) OR my quests
      final user = currentUser;
      if (user != null) {
        query = query.or('user_id.is.null,user_id.eq.${user.id}');
      } else {
        query = query.filter('user_id', 'is', null);
      }

      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching quests from DB: $e');
      return [];
    }
  }

  Future<void> saveQuests(List<Map<String, dynamic>> quests) async {
    try {
      await client.from('quests').insert(quests);
    } catch (e) {
      print('Error saving quests to DB: $e');
    }
  }

  Future<void> completeQuest(String userId, String questId, int xp) async {
    try {
      // 1. Insert into user_quests
      await client.from('user_quests').insert({
        'user_id': userId,
        'quest_id': questId,
        'status': 'completed',
        'completed_at': DateTime.now().toIso8601String(),
        // 'earned_xp': xp, // Removed: Column does not exist
      });

      // 2. Update user XP
      await updateUserXp(userId, xp);
      
    } catch (e) {
      print('Error completing quest: $e');
    }
  }

  Future<String?> createCustomQuest(String title) async {
    try {
      final response = await client.from('quests').insert({
        'title': title,
        'subtitle': 'Custom Request',
        'tag': 'Entrepreneur', 
        'xp': 150,
        'icon': 'brain',
        'description': 'AI Generated Custom Lesson',
        'category': 'Custom',
        'language': 'fr',
        'user_id': client.auth.currentUser?.id
      }).select().single();
      
      return response['id'] as String;
    } catch (e) {
      print('Error creating custom quest: $e');
      return null;
    }
  }

  Future<Set<String>> getCompletedQuestIds(String userId) async {
    try {
      final response = await client
          .from('user_quests')
          .select('quest_id')
          .eq('user_id', userId)
          .eq('status', 'completed');
      
      return (response as List).map((e) => e['quest_id'] as String).toSet();
    } catch (e) {
      return {};
    }
  }

  Future<int> getCompletedQuestCount(String userId) async {
    try {
      final response = await client
          .from('user_quests')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'completed')
          .count(CountOption.exact);
      
      return response.count;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getUserQuests(String userId) async {
    try {
      // Join queries are tricky with simple syntax, so we might need to fetch user_quests and then enrich with quest details
      // Or use a precise select if foreign keys are set up correctly: 
      // select('*, quests(*)')
      
      final response = await client
          .from('user_quests')
          .select('*, quests(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5); // Show last 5
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user quests: $e');
      return [];
    }
  }

  Future<int> getUserRank(int xp) async {
    try {
      final response = await client
          .from('profiles')
          .select('id')
          .gt('xp', xp)
          .count(CountOption.exact);
      
      return (response.count) + 1;
    } catch (e) {
      return 0;
    }
  }

  Future<void> updateStreak() async {
    try {
      await client.rpc('update_streak');
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserBadges(String userId) async {
    try {
      final response = await client
          .from('user_badges')
          .select('*, badges(*)')
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching badges: $e');
      return [];
    }
  }
}
