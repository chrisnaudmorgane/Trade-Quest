import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/lesson_models.dart';

class LessonContentView extends StatelessWidget {
  final LessonScreen screen;

  const LessonContentView({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Type Indicator Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flash_on, size: 12, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'CORE CONCEPT',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.5, end: 0),

          const SizedBox(height: 24),

          // Analogy Highlight (The "One sentence analogy")
          if (screen.analogyHighlight != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.neonPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.neonPurple.withOpacity(0.3)),
            ),
            child: Text(
              screen.analogyHighlight!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.neonPurple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 32),

          // Visual Description Placeholder (Replacing Lottie/Image for now)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF182b34),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                image: screen.visualDescription != null ? DecorationImage(
                  image: NetworkImage(
                    'https://image.pollinations.ai/prompt/${Uri.encodeComponent(screen.visualDescription!)}',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                ) : null,
              ),
              child: screen.visualDescription == null ? const Center(
                child: Icon(Icons.image_not_supported, size: 48, color: Colors.white24),
              ) : null,
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
          ),

          const SizedBox(height: 24),

          // Main Theory Text
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Text(
                screen.textContent ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
