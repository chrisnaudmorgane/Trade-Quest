import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_container.dart';

class MissionCard extends StatelessWidget {
  final String title;
  final String description;
  final int xp;
  final String difficulty; // Enum later
  final bool isLocked;
  final VoidCallback onTap;
  final int index;

  const MissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.xp,
    required this.difficulty,
    this.isLocked = false,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: isLocked ? null : onTap,
        child: GlassContainer(
          color: isLocked ? Colors.black.withOpacity(0.3) : AppColors.surfaceGlass,
          border: Border.all(
            color: isLocked ? Colors.grey.withOpacity(0.2) : AppColors.neonBlue.withOpacity(0.3),
            width: 1,
          ),
          child: Row(
            children: [
              // Icon / Status
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.withOpacity(0.1) : AppColors.neonBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocked ? Colors.grey : AppColors.neonBlue,
                  ),
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.play_arrow_rounded,
                  color: isLocked ? Colors.grey : AppColors.neonBlue,
                ),
              ),
              const SizedBox(width: 16),
              
              // Copy
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title, // "Bitcoin: The Beginning"
                          style: GoogleFonts.orbitron(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isLocked ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                        if (!isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.neonPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.neonPurple.withOpacity(0.5)),
                            ),
                            child: Text(
                              difficulty.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.neonPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!isLocked)
                      Row(
                        children: [
                          const Icon(Icons.bolt, size: 14, color: AppColors.neonGreen),
                          const SizedBox(width: 4),
                          Text(
                            "+$xp XP",
                            style: const TextStyle(
                              color: AppColors.neonGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (100 * index).ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
      ),
    );
  }
}
