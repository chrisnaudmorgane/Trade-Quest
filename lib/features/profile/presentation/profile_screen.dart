import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_quest/core/theme/app_colors.dart';
import 'package:trade_quest/core/services/supabase_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = SupabaseService().currentUser;
    if (user != null) {
      // 1. Update streak logic first
      await SupabaseService().updateStreak();

      final profile = await SupabaseService().getProfile(user.id);
      final questCount = await SupabaseService().getCompletedQuestCount(user.id);
      final userQuests = await SupabaseService().getUserQuests(user.id);
      final userBadges = await SupabaseService().getUserBadges(user.id);
      final xp = profile?['xp'] ?? 0;
      final rank = await SupabaseService().getUserRank(xp);
      
      if (mounted) {
        setState(() {
          _profile = profile;
          if (_profile != null) {
            _profile!['quest_count'] = questCount;
            _profile!['calculated_rank'] = rank;
            _profile!['recent_quests'] = userQuests;
            _profile!['user_badges'] = userBadges;
          }
          _isLoading = false;
        });
      }
    } else {
        setState(() => _isLoading = false);
    }
  }

  Future<void> _shareProgress() async {
    final username = _profile?['username'] ?? 'Fellow Trader';
    final xp = _profile?['xp'] ?? 0;
    final level = (xp <= 0) ? 1 : (sqrt(xp / 2500).floor()) + 1;
    final rank = _profile?['calculated_rank'] ?? 0;
    
    // Pass data to new screen
    context.push('/share-achievement', extra: {
      'type': 'profile',
      'data': {
        'username': username,
        'level': level,
        'xp': xp,
        'rank': rank,
        'streak': _profile?['streak'] ?? 0,
        'badges': _profile?['user_badges'] ?? [],
      }
    });
  }

  Widget _buildShareCard() {
    final username = _profile?['username'] ?? 'Fellow Trader';
    final xp = _profile?['xp'] ?? 0;
    final level = (xp <= 0) ? 1 : (sqrt(xp / 2500).floor()) + 1;
    final rank = _profile?['calculated_rank'] ?? 0;
    final streak = _profile?['streak'] ?? 0;
    final badges = _profile?['user_badges'] as List<Map<String, dynamic>>? ?? [];

    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark Background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRADEQUEST',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IDENTITÉ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PROFIL OPÉRATEUR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(Icons.shield, color: AppColors.primary, size: 48),
            ],
          ),
          const SizedBox(height: 32),
          
          // Agent Info
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundDark,
                  border: Border.all(color: AppColors.primary),
                ),
                child: Icon(Icons.face_6, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                     username,
                     style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NIVEAU $level STRATÈGE',
                      style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareStat('SÉRIE', '$streak Jours', Icons.local_fire_department, Colors.amber),
              _buildShareStat('RANG', '#$rank', Icons.leaderboard, AppColors.success),
              _buildShareStat('BADGES', '${badges.length}', Icons.military_tech, AppColors.neonPurple),
            ],
          ),
          
          const SizedBox(height: 32),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.download, color: Colors.white70, size: 16),
                 SizedBox(width: 8),
                 Text(
                   'Joue Gratuitement sur tradequest.app',
                   style: TextStyle(color: Colors.white70, fontSize: 12),
                 ),
               ],
             )
        ],
      ),
    );
  }

  Widget _buildShareStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, letterSpacing: 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildProfileHeader(),
                        const SizedBox(height: 24),
                        _buildStatsGrid(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Neural Badges', AppColors.primary, () {}),
                        const SizedBox(height: 12),
                        _buildBadgesScroll(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Quest Log', AppColors.success, null), // Quest Log
                        const SizedBox(height: 12),
                        _buildQuestLog(),
                        const SizedBox(height: 80), // Footer spacing
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger menu removed
          const SizedBox(width: 48), // Spacer to balance Settings button if we want centering, or just remove. 
          // Actually, let's just use SizedBox to trigger "Start/End" with spaceBetween correctly or just remove. 
          // User said "remove", I will replace with SizedBox.shrink() or just empty. 
          // Let's replace with empty and let alignment happen, or better, keep the layout balanced?
          // I will replace with a SizedBox(width: 48) to keep the text centered if possible, assuming the right icon is 48.
          // Standard IconButton is 48x48 usually.
          const SizedBox(width: 48),
          Column(
            children: [
              Text(
                'IDENTITÉ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Profil Opérateur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
             onPressed: () => context.push('/settings'),
             icon: const Icon(Icons.settings, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final username = _profile?['username'] ?? 'Unknown Agent';
    final avatarUrl = _profile?['avatar_url'] as String?;
    final xp = _profile?['xp'] ?? 0;
    final level = (xp <= 0) ? 1 : (sqrt(xp / 2500).floor()) + 1;
    // XP for next level L+1: 2500 * (L)^2
    final nextLevelXp = (2500 * pow(level, 2)).toInt();
    
    // XP for current level L: 2500 * (L-1)^2
    final currentLevelBaseXp = (2500 * pow(level - 1, 2)).toInt();
    
    final progress = (xp - currentLevelBaseXp) / (nextLevelXp - currentLevelBaseXp);
    final xpToNext = nextLevelXp - xp;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF16262E),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.face_6, size: 60, color: Color(0xFFE2E8F0)),
                    )
                  : const Icon(Icons.face_6, size: 60, color: Color(0xFFE2E8F0)),
            ),
             Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 8)],
                ),
                child: Text('Lvl $level', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          username,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'CLASSE STRATÈGE FINANCIER',
          style: TextStyle(color: Color(0xFF315668), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16262E).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF315668).withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('XP Actuel', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '$xp', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                        TextSpan(text: ' / $nextLevelXp', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.toDouble(),
                  minHeight: 8,
                  backgroundColor: AppColors.backgroundDark,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                 alignment: Alignment.centerLeft,
                 child: Text('$xpToNext XP vers Niveau ${level + 1}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _shareProgress,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.share, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'PARTAGER PROGRÈS', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 1,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final questCount = _profile?['quest_count'] ?? 0;
    final rank = _profile?['calculated_rank'] ?? 0;
    final streak = _profile?['streak'] ?? 0;

    return Row(
      children: [
        _buildStatItem(Icons.local_fire_department, '$streak', 'Série (Jours)', Colors.amber),
        const SizedBox(width: 8),
        _buildStatItem(Icons.verified_user, '$questCount', 'Quêtes Terminées', AppColors.success),
        const SizedBox(width: 8),
        _buildStatItem(Icons.leaderboard, '#$rank', 'Rang Global', AppColors.primary),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF16262E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF315668).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label.toUpperCase(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 8, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, VoidCallback? onMore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
           children: [
             Container(height: 16, width: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
             const SizedBox(width: 8),
             Text(title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
           ],
        ),
        if (onMore != null)
             GestureDetector(
               onTap: onMore,
               child: Text('Voir Tout', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
             ),
      ],
    );
  }

  Widget _buildBadgesScroll() {
    final userBadges = _profile?['user_badges'] as List<Map<String, dynamic>>? ?? [];
    
    // If no badges, show placeholders or locked ones
    /* 
       Ideally we fetch ALL badges and check which ones the user has. 
       For now, let's just show the user's earned badges, plus a few locked placeholders if empty.
    */
    
    List<Widget> badgeWidgets = [];

    if (userBadges.isNotEmpty) {
      badgeWidgets = userBadges.map((ub) {
        final badge = ub['badges'] as Map<String, dynamic>;
        final colorHex = badge['color_hex'] as String? ?? '0xFF2196F3';
        final color = Color(int.parse(colorHex)); // Parse hex
        
        // Icon mapping
        IconData icon = Icons.star;
         final iconName = badge['icon'] as String? ?? 'star';
        if (iconName == 'savings') icon = Icons.savings;
        else if (iconName == 'trending_up') icon = Icons.trending_up;
        else if (iconName == 'psychology') icon = Icons.psychology;
        else if (iconName == 'apartment') icon = Icons.apartment;

        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _buildBadgeItem(icon, badge['name'].replaceAll(' ', '\n'), color),
        );
      }).toList();
    }
    
    // Always append some "Locked" examples to motivate, if list is short
    if (badgeWidgets.length < 3) {
       badgeWidgets.add(const SizedBox(width: 16));
       badgeWidgets.add(_buildBadgeItem(Icons.lock, 'Estate\nTycoon', Colors.grey, isLocked: true));
       badgeWidgets.add(const SizedBox(width: 16));
       badgeWidgets.add(_buildBadgeItem(Icons.lock, 'Whale\nStatus', Colors.grey, isLocked: true));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: badgeWidgets,
      ),
    );
  }

  Widget _buildBadgeItem(IconData icon, String label, Color color, {bool isLocked = false}) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF16262E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isLocked ? Colors.grey.withOpacity(0.3) : color.withOpacity(0.4)),
            boxShadow: isLocked ? null : [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10)],
          ),
          child: Icon(icon, color: isLocked ? Colors.grey : color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isLocked ? Colors.grey : const Color(0xFFCBD5E1),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestLog() {
    final quests = _profile?['recent_quests'] as List<Map<String, dynamic>>? ?? [];

    if (quests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF16262E).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF315668).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.history_edu, color: const Color(0xFF64748B), size: 40),
            const SizedBox(height: 12),
            const Text(
              'Aucune mission enregistrée.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: quests.map((userQuest) {
        final questData = userQuest['quests'] as Map<String, dynamic>? ?? {};
        final status = userQuest['status'] as String? ?? 'unknown';
        final isCompleted = status == 'completed';
        final color = isCompleted ? AppColors.success : Colors.amber;
        
        // Icon mapping
        IconData iconData = Icons.help_outline;
        final iconName = questData['icon'] as String? ?? 'help';
        if (iconName == 'wallet') iconData = Icons.account_balance_wallet;
        else if (iconName == 'chart') iconData = Icons.show_chart;
        else if (iconName == 'currency') iconData = Icons.currency_bitcoin;
        else if (iconName == 'warning') iconData = Icons.warning_amber;
        else if (iconName == 'brain') iconData = Icons.psychology;
        else if (iconName == 'house') iconData = Icons.house;
        else if (iconName == 'globe') iconData = Icons.public;
        else if (iconName == 'computer') iconData = Icons.computer;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildQuestItem(
            icon: iconData,
            title: questData['title'] ?? 'Mission Inconnue',
            subtitle: questData['category'] ?? 'Général',
            xp: '+${questData['xp'] ?? 0} XP',
            status: status,
            time: '',
            color: color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String xp,
    required String status,
    required String time,
    required Color color,
    bool isLocked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16262E),
        border: Border(left: BorderSide(color: isLocked ? Colors.grey.withOpacity(0.5) : color, width: 2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: isLocked ? Colors.grey : color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isLocked ? Colors.grey : Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Text('$subtitle • ', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                    Text(xp, style: TextStyle(color: isLocked ? Colors.grey : color, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          if (!isLocked)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                 decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                 child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
               ),
               if (time.isNotEmpty) Text(time, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
            ],
          )
          else
            const Icon(Icons.lock, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}
