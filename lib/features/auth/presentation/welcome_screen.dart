import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_quest/core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Gradient/Grid Effect
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Color(0xFF1A2C36),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ),
          
          // Custom Grid Painter (simulating the bg-cyber-grid)
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Header / Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.candlestick_chart, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'TradeQuest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

                const Spacer(),

                // Hero Visual
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: 340,
                    height: 340,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow Effect
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.3),
                                const Color(0xFFA855F7).withOpacity(0.3), // Purple neon accent
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 3.seconds),
                        
                        // Image
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBRkIVNoFFG5eLpsbE1qbaPx6aOf7birRWftarK0IMdMLhZ5o-Xw-E0TFLSCJrXKFX-xWDNGfxMy_zI6beDdcCbau9umfCyiGZy8Lb9I5j0kHChpYuaNpQcnEx84dcQ4Wco6vKnz8XrNHOZzQ1ry2d1OJDgXJIQ5dowbP9Px9T15b47qgLNauBH5df03ZbbKZq2HCcgqLEgyffZEgzOSPTxlmMUYHkSmj80-DOAikuRqv6XwP4zVg7BxTAiqAFDISCObE14Scftf8ji',
                          fit: BoxFit.contain,
                        ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Text Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: Colors.white,
                            fontFamily: 'SpaceGrotesk', // Assuming font is available or fallback
                          ),
                          children: [
                            const TextSpan(text: 'Trade. '),
                            TextSpan(
                              text: 'Play.',
                              style: TextStyle(
                                color: AppColors.primary,
                                shadows: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.6),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const TextSpan(text: ' Win.'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Dive into the neon-soaked world of decentralized finance. Learn by doing in a risk-free simulation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF94A3B8), // Slate 400
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Start Mission',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => context.go('/login'),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                      children: [
                        const TextSpan(text: 'Already an agent? '),
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 900.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    const double spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
