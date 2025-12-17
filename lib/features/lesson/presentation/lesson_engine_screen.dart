import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/lesson_models.dart';
import 'views/lesson_content_view.dart';
import 'views/lesson_quiz_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LessonEngineScreen extends StatefulWidget {
  final String topic;
  final String level;
  final String questId; // Required for completion tracking
  final int xpReward;

  const LessonEngineScreen({
    super.key, 
    required this.topic, 
    required this.level, 
    required this.questId,
    required this.xpReward,
  });

  @override
  State<LessonEngineScreen> createState() => _LessonEngineScreenState();
}

class _LessonEngineScreenState extends State<LessonEngineScreen> {
  AiLessonResponse? _aiResponse;
  LessonContent? _lessonContent;
  int _currentPage = 0;
  bool _isLoading = true;
  bool _isCompleted = false;
  String? _error;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadLessonData();
  }

  Future<void> _loadLessonData() async {
    try {
      final topic = widget.topic ?? 'Compound Interest'; // Default if null
      final level = widget.level ?? 'Beginner';
      
      final data = await GeminiService().generateLesson(topic, level);
      
      // Parse Response
      if (data.containsKey('error') || data['content'] == null) {
          throw Exception("AI Generation Failed");
      }
      
      final contentData = data['content'];
      final List<dynamic> screensJson = contentData['screens'] ?? [];
      
      final screens = screensJson.map<LessonScreen>((s) {
        return LessonScreen(
          type: s['type'] ?? 'theory_balanced',
          textContent: s['text_content'],
          analogyHighlight: s['analogy_highlight'],
          visualDescription: s['visual_description'],
          // For interactive_check, the fields are directly on the object in this model definition
          question: s['question'],
          options: s['options'] != null ? List<String>.from(s['options']) : null,
          correctIdx: s['correct_idx'],
        );
      }).toList();

      final aiResponse = AiLessonResponse(
         responseType: data['response_type'] ?? 'lesson',
         praiseOrScold: data['praise_or_scold'],
         content: LessonContent(
           lessonId: contentData['lesson_id'] ?? '1',
           title: contentData['title'] ?? topic,
           screens: screens,
           finalQuiz: contentData['final_quiz'] != null ? FinalQuiz(
             question: contentData['final_quiz']['question'],
             options: List<String>.from(contentData['final_quiz']['options']),
             correctIdx: contentData['final_quiz']['correct_idx'],
             retryOnFail: contentData['final_quiz']['retry_on_fail'] ?? true,
           ) : const FinalQuiz( // Fallback if missing
             question: "Ready to move on?",
             options: ["Yes", "No"],
             correctIdx: 0,
             retryOnFail: false,
           ),
         ),
      );

      if (mounted) {
        setState(() {
          _aiResponse = aiResponse;
          _lessonContent = aiResponse.content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
         setState(() {
           _error = e.toString();
           _isLoading = false;
         });
      }
    }
  }

  bool _showFinalQuiz = false;

  void _nextPage() {
    if (_lessonContent == null) return;
    
    if (_currentPage < _lessonContent!.screens.length - 1) {
       _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
       setState(() {
         _currentPage++;
       });
    } else {
       // Show Final Quiz
       setState(() {
         _showFinalQuiz = true;
       });
    }
  }

  Future<void> _completeLesson() async {
      setState(() => _isCompleted = true);
      
      /* Sound Removed by User Request
      final player = AudioPlayer();
      try {
        await player.play(AssetSource('sounds/success_quest.mp3'));
      } catch (e) {
        // print('Audio error: $e'); 
      }
      */

      final user = SupabaseService().currentUser;
      if (user != null) {
        final newBadges = await SupabaseService().completeQuest(
          user.id, 
          widget.questId, 
          widget.xpReward,
        );
        
        if (newBadges.isNotEmpty) {
           // Queue badge animations
           for (final badge in newBadges) {
             if (mounted) _showBadgeDialog(badge);
             await Future.delayed(const Duration(milliseconds: 2000)); // Wait before showing next or finishing
           }
        }
      }
  }

  void _showBadgeDialog(Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.neonRoot, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonRoot.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("NOUVEAU BADGE DÉBLOQUÉ !", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 24),
              Icon(Icons.military_tech, size: 80, color: Color(int.parse(badge['color_hex'] ?? '0xFFFFC107'))).animate().scale(duration: 600.ms, curve: Curves.elasticOut).then().shimmer(),
              const SizedBox(height: 16),
              Text(
                badge['name'] ?? 'Badge Inconnu',
                style: const TextStyle(color: AppColors.neonRoot, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                badge['description'] ?? 'Tu deviens une légende.',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
               ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonRoot),
                child: const Text("RÉCUPÉRER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
      ),
    );
    
    /* Sound Removed by User Request
    final player = AudioPlayer();
    try {
       player.play(AssetSource('sounds/badge_unlock.mp3'));
    } catch (_) {}
    */
  }

  void _previousPage() {
    if (_lessonContent == null) return;

    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentPage--;
      });
    }
  }

  void _handleTap(TapUpDetails details, BoxConstraints constraints) {
    final double tapPosition = details.localPosition.dx;
    final double screenWidth = constraints.maxWidth;
    final double tapRatio = tapPosition / screenWidth;

    if (tapRatio < 0.35) { // Left 35% -> Previous
      _previousPage();
    } else { // Right 65% -> Next
      _nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircularProgressIndicator(color: AppColors.primary),
               SizedBox(height: 16),
               Text("Connexion au Cerveau IA...", style: TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      );
    }

    if (_error != null || _aiResponse == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  _error ?? "Signal Perdu", 
                  style: const TextStyle(color: Colors.white, fontSize: 16), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text("Retour à la Base"),
                )
              ],
            ),
          ),
        ),
      );
    }

    // Handle Refusal / Teaser
    if (_aiResponse!.responseType != 'lesson') {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                _aiResponse!.responseType == 'refusal' ? 'Accès Refusé' : 'Aperçu Verrouillé',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _aiResponse!.praiseOrScold ?? 'Access restriction applied.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Retour au Dashboard'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_isCompleted) {
       return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.success, size: 80),
              const SizedBox(height: 24),
              const Text(
                'MISSION ACCOMPLIE',
                style: TextStyle(color: AppColors.success, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              Text(
                '+${widget.xpReward} XP',
                style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
               ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text('RETOUR BASE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (_lessonContent == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_showFinalQuiz && _lessonContent != null) {
      // Map FinalQuiz to LessonScreen for reuse
      final finalQuizScreen = LessonScreen(
        type: 'interactive_check',
        question: _lessonContent!.finalQuiz.question,
        options: _lessonContent!.finalQuiz.options,
        correctIdx: _lessonContent!.finalQuiz.correctIdx, 
        // Note: retry strategy handles externally in view usually, but simpler reuse here
      );
      
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
               Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                       IconButton(onPressed: () => context.go('/home'), icon: const Icon(Icons.close, color: Colors.white)),
                       const Spacer(),
                       const Text("BOSS FINAL", style: TextStyle(color: AppColors.neonPurple, fontWeight: FontWeight.bold, letterSpacing: 2)),
                       const Spacer(),
                       const SizedBox(width: 48),
                    ],
                  ),
               ),
               Expanded(
                 child: LessonQuizView(
                   screen: finalQuizScreen, 
                   onResult: (isCorrect, feedback) => _handleQuizResult(isCorrect, feedback, isFinal: true),
                 ),
               ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Effects
          Positioned(
            top: -100,
            right: -100,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header (HUD)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [
                      // Progress Segments
                      Row(
                        children: List.generate(_lessonContent!.screens.length, (index) {
                          bool isActive = index <= _currentPage;
                          bool isCurrent = index == _currentPage;
                          
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 4),
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.primary : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: isCurrent ? FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 1.0,
                                child: Container(color: Colors.white.withOpacity(0.5)),
                              ) : null,
                            ),
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Top Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Expanded(
                             child: Row(
                               children: [
                                 // AI Avatar
                                 Container(
                                   width: 32,
                                   height: 32,
                                   decoration: BoxDecoration(
                                     color: AppColors.primary.withOpacity(0.1),
                                     borderRadius: BorderRadius.circular(30),
                                     border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                   ),
                                   child: const Icon(Icons.smart_toy, size: 18, color: AppColors.primary),
                                 ),
                                 const SizedBox(width: 8),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                         'MODULE',
                                         style: const TextStyle(
                                           color: AppColors.primary,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 10,
                                           letterSpacing: 1.0,
                                         ),
                                       ),
                                       Text(
                                         _lessonContent!.title,
                                         style: TextStyle(
                                           color: Colors.white.withOpacity(0.8),
                                           fontSize: 12,
                                           fontWeight: FontWeight.w500,
                                         ),
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           IconButton(
                             onPressed: () => context.go('/home'),
                             icon: const Icon(Icons.close, color: Colors.white70),
                           ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _lessonContent!.screens.length,
                    itemBuilder: (context, index) {
                      final screen = _lessonContent!.screens[index];
                      if (screen.type == 'theory_balanced') {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              onTapUp: (details) => _handleTap(details, constraints),
                              behavior: HitTestBehavior.translucent,
                              child: LessonContentView(screen: screen),
                            );
                          },
                        );
                      } else if (screen.type == 'interactive_check') {
                        return LessonQuizView(
                          screen: screen, 
                          onResult: (isCorrect, feedback) => _handleQuizResult(isCorrect, feedback, isFinal: false),
                        );
                      }
                      return const Center(child: Text("Unknown Screen Type"));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuizResult(bool isCorrect, String? feedback, {bool isFinal = false}) async {
     if (isCorrect) {
       if (isFinal) {
         await _completeLesson();
       } else {
         _nextPage();
       }
     } else {
       // TRIGGER REMEDIAL LOOP
       setState(() {
         _isLoading = true;
         // _showFinalQuiz = false; // logic handled by state reset below
       });
       
       try {
          final data = await GeminiService().generateRemedialLesson(
             widget.topic, 
             widget.level,
             userFeedback: feedback
          );
          
          if (data.containsKey('error') || data['content'] == null) {
             throw Exception("Remedial Generation Failed");
          }

          final contentData = data['content'];
          final List<dynamic> screensJson = contentData['screens'] ?? [];
          
          final screens = screensJson.map<LessonScreen>((s) {
            return LessonScreen(
              type: s['type'] ?? 'theory_balanced',
              textContent: s['text_content'],
              analogyHighlight: s['analogy_highlight'],
              visualDescription: s['visual_description'],
              question: s['question'],
              options: s['options'] != null ? List<String>.from(s['options']) : null,
              correctIdx: s['correct_idx'],
            );
          }).toList();

          final newContent = LessonContent(
             lessonId: contentData['lesson_id'] ?? 'remedial',
             title: "${_lessonContent?.title ?? widget.topic} (Review)",
             screens: screens,
             finalQuiz: FinalQuiz(
               question: contentData['final_quiz']['question'],
               options: List<String>.from(contentData['final_quiz']['options']),
               correctIdx: contentData['final_quiz']['correct_idx'],
               retryOnFail: false,
             ),
          );

          if (mounted) {
             setState(() {
               _lessonContent = newContent;
               _currentPage = 0;
               _showFinalQuiz = false; // Reset finding queen logic
               _isLoading = false;
               // Prompt user
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                   content: Text("IA: Simplifions ça. Revue activée."),
                   backgroundColor: AppColors.neonPurple,
                 )
               );
             });
             _pageController.jumpToPage(0);
          }

       } catch (e) {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur de Calibrage: $e")));
             setState(() => _isLoading = false);
          }
       }
     }
  }
}
