import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:trade_quest/core/theme/app_colors.dart';
import '../../social/domain/friend_models.dart';
import '../../social/services/friend_service.dart';

class LinkAgentsScreen extends StatefulWidget {
  const LinkAgentsScreen({super.key});

  @override
  State<LinkAgentsScreen> createState() => _LinkAgentsScreenState();
}

class _LinkAgentsScreenState extends State<LinkAgentsScreen> {
  final _friendService = FriendService();
  final _searchController = TextEditingController();

  List<SocialProfile> _topTargets = [];
  List<SocialProfile> _detectedSignals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final targets = await _friendService.getTopTargets();
    final signals = await _friendService.getDetectedSignals();
    if (mounted) {
      setState(() {
        _topTargets = targets;
        _detectedSignals = signals;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Scanline Effect (Subtle Overlay)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.02),
                    ],
                    stops: const [0.5, 0.5],
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                 _buildHeader(context),
                 _buildSearchBar(),
                 _buildSystemStatus(),
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('RADAR', 'TOP TARGETS'),
                            const SizedBox(height: 12),
                            ..._topTargets.map((p) => _buildAgentCard(p)),
                            const SizedBox(height: 24),
                            
                            const Divider(color: Colors.white10),
                            const SizedBox(height: 16),

                            _buildSectionHeader('WIFI_TETHERING', 'DETECTED SIGNALS'),
                            const SizedBox(height: 12),
                            ..._detectedSignals.map((p) => _buildAgentCard(p)), 

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Back button removed
          Text(
            'LINK AGENTS',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          // Scan button removed
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
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16262E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
          ]
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Search username or email...',
            hintStyle: GoogleFonts.notoSans(color: Colors.white30),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            suffixIcon: const Icon(Icons.mic, color: Colors.white54),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SYSTEM: ONLINE',
            style: GoogleFonts.shareTechMono(
              color: AppColors.primary.withOpacity(0.7),
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          Row(
            children: [
              Container(
                 width: 6, height: 6,
                 decoration: const BoxDecoration(
                   color: AppColors.neonGreen,
                   shape: BoxShape.circle,
                 ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .fadeIn(duration: 600.ms).fadeOut(duration: 600.ms),
              const SizedBox(width: 4),
              Text(
                'SCANNING',
                style: GoogleFonts.shareTechMono(
                  color: AppColors.primary.withOpacity(0.7),
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String iconName, String title) {
    IconData icon;
    if (iconName == 'RADAR') icon = Icons.radar;
    else icon = Icons.wifi_tethering;

    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAgentCard(SocialProfile profile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16262E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(profile.avatarUrl, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: -2, right: -2,
                child: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: profile.isOnline || true ? AppColors.neonGreen : Colors.grey, // Force online for visual match
                     shape: BoxShape.circle,
                     border: Border.all(color: const Color(0xFF16262E), width: 2),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.username,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${profile.handle} • Level ${profile.level}',
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Add Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Text(
                  'ADD',
                   style: GoogleFonts.spaceGrotesk(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.add, color: AppColors.primary, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
