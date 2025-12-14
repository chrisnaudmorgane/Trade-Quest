import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:trade_quest/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _questsFuture;
  String _selectedCategory = 'All Quests';
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRefreshQuests();
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final user = SupabaseService().currentUser;
    if (user != null) {
      final profile = await SupabaseService().getProfile(user.id);
      if (mounted) {
        setState(() {
          _profile = profile;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchQuests();
  }

  Future<void> _checkAndRefreshQuests() async {
    final language = Localizations.localeOf(context).languageCode;
    
    // 1. Check if we need to generate new quests (Simple logic: check if latest quest is older than 24h)
    // For this MVP, we fetch all quests first to check titles and timestamp
    final allQuests = await SupabaseService().getQuests(language: language);
    
    if (allQuests.isEmpty) {
        // Initial seed needed if empty? No, we have seed data.
        _fetchQuests();
        return;
    }

    final latestQuest = allQuests.last; // Assuming sorted by created_at in getQuests
    final createdAt = DateTime.parse(latestQuest['created_at']);
    final difference = DateTime.now().difference(createdAt);
    
    // DEBUG: Force refresh if requested or just use 24h (1440 mins)
    // Using 24 hours for production logic
    if (difference.inHours > 24) {
      print('Quests are stale (>24h). Generating fresh content...');
      final existingTitles = allQuests.map((q) => q['title'] as String).toList();
      
      try {
        final newQuests = await GeminiService().getAvailableQuests(
            excludedTitles: existingTitles,
            language: language,
        );
        if (newQuests.isNotEmpty) {
           // Inject language into the new quests before saving
           final questsToSave = newQuests.map((q) => {...q, 'language': language}).toList();
           await SupabaseService().saveQuests(questsToSave);
           print('Fresh quests saved to DB.');
        }
      } catch (e) {
        print('Smart Refresh failed: $e');
      }
    } else {
      print('Quests are fresh. Next refresh in ${24 - difference.inHours} hours.');
    }

    // 2. Load the UI
    _fetchQuests();
  }

  void _fetchQuests() {
    final language = Localizations.localeOf(context).languageCode;
    _questsFuture = SupabaseService().getQuests(category: _selectedCategory, language: language);
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _fetchQuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Grid Effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: SvgPicture.network(
                'https://grainy-gradients.vercel.app/noise.svg', 
                fit: BoxFit.cover,
                placeholderBuilder: (_) => const SizedBox(), 
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                            l10n.selectMission,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.neonGreen,
                                  shape: BoxShape.circle,
                                ),
                              ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 1000.ms),
                              const SizedBox(width: 8),
                              Text(
                                l10n.systemOnline,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                      
                      // User Avatar & Level
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          padding: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${l10n.level} ${((_profile?['xp'] ?? 0) / 1000).floor() + 1}',
                                style: const TextStyle(
                                  color: AppColors.neonPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primary, AppColors.neonPurple],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.backgroundDark,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person, size: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 2. Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: l10n.searchPlaceholder,
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.tune, size: 20, color: AppColors.textSecondary),
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),

                // 3. Filter Chips
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    children: [
                      _buildChip('All Quests', isActive: _selectedCategory == 'All Quests', onTap: () => _onCategorySelected('All Quests')),
                      _buildChip('Crypto', isActive: _selectedCategory == 'Crypto', onTap: () => _onCategorySelected('Crypto')),
                      _buildChip('Stocks', isActive: _selectedCategory == 'Stocks', onTap: () => _onCategorySelected('Stocks')),
                      _buildChip('RealEstate', isActive: _selectedCategory == 'RealEstate', onTap: () => _onCategorySelected('RealEstate')),
                      _buildChip('Business', isActive: _selectedCategory == 'Business', onTap: () => _onCategorySelected('Business')),
                      _buildChip('Psychology', isActive: _selectedCategory == 'Psychology', onTap: () => _onCategorySelected('Psychology')),
                      _buildChip('Law', isActive: _selectedCategory == 'Law', onTap: () => _onCategorySelected('Law')),
                    ],
                  ),
                ),

                // 4. Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
                    children: [
                      // Featured Card
                      _buildFeaturedCard(context, l10n),
                      
                      const SizedBox(height: 24),
                      
                      // "Available Quests" Header
                      Row(
                        children: [
                           Icon(Icons.grid_view, color: AppColors.neonPurple, size: 20),
                           const SizedBox(width: 8),
                           Text(
                             'Available Quests (AI)',
                             style: Theme.of(context).textTheme.titleLarge?.copyWith(
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                             ),
                           ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),

                      // Future Builder for AI Quests
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _questsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                             return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                          }
                          
                          if (snapshot.hasError) {
                            return const Center(child: Text("System Offline. Check Connection.", style: TextStyle(color: Colors.red)));
                          }
                          
                          final quests = snapshot.data ?? [];
                          
                          return Column(
                            children: quests.map((q) {
                               return _buildQuestTile(
                                 context,
                                 title: q['title'] ?? 'Unknown',
                                 subtitle: q['subtitle'] ?? 'General',
                                 tag: q['tag'] ?? 'Task',
                                 tagColor: _getColorForTag(q['tag']),
                                 xp: q['xp'] ?? 100,
                                 icon: _getIconForName(q['icon']),
                                 description: q['description'] ?? 'No intel available.',
                                 questId: q['id'] ?? 'unknown',
                               ).animate().fadeIn().slideX();
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Blur Fade
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withOpacity(0),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Color _getColorForTag(String? tag) {
     if (tag == 'Beginner') return AppColors.neonGreen;
     if (tag == 'Expert') return AppColors.neonRed;
     if (tag == 'Intermediate') return Colors.amber;
     if (tag == 'Legendary') return const Color(0xFFFFD700); // Gold
     if (tag == 'Entrepreneur') return const Color(0xFF4169E1); // Royal Blue
     return AppColors.neonBlue;
  }
  
  IconData _getIconForName(String? name) {
    if (name == 'wallet') return Icons.account_balance_wallet;
    if (name == 'chart') return Icons.candlestick_chart;
    if (name == 'warning') return Icons.warning_amber;
    if (name == 'currency') return Icons.currency_bitcoin;
    if (name == 'brain') return Icons.psychology;
    if (name == 'house') return Icons.house;
    if (name == 'globe') return Icons.public;
    if (name == 'robot') return Icons.smart_toy;
    if (name == 'shield') return Icons.security;
    if (name == 'rocket') return Icons.rocket_launch;
    if (name == 'building') return Icons.apartment;
    if (name == 'briefcase') return Icons.work;
    return Icons.token;
  }

  Widget _buildChip(String label, {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? AppColors.primary.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 10,
            )
          ] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a2c35),
            AppColors.backgroundDark,
          ],
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.bookmark_border, size: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bitcoin: The Beginning',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Travel back to 2009. Mine the first block and learn the core of blockchain technology.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/lesson?topic=Bitcoin History&level=Beginner&questId=tutorial_bitcoin_1'),
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 12, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Start Mission',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.play_arrow, size: 16, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const Text(
                          'EST. 15 MIN',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Image Placeholder
              Container(
                width: 100,
                height: 100,
                 decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.currency_bitcoin, size: 50, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required int xp,
    required IconData icon,
    required String description,
    required String questId,
    bool isLocked = false,
  }) {
    return GestureDetector(
      onTap: isLocked ? null : () => context.push('/lesson?topic=${Uri.encodeComponent(title)}&level=${Uri.encodeComponent(tag)}&questId=$questId'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF162229),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            // Header
            Row(
              children: [
                // Icon Box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tagColor.withOpacity(0.2)),
                  ),
                  child: Icon(icon, color: tagColor, size: 24),
                ),
                const SizedBox(width: 12),
                
                // Titles (Expanded to fill available space)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),

                // Tag Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: tagColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    tag.toUpperCase(),
                    style: TextStyle(
                      color: tagColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Footer
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: AppColors.neonPurple, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        isLocked ? '??? XP' : '+$xp XP',
                        style: TextStyle(
                          color: isLocked ? AppColors.textSecondary : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isLocked ? Icons.lock : Icons.arrow_forward,
                    color: isLocked ? AppColors.textSecondary : AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
