import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardShell extends StatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/lesson');
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/rank');
        break;
      case 4:
        context.go('/social');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: widget.child,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF0A111F), // Darker shade for nav bar
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, 'Home'),
            _buildNavItem(1, Icons.school_rounded, 'Learn'),
            _buildCenterButton(),
            _buildNavItem(3, Icons.emoji_events_rounded, 'Rank'),
            _buildNavItem(4, Icons.group_rounded, 'Friends'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey, // Simple white for selected for now
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(2, context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.neonBlue,
          border: Border.all(
            color: const Color(0xFF101C22), // Match background color
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonBlue.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDw8nIWuL1XVwEE2uCvx7oS4K2WCnygGmUBU4_UWiHF_2oMTn0nh8BaQzE_E9znTsnIVK4MIEhpIrW4wVsHtdT0xZ5S_HeLNwKL7lhSDOzqePu_v0tA85bFNyl3uNMc9Z7fL2us1S2KTWhHruz4OC2dhMINAScWtVRc8RkM9bfceJHj0gOZqZMOUgpq3D7Gsp8sn8JbD9Ps2XIwgYuL0tY8RhH5SvBxJ_06vgJGt5sAiHzuhFtzuvKKPou6bP346EdZHqWZYrm_qz1A', // User avatar
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.black),
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
      .boxShadow(
        begin: BoxShadow(color: AppColors.neonBlue.withOpacity(0.3), blurRadius: 15, spreadRadius: 1),
        end: BoxShadow(color: AppColors.neonBlue.withOpacity(0.7), blurRadius: 25, spreadRadius: 5),
        duration: 2000.ms,
      ),
    );
  }
}
