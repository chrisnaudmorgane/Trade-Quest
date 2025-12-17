import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_quest/core/theme/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:url_launcher/url_launcher.dart';



class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
      final profile = await SupabaseService().getProfile(user.id);
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUsername() async {
    final user = SupabaseService().currentUser;
    if (user == null) return;

    final controller = TextEditingController(text: _profile?['username'] ?? '');
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16262E),
        title: const Text('Modifier Pseudo', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nouveau pseudo',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                await SupabaseService().updateProfile(
                  userId: user.id,
                  username: controller.text,
                );
                _loadProfile(); // Refresh
              }
            },
            child: const Text('Sauvegarder', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If loading, show loading or default, for now just default structure with loader potentially
    // but to keep UI stable we render valid structure
    
    final username = _profile?['username'] ?? 'Agent Fantôme';
    final email = SupabaseService().currentUser?.email ?? 'No Email';
    final avatarUrl = _profile?['avatar_url'] ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuDw8nIWuL1XVwEE2uCvx7oS4K2WCnygGmUBU4_UWiHF_2oMTn0nh8BaQzE_E9znTsnIVK4MIEhpIrW4wVsHtdT0xZ5S_HeLNwKL7lhSDOzqePu_v0tA85bFNyl3uNMc9Z7fL2us1S2KTWhHruz4OC2dhMINAScWtVRc8RkM9bfceJHj0gOZqZMOUgpq3D7Gsp8sn8JbD9Ps2XIwgYuL0tY8RhH5SvBxJ_06vgJGt5sAiHzuhFtzuvKKPou6bP346EdZHqWZYrm_qz1A';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    Color(0xFF1A2C36),
                    AppColors.backgroundDark,
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ),
          
          // Scanlines Effect
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.transparent,
                child: CustomPaint(
                  painter: ScanlinePainter(),
                ),
              ),
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
                        _buildProfileCard(username, email, avatarUrl),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Gestion du Compte'),
                        const SizedBox(height: 12),
                        _buildSettingsGroup([
                          _buildSettingsTile(
                            icon: Icons.badge,
                            title: 'Infos Personnelles',
                            subtitle: email,
                            onTap: () {},
                          ),
                        ]),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Préférences Notification'),
                        const SizedBox(height: 12),
                        _buildSettingsGroup([
                          _buildSwitchTile(
                            icon: Icons.school,
                            title: 'Rappel Leçons',
                            value: true,
                            onChanged: (v) {},
                            iconColor: AppColors.success,
                          ),
                          _buildSwitchTile(
                            icon: Icons.military_tech,
                            title: 'Alertes XP',
                            value: true,
                            onChanged: (v) {},
                            iconColor: AppColors.success,
                          ),
                        ]),
                        const SizedBox(height: 24),

                        _buildSectionHeader('Aide & Support'),
                        const SizedBox(height: 12),
                        _buildSettingsGroup([
                          _buildSettingsTile(
                            icon: Icons.help,
                            title: 'Centre d\'Aide',
                            iconColor: const Color(0xFFA0AEC0),
                            trailingIcon: Icons.open_in_new,
                            onTap: () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'agossou@chrisnaud.com',
                                queryParameters: {
                                  'subject': 'Trade Quest Support Request',
                                  'body': 'Describe your issue here...'
                                },
                              );
                              if (await canLaunchUrl(emailLaunchUri)) {
                                await launchUrl(emailLaunchUri);
                              }
                            },
                          ),
                          _buildSettingsTile(
                            icon: Icons.policy,
                            title: 'Confidentialité',
                            iconColor: const Color(0xFFA0AEC0),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF16262E),
                                  title: const Text('Politique de Confidentialité', style: TextStyle(color: Colors.white)),
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      "Nous respectons ta vie privée.\n\n"
                                      "1. Données : Email et Pseudo pour l'authentification et le classement.\n"
                                      "2. IA : Tes sujets 'Micro Ouvert' sont anonymisés avant d'être envoyés à l'IA.\n"
                                      "3. Contact : agossou@chrisnaud.com pour toute suppression.",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Fermer', style: TextStyle(color: AppColors.primary)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ]),
                        const SizedBox(height: 24),
                        _buildLogoutButton(context),
                        const SizedBox(height: 16),

                        const SizedBox(height: 32),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF315668).withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYSTÈME',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    'Paramètres',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          /* XP Widget - Optional, can keep or remove if not dynamic here */
        ],
      ),
    );
  }

  Widget _buildProfileCard(String username, String email, String avatarUrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16262E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      color: AppColors.backgroundDark,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _updateUsername,
                icon: const Icon(Icons.edit, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF547A8C),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16262E).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF315668).withOpacity(0.5)),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final isLast = index == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFF315668).withOpacity(0.3),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF315668).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null)
              Icon(
                trailingIcon ?? Icons.chevron_right,
                size: 20,
                color: const Color(0xFF64748B),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF315668).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: iconColor ?? AppColors.primary,
            activeTrackColor: (iconColor ?? AppColors.primary).withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () async { 
        await SupabaseService().signOut();
        context.go('/'); 
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Déconnexion',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.height; i += 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
