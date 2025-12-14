import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_quest/core/theme/app_colors.dart';
import '../../social/services/friend_service.dart';
import '../../social/domain/friend_models.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _viewMode = 'Global'; // Global or Friends
  String _timeFrame = 'This Week'; // This Week, This Month, All Time
  
  final _friendService = FriendService();
  List<SocialProfile> _friends = [];
  bool _isLoadingFriends = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
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
          const SizedBox(height: 16),
          // Time Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTimeChip('This Week'),
                const SizedBox(width: 8),
                _buildTimeChip('This Month'),
                const SizedBox(width: 8),
                _buildTimeChip('All Time'),
              ],
            ),
          ),
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

  Widget _buildTimeChip(String text) {
    final isSelected = _timeFrame == text;
    return GestureDetector(
      onTap: () => setState(() => _timeFrame = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : const Color(0xFF182830),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 10)]
              : null,
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
            fontWeight: FontWeight.bold,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPodium() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumItem(
            rank: 2,
            name: 'CyberG',
            xp: '15,400',
            level: 42,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBbvKIt27m_0Er_xjvAmZuCPc4Kf6G2pnRFXXNPExZTfr4hOfjo_FuNRxDf25Rdj7Lw5Ev7EGzTEvYhR37NdblkUeoOOVJcmyxja__EriveeWkFNMVjFp4KiUQk1CVyd1uaOnRzplSrCRsosuPsmkosRVk9GxezEJQE7QC9aCC9NFrXeKDXGldxbVdg7r6srZDA9_KKX8ehlx9qv6IIuEofacAvcAaeBgb1z1cU4BBfbgk_un6CSmeOInf1pV6oduQW2fd-zxLq-lPc',
            color: Colors.blueGrey.shade200,
            heightOffset: 0,
          ),
          const SizedBox(width: 8),
          _buildPodiumItem(
            rank: 1,
            name: 'NeoQueen',
            xp: '24,550 XP',
            level: 50,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAzIJNFPibvP7FYR1fJSSFCJyOygakXi0hJQAZsHJ73trq1LrlW_6gXDecNHXPVved9dc0k6b_eB3Aq3-heAD-1UschE0tnbZeKqlQ7fkW7vcJVU11zw75a0iyqOpHGGF0cCCLjlj0X--4xtzb2Y1JhSNhkH9TktNBjnobLBMD-0Z2wuykniuQIZekVFI0rtdlzGU_Q9qkAZ7-q-5SoIaP19eBQKcfbpG-G4axdJveidygr1GaA_MispvX1KTmY_T8ubYxyXMHYK6cz',
            color: AppColors.primary,
            isFirst: true,
             heightOffset: 20,
          ),
          const SizedBox(width: 8),
           _buildPodiumItem(
            rank: 3,
            name: 'Glitch_0',
            xp: '12,100',
            level: 38,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBUhyAkHIjjJaLoiNdvyLFy4y4BWbdjZ9yTe0AQtTeFz9Y3XoEpkmbBZP0LdNLhkq7nZmUPbiT-GHCukqlYarPWsXxYbZxv79NsIIxYJGhz705sqNQOkJAdlYVz4WLFBVwP5D_NU8jvQRHOtH2YAr-KpIRlLd8lq2d4BndUJvQEi3bhg0SdPtXIj95lfUG703oNpWqVS-28Jd3c8Py89gIns59u3Tv-M9O2JZ2nc-lia_aVeYpPBiCiUTkTs8XRd8-wTaK3CGLWxRr0',
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
                child: Image.network(imageUrl, fit: BoxFit.cover),
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
    if (_viewMode == 'Friends') {
       if (_isLoadingFriends) return const Center(child: CircularProgressIndicator());
       if (_friends.isEmpty) return const Center(child: Text("No friends linked yet.", style: TextStyle(color: Colors.white54)));
       
       return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: _friends.asMap().entries.map((entry) {
             final idx = entry.key;
             final friend = entry.value;
             return _buildListItem(
               idx + 1, 
               friend.username, 
               'Friend', 
               friend.level, 
               friend.xp, 
               friend.avatarUrl
             );
          }).toList(),
        ),
       );
    }

    // Default Global Mock
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildListItem(4, 'PixelHunter', 'Crypto Expert', 35, 10400, 'https://lh3.googleusercontent.com/aida-public/AB6AXuCRcPETN1sHUj-4yM1MRNHhNhLbZu_6KHgKRHTodq3M-7MLLQ13tiKk070B3HllH2rHu7XvkCtYTwUsfQPbpJ5-Top66PwlfJt_TTtEChqgE9Scy-S0FPEcnPL14rB0UAnvQhUVFnokD_igzHktQKFMy2EUMI1XgGFq6K_ZQfdC0E1_-_w23OXJD9unY_Ctjyr0WkFHa8Wbj1BjUYJEZ9oJqMtJIiBNN1VUQXylljlO5P18B1oz4owREijEXZY2g8a7P_N7MJkbrt_D'),
          _buildListItem(5, 'NetRunner_X', 'DeFi Master', 33, 9850, 'https://lh3.googleusercontent.com/aida-public/AB6AXuBZkPm0fQawxwv6PXa_HM_cngySqI-OeBNgc0bYH9nl4E_lVdvcXM27SKyUklZOJTU3gq3hPCoxUHoV5HLAtvqGr_FRcHcg1s6r8gpA55b6Z3UeEa4ft0m5Y81a0beguMZdq_lq2Uq-MwwkZZZtKNb-rrn29SjNrity8n3Q1nMwXL4Mvs72Ud3FqdhbPmIT4wLRMrqzAzyCoDKSY4IsyrET4gBB19GTwruLG4-lBZLKybSIrJNVUJyYMZwg0TEA_eDwzVH_HiJY7L2N'),
          _buildListItem(6, 'SatoshiSpirit', 'Rookie', 31, 9200, 'https://lh3.googleusercontent.com/aida-public/AB6AXuBGednp953IEXbVlgKyy_z_xP6ujgvOTII_hY_5bunGf1fHmws6UCwhFgZtiTAVtqlHLWTuuPB0sCztMm0O59hr7gbkhtpWpllhWe_OUi2M7cmXXIhYuQtJwTdIwCBHUMSORVk8JVslw7SnetHX6FIQd_EEpI0lVXjxnTRsnlqVEYrujcjd-HSk4hKVMAQYv_T7aY2W29oDgGV9SF5CU9s-_qSdWftP3UldvzZ0rWdJ-0zD8S5PG6YRZFLoH7xbYtxCkNrdoGAqs2HZ'),
          _buildListItem(7, 'KateChain', 'Investor', 30, 8900, 'https://lh3.googleusercontent.com/aida-public/AB6AXuDtJIzy9dX_wG6hyE9b85ZmlYDi55rflfg1C-PSgxi4Fz2BwjM9C7hFekD9M1pPULEna4kqDr1ReeVqzjp5Rv7s0Gnqhx7HujOko_VdTYXFoXlNCtQIREiC_7ffOBb9yPnT_hnP-aAEff-6Oa3asQsuj-hzwwKkA9jrQPrhR2_ulc0dlB0K_qaz32ELo_zbbLzVWtGbxQdiF6dWt_tag-SK4IjUgOTAbib6TvM9okXP0UVLrFZhe9aodexQoEJUghjt3Zje9Fjw7zBK'),
          _buildListItem(8, 'DriftKing', 'Trader', 29, 8450, null),
        ],
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
              child: imageUrl != null 
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : const Center(child: Text('DK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
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
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: const Color(0xFF182830).withOpacity(0.9),
        border: Border(top: BorderSide(color: AppColors.primary.withOpacity(0.2))),
      ),
      child: Row(
        children: [
           Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Icon(Icons.keyboard_double_arrow_up, color: AppColors.primary, size: 16),
               const Text('14', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
               child: Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuDw8nIWuL1XVwEE2uCvx7oS4K2WCnygGmUBU4_UWiHF_2oMTn0nh8BaQzE_E9znTsnIVK4MIEhpIrW4wVsHtdT0xZ5S_HeLNwKL7lhSDOzqePu_v0tA85bFNyl3uNMc9Z7fL2us1S2KTWhHruz4OC2dhMINAScWtVRc8RkM9bfceJHj0gOZqZMOUgpq3D7Gsp8sn8JbD9Ps2XIwgYuL0tY8RhH5SvBxJ_06vgJGt5sAiHzuhFtzuvKKPou6bP346EdZHqWZYrm_qz1A', fit: BoxFit.cover),
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
                     SizedBox(
                       width: 100,
                       height: 6,
                       child: LinearProgressIndicator(
                         value: 0.7,
                         backgroundColor: Colors.blueGrey.shade700,
                         valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                         borderRadius: BorderRadius.circular(3),
                       ),
                     ),
                     const SizedBox(width: 8),
                     Text('70% to Lvl 29', style: TextStyle(color: AppColors.primary, fontSize: 10)),
                   ],
                 ),
               ],
             ),
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text('7,240', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'monospace', shadows: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 8)])),
               const Text('Total XP', style: TextStyle(color: Colors.grey, fontSize: 10)),
             ],
           ),
        ],
      ),
    );
  }
}
