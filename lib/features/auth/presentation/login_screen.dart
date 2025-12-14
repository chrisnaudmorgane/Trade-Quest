import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_quest/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Will need for Google logo, or basic shapes
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Grid Background (Custom Painter or Image)
          // Using a layout builder to draw the grid or a simple container with gradient lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.3, 
              child: _GridPattern(),
            ),
          ),
          
          // 2. Ambient Glow Orbs (Blurry circles)
          // Top-Left Orb
          Positioned(
            top: -200,
            left: -200,
            width: 600,
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ).animate().fadeIn().blurXY(begin: 20, end: 0),
          ),
          // Bottom-Right Orb
          Positioned(
            bottom: -100,
            right: -100,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.withOpacity(0.1),
              ),
            ).animate().fadeIn().blurXY(begin: 15, end: 0),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Floating Logo
                      _buildLogo(),
                      
                      const SizedBox(height: 64),

                      // Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: l10n.appTitlePart1.toUpperCase(),
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            TextSpan(
                                text: l10n.appTitlePart2.toUpperCase(),
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.primary,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.primary.withOpacity(0.6),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0, delay: 200.ms),

                      const SizedBox(height: 16),
                      
                      // Subtitle
                      Text(
                        l10n.heroSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 64),

                      // Google Login Button
                      _buildGoogleButton(context, l10n),
                      
                      const SizedBox(height: 24),
                      
                      // Footer Text (Terms & Privacy)
                      _buildFooter(context, l10n),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFF0a1216), // Dark background for logo card
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardDark,
            const Color(0xFF0a1216),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeon,
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Icon(
        Icons.token, // Material Symbol 'token' equivalent
        color: AppColors.primary,
        size: 48,
        shadows: [
          Shadow(
            color: AppColors.primary,
            blurRadius: 8,
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scaleXY(begin: 1.0, end: 1.05, duration: 2000.ms, curve: Curves.easeInOut)
     .rotate(begin: 0, end: 0.03, duration: 3000.ms); // Subtle rotation
  }

  Widget _buildGoogleButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
             setState(() => _isLoading = true);
             try {
               final success = await SupabaseService().signInWithGoogle();
               if (mounted && success) {
                 // Navigation handled by auth listener usually, but for now:
                 if (SupabaseService().currentUser != null) {
                    context.go('/home');
                 } else {
                    // If no user, maybe waiting for deep link?
                    // On mobile, the app resumes.
                 }
               } else if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Login failed or cancelled')),
                   );
               }
             } catch (e) {
                if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Error: $e')),
                   );
                }
             } finally {
                if (mounted) setState(() => _isLoading = false);
             }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0F172A), // Slate 900
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading 
          ? const SizedBox(
              width: 24, 
              height: 24, 
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundDark)
            ) 
          : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Creating Google Logo manually with SVG logic or simple Widgets
             // For this output, I'll use a placeholder or basic shapes if Assets aren't setup
            _GoogleLogo(),
            const SizedBox(width: 12),
            Text(
              l10n.loginWithGoogle,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0)
    .shimmer(delay: 1000.ms, duration: 1500.ms, color: Colors.white.withOpacity(0.5));
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
         Text(
          l10n.secureAuth,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.7),
            fontFamily: 'Roboto Mono', // Using default mono or closest
            fontSize: 10,
          ),
         ),
         const SizedBox(height: 32), // push to bottom
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: RichText(
             textAlign: TextAlign.center,
             text: TextSpan(
               style: Theme.of(context).textTheme.labelSmall,
               children: [
                 TextSpan(text: l10n.footerByContinuing),
                 TextSpan(
                   text: l10n.footerTerms,
                   style: TextStyle(
                     color: AppColors.primary.withOpacity(0.7),
                     decoration: TextDecoration.underline,
                   ),
                   recognizer: TapGestureRecognizer()..onTap = () {},
                 ),
                 TextSpan(text: l10n.footerAnd),
                 TextSpan(
                   text: l10n.footerPrivacy,
                   style: TextStyle(
                     color: AppColors.primary.withOpacity(0.7),
                     decoration: TextDecoration.underline,
                   ),
                   recognizer: TapGestureRecognizer()..onTap = () {},
                 ),
                 const TextSpan(text: '.'),
               ],
             ),
           ),
         ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Basic Google Logo representation using flutter_svg or custom paint is best
    // Here using a simple approximation with Containers/Icons if no asset
    // Or better: The HTML SVG path suggests we should use an asset. I will assume we don't have it and use an Icon or text G
    // Actually, I can draw the G colors manually
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          // This is a simplified placeholder. In production, use `flutter_svg` with the actual Google SVG.
           Container(
             decoration: const BoxDecoration(
               color: Colors.transparent, // Placeholder
               shape: BoxShape.circle,
             ),
             child: const Center(
               child: Text('G', style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 20,
                 color: Colors.blue, // Simplified
               )),
             ),
           )
        ],
      ),
    );
  }
}

class _GridPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: Container(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
