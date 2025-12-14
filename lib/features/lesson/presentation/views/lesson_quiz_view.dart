import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/lesson_models.dart';

class LessonQuizView extends StatefulWidget {
  final LessonScreen screen;
  final VoidCallback onNext;

  const LessonQuizView({super.key, required this.screen, required this.onNext});

  @override
  State<LessonQuizView> createState() => _LessonQuizViewState();
}

class _LessonQuizViewState extends State<LessonQuizView> {
  int? _selectedOptionIndex;
  bool _isSubmitted = false;
  late int _correctOptionIndex;

  @override
  void initState() {
    super.initState();
    _correctOptionIndex = widget.screen.correctIdx ?? 0;
  }

  void _submit(int index) {
    if (_isSubmitted) return;
    setState(() {
      _selectedOptionIndex = index;
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.screen.question ?? 'Question?';
    final options = widget.screen.options ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Section
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Decorative Line
                Container(
                  width: 4,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)), // Left rounded
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    question,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 12),
            
            // AI Context Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF16262e).withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF315668)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.smart_toy, size: 14, color: Color(0xFF90b7cb)),
                  const SizedBox(width: 6),
                  const Text(
                    'INTERACTIVE CHECK',
                    style: TextStyle(
                      color: Color(0xFF90b7cb),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Options
            ...List.generate(options.length, (index) {
              final isSelected = _selectedOptionIndex == index;
              final isCorrect = _correctOptionIndex == index;
              
              bool showAsCorrect = _isSubmitted && isCorrect;
              bool showAsWrong = _isSubmitted && isSelected && !isCorrect;
              bool showAsSelected = isSelected;

              // Color Logic
              Color borderColor = const Color(0xFF315668);
              Color backgroundColor = const Color(0xFF162229).withOpacity(0.4);
              
              if (showAsCorrect) {
                 borderColor = AppColors.primary;
                 backgroundColor = AppColors.primary.withOpacity(0.1);
              } else if (showAsWrong) {
                 borderColor = AppColors.error;
                 backgroundColor = AppColors.error.withOpacity(0.1);
              } else if (showAsSelected) {
                 borderColor = Colors.white.withOpacity(0.5);
                 backgroundColor = Colors.white.withOpacity(0.1);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () => _submit(index),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: borderColor,
                        width: (showAsCorrect || showAsWrong) ? 2 : 1,
                      ),
                      boxShadow: (showAsCorrect || showAsWrong) ? [
                         BoxShadow(
                           color: borderColor.withOpacity(0.3),
                           blurRadius: 15,
                         )
                      ] : [],
                    ),
                    child: Row(
                      children: [
                        // Radio Circle
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: showAsCorrect 
                                ? AppColors.primary 
                                : (showAsWrong ? AppColors.error : Colors.transparent),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: showAsCorrect 
                                  ? AppColors.primary 
                                  : (showAsWrong ? AppColors.error : const Color(0xFF547a8c)),
                              width: 2,
                            ),
                          ),
                          child: showAsCorrect 
                              ? const Center(child: Icon(Icons.check, size: 16, color: AppColors.backgroundDark))
                              : (showAsWrong 
                                  ? const Center(child: Icon(Icons.close, size: 16, color: Colors.white))
                                  : (showAsSelected ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            options[index],
                            style: TextStyle(
                              color: showAsCorrect || showAsSelected ? Colors.white : (showAsWrong ? AppColors.error.withOpacity(0.8) : const Color(0xFFCBD5E1)),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (showAsCorrect)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: const Text(
                              'CORRECT',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 32), // Replaced Spacer with specific spacing

            // Feedback Card (Shows ONLY after submission)
            if (_isSubmitted)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF16262e),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
                  ],
                ),
                child: Column(
                  children: [
                    // Glitch Top Border
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                           colors: [AppColors.primary, AppColors.neonGreen, AppColors.primary],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                ),
                                child: const Icon(Icons.lightbulb, color: AppColors.primary),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Analysis Complete',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Text(
                                      'Correct! Well done.', // Simplified feedback for V2
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: widget.onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.backgroundDark,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Next Challenge', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),

          ],
        ),
      ),
    );
  }
}
