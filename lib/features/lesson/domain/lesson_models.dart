import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_models.g.dart';
part 'lesson_models.freezed.dart';

@freezed
abstract class AiLessonResponse with _$AiLessonResponse {
  const factory AiLessonResponse({
    @JsonKey(name: 'response_type') required String responseType,
    @JsonKey(name: 'praise_or_scold') String? praiseOrScold,
    LessonContent? content,
  }) = _AiLessonResponse;

  factory AiLessonResponse.fromJson(Map<String, dynamic> json) => _$AiLessonResponseFromJson(json);
}

@freezed
abstract class LessonContent with _$LessonContent {
  const factory LessonContent({
    @JsonKey(name: 'lesson_id') required String lessonId,
    required String title,
    required List<LessonScreen> screens,
    @JsonKey(name: 'final_quiz') required FinalQuiz finalQuiz,
    @JsonKey(name: 'xp_reward') @Default(100) int xpReward,
  }) = _LessonContent;

  factory LessonContent.fromJson(Map<String, dynamic> json) => _$LessonContentFromJson(json);
}

@freezed
abstract class LessonScreen with _$LessonScreen {
  const factory LessonScreen({
    required String type,
    @JsonKey(name: 'text_content') String? textContent,
    @JsonKey(name: 'analogy_highlight') String? analogyHighlight,
    @JsonKey(name: 'visual_description') String? visualDescription,
    String? question,
    List<String>? options,
    @JsonKey(name: 'correct_idx') int? correctIdx,
  }) = _LessonScreen;

  factory LessonScreen.fromJson(Map<String, dynamic> json) => _$LessonScreenFromJson(json);
}

@freezed
abstract class FinalQuiz with _$FinalQuiz {
  const factory FinalQuiz({
    required String question,
    required List<String> options,
    @JsonKey(name: 'correct_idx') required int correctIdx,
    @JsonKey(name: 'retry_on_fail') required bool retryOnFail,
  }) = _FinalQuiz;

  factory FinalQuiz.fromJson(Map<String, dynamic> json) => _$FinalQuizFromJson(json);
}
