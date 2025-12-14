// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiLessonResponse _$AiLessonResponseFromJson(Map<String, dynamic> json) =>
    _AiLessonResponse(
      responseType: json['response_type'] as String,
      praiseOrScold: json['praise_or_scold'] as String?,
      content:
          json['content'] == null
              ? null
              : LessonContent.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AiLessonResponseToJson(_AiLessonResponse instance) =>
    <String, dynamic>{
      'response_type': instance.responseType,
      'praise_or_scold': instance.praiseOrScold,
      'content': instance.content,
    };

_LessonContent _$LessonContentFromJson(Map<String, dynamic> json) =>
    _LessonContent(
      lessonId: json['lesson_id'] as String,
      title: json['title'] as String,
      screens:
          (json['screens'] as List<dynamic>)
              .map((e) => LessonScreen.fromJson(e as Map<String, dynamic>))
              .toList(),
      finalQuiz: FinalQuiz.fromJson(json['final_quiz'] as Map<String, dynamic>),
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$LessonContentToJson(_LessonContent instance) =>
    <String, dynamic>{
      'lesson_id': instance.lessonId,
      'title': instance.title,
      'screens': instance.screens,
      'final_quiz': instance.finalQuiz,
      'xp_reward': instance.xpReward,
    };

_LessonScreen _$LessonScreenFromJson(Map<String, dynamic> json) =>
    _LessonScreen(
      type: json['type'] as String,
      textContent: json['text_content'] as String?,
      analogyHighlight: json['analogy_highlight'] as String?,
      visualDescription: json['visual_description'] as String?,
      question: json['question'] as String?,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      correctIdx: (json['correct_idx'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LessonScreenToJson(_LessonScreen instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text_content': instance.textContent,
      'analogy_highlight': instance.analogyHighlight,
      'visual_description': instance.visualDescription,
      'question': instance.question,
      'options': instance.options,
      'correct_idx': instance.correctIdx,
    };

_FinalQuiz _$FinalQuizFromJson(Map<String, dynamic> json) => _FinalQuiz(
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIdx: (json['correct_idx'] as num).toInt(),
  retryOnFail: json['retry_on_fail'] as bool,
);

Map<String, dynamic> _$FinalQuizToJson(_FinalQuiz instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'correct_idx': instance.correctIdx,
      'retry_on_fail': instance.retryOnFail,
    };
