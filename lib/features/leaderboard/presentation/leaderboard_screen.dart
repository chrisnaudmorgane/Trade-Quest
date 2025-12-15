import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_quest/core/theme/app_colors.dart';
import '../../social/services/friend_service.dart';
import '../../social/domain/friend_models.dart';
import 'package:trade_quest/core/services/supabase_service.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _viewMode = 'Global'; 
  
  final _friendService = FriendService();
  List<SocialProfile> _friends = [];
  bool _isLoadingFriends = false;

  bool _isLoadingGlobal = false;
  List<SocialProfile> _globalLeaderboard = [];

  // User Stats state
  Map<String, dynamic>? _myProfile;
  int _myRank = 0;
  
  @override
  void initState() {
    super.initState();
    _loadFriends();
    _loadGlobalLeaderboard();
    _loadMyStats();
  }

  Future<void> _loadMyStats() async {
    final user = SupabaseService().currentUser;
    if (user != null) {
      final profile = await SupabaseService().getProfile(user.id);
      final xp = profile?['xp'] as int? ?? 0;
      final rank = await SupabaseService().getUserRank(xp);
      
      if (mounted) {
        setState(() {
          _myProfile = profile;
          _myRank = rank;
        });
      }
    }
  }

  Future<void> _loadGlobalLeaderboard() async {
    setState(() => _isLoadingGlobal = true);
    final data = await SupabaseService().getLeaderboard(); 
    
    final profiles = data.map((json) {
       final xp = json['xp'] as int? ?? 0;
       return SocialProfile(
         id: json['id'],
         username: json['username'] ?? 'Unknown',
         handle: '@${json['username'] ?? 'unknown'}',
         avatarUrl: json['avatar_url'] ?? '',
         level: (xp / 1000).floor() + 1,
         xp: xp,
       );
    }).toList();

    if (mounted) {
      setState(() {
        _globalLeaderboard = profiles;
        _isLoadingGlobal = false;
      });
    }
  }
  

  Future<void> _loadFriends() async {
    setState(() => _isLoadingFriends = true);
    final friends = await _friendService.getFriends();
    if (mounted) {
      setState(() {
        _friends = friends;
        _isLoadingFriends = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
             child: Container(
               color: AppColors.backgroundDark,
             ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                 Expanded(
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                         _buildControls(),
                         const SizedBox(height: 20),
                         _buildPodium(),
                         const SizedBox(height: 24),
                         _buildList(),
                         const SizedBox(height: 100), // Spacing for footer
                       ],
                     ),
                   ),
                 ),
              ],
            ),
          ),

          // Sticky Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassIconButton(Icons.arrow_back, () => context.pop()),
          Text(
            'LEADERBOARD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10),
              ],
            ),
          ),
          _buildGlassIconButton(Icons.info_outline, () {}),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Global / Friends Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF182830),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                _buildSegmentButton('Global', _viewMode == 'Global'),
                _buildSegmentButton('Friends', _viewMode == 'Friends'),
              ],
            ),
          ),
          // Chips removed as requested
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF23343D) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4)] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // _buildTimeChip removed

  Widget _buildPodium() {
    final list = _viewMode == 'Friends' ? _friends : _globalLeaderboard;
    if (list.length < 3) return const SizedBox.shrink(); 

    list.sort((a, b) => b.xp.compareTo(a.xp));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (list.length > 1)
          _buildPodiumItem(
            rank: 2,
            name: list[1].username,
            xp: '${list[1].xp} XP',
            level: list[1].level,
            imageUrl: list[1].avatarUrl,
            color: Colors.blueGrey.shade200,
            heightOffset: 0,
          ),
          const SizedBox(width: 8),
          if (list.isNotEmpty)
          _buildPodiumItem(
            rank: 1,
            name: list[0].username,
            xp: '${list[0].xp} XP',
            level: list[0].level,
            imageUrl: list[0].avatarUrl,
            color: AppColors.primary,
            isFirst: true,
             heightOffset: 20,
          ),
          const SizedBox(width: 8),
           if (list.length > 2)
           _buildPodiumItem(
            rank: 3,
            name: list[2].username,
            xp: '${list[2].xp} XP',
            level: list[2].level,
            imageUrl: list[2].avatarUrl,
            color: const Color(0xFFB45309), // Bronze/Amber
             heightOffset: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem({
    required int rank,
    required String name,
    required String xp,
    required int level,
    required String imageUrl,
    required Color color,
    bool isFirst = false,
    double heightOffset = 0,
  }) {
    return Column(
      children: [
        if (isFirst)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Icon(Icons.stars, color: Colors.yellow, size: 32),
        ),
         if (!isFirst)
           Text('#$rank', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
         const SizedBox(height: 4),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: isFirst ? 110 : 80,
              height: isFirst ? 110 : 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color, width: 2),
                color: const Color(0xFF182830),
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.3), blurRadius: 15),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: color.withOpacity(0.2), child: Icon(Icons.person, color: color))),
              ),
            ),
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isFirst ? color : color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 4)],
                  ),
                  child: Text(
                    'Lvl $level',
                    style: TextStyle(
                      color: isFirst ? Colors.black : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isFirst ? 18 : 14,
            shadows: isFirst ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 10)] : null,
          ),
        ),
        Text(
          xp,
          style: TextStyle(
            color: isFirst ? color : const Color(0xFF94A3B8),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    final list = _viewMode == 'Friends' ? _friends : _globalLeaderboard;
    final isLoading = _viewMode == 'Friends' ? _isLoadingFriends : _isLoadingGlobal;

    if (isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    if (list.isEmpty) return const Center(child: Text("No data available.", style: TextStyle(color: Colors.white54)));

    // Skip top 3
    if (list.length <= 3) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: list.skip(3).toList().asMap().entries.map((entry) {
           final idx = entry.key + 3; // +3 because we skipped 3
           final profile = entry.value;
           return _buildListItem(
             idx + 1, 
             profile.username, 
             profile.handle, 
             profile.level, 
             profile.xp, 
             profile.avatarUrl
           );
        }).toList(),
      ),
    );
  }


  Widget _buildListItem(int rank, String name, String subtitle, int level, int xp, String? imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF182830),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              rank.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.person, color: Colors.white))
                : const Center(child: Icon(Icons.person, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('Lvl $level', style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 10)),
                    ),
                  ],
                ),
                Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          Text(
            xp.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace', shadows: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 8)]),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final xp = _myProfile?['xp'] as int? ?? 0;
    final level = (xp / 1000).floor() + 1;
    final nextLevelXp = level * 1000;
    final currentLevelBaseXp = (level - 1) * 1000;
    final progress = (xp - currentLevelBaseXp) / (nextLevelXp - currentLevelBaseXp);
    final percentage = (progress * 100).floor();
    
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: const Color(0xFF182830).withOpacity(0.95),
        border: Border(top: BorderSide(color: AppColors.primary.withOpacity(0.2))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
           Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Icon(_myRank <= 3 ? Icons.emoji_events : Icons.keyboard_double_arrow_up, color: _myRank <= 3 ? Colors.yellow : AppColors.primary, size: 16),
               Text(_myRank == 0 ? '--' : '#$_myRank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
             ],
           ),
           const SizedBox(width: 16),
           Container(
             width: 48,
             height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10)],
              ),
             padding: const EdgeInsets.all(2),
             child: ClipRRect(
               borderRadius: BorderRadius.circular(6),
               child: _myProfile?['avatar_url'] != null
                   ? Image.network(_myProfile!['avatar_url'], fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.person, color: Colors.white))
                   : const Icon(Icons.person, color: Colors.white),
             ),
           ),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: [
                 const Text('You', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                 Row(
                   children: [
                     Expanded(
                       child: SizedBox(
                         height: 6,
                         child: LinearProgressIndicator(
                           value: progress.clamp(0.0, 1.0),
                           backgroundColor: Colors.blueGrey.shade700,
                           valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                           borderRadius: BorderRadius.circular(3),
                         ),
                       ),
                     ),
                     const SizedBox(width: 8),
                     Text('$percentage% to Lvl ${level + 1}', style: const TextStyle(color: AppColors.primary, fontSize: 10)),
                   ],
                 ),
               ],
             ),
           ),
           const SizedBox(width: 12),
           Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(xp.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'monospace', shadows: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 8)])),
               const Text('Total XP', style: TextStyle(color: Colors.grey, fontSize: 10)),
             ],
           ),
        ],
      ),
    );
  }
}
