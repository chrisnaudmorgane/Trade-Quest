// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiLessonResponse {

@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'praise_or_scold') String? get praiseOrScold; LessonContent? get content;
/// Create a copy of AiLessonResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiLessonResponseCopyWith<AiLessonResponse> get copyWith => _$AiLessonResponseCopyWithImpl<AiLessonResponse>(this as AiLessonResponse, _$identity);

  /// Serializes this AiLessonResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiLessonResponse&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.praiseOrScold, praiseOrScold) || other.praiseOrScold == praiseOrScold)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,responseType,praiseOrScold,content);

@override
String toString() {
  return 'AiLessonResponse(responseType: $responseType, praiseOrScold: $praiseOrScold, content: $content)';
}


}

/// @nodoc
abstract mixin class $AiLessonResponseCopyWith<$Res>  {
  factory $AiLessonResponseCopyWith(AiLessonResponse value, $Res Function(AiLessonResponse) _then) = _$AiLessonResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'praise_or_scold') String? praiseOrScold, LessonContent? content
});


$LessonContentCopyWith<$Res>? get content;

}
/// @nodoc
class _$AiLessonResponseCopyWithImpl<$Res>
    implements $AiLessonResponseCopyWith<$Res> {
  _$AiLessonResponseCopyWithImpl(this._self, this._then);

  final AiLessonResponse _self;
  final $Res Function(AiLessonResponse) _then;

/// Create a copy of AiLessonResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? responseType = null,Object? praiseOrScold = freezed,Object? content = freezed,}) {
  return _then(_self.copyWith(
responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,praiseOrScold: freezed == praiseOrScold ? _self.praiseOrScold : praiseOrScold // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as LessonContent?,
  ));
}
/// Create a copy of AiLessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $LessonContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiLessonResponse].
extension AiLessonResponsePatterns on AiLessonResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiLessonResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiLessonResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiLessonResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiLessonResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiLessonResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiLessonResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'praise_or_scold')  String? praiseOrScold,  LessonContent? content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiLessonResponse() when $default != null:
return $default(_that.responseType,_that.praiseOrScold,_that.content);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'praise_or_scold')  String? praiseOrScold,  LessonContent? content)  $default,) {final _that = this;
switch (_that) {
case _AiLessonResponse():
return $default(_that.responseType,_that.praiseOrScold,_that.content);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'praise_or_scold')  String? praiseOrScold,  LessonContent? content)?  $default,) {final _that = this;
switch (_that) {
case _AiLessonResponse() when $default != null:
return $default(_that.responseType,_that.praiseOrScold,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiLessonResponse implements AiLessonResponse {
  const _AiLessonResponse({@JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'praise_or_scold') this.praiseOrScold, this.content});
  factory _AiLessonResponse.fromJson(Map<String, dynamic> json) => _$AiLessonResponseFromJson(json);

@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'praise_or_scold') final  String? praiseOrScold;
@override final  LessonContent? content;

/// Create a copy of AiLessonResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiLessonResponseCopyWith<_AiLessonResponse> get copyWith => __$AiLessonResponseCopyWithImpl<_AiLessonResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiLessonResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiLessonResponse&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.praiseOrScold, praiseOrScold) || other.praiseOrScold == praiseOrScold)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,responseType,praiseOrScold,content);

@override
String toString() {
  return 'AiLessonResponse(responseType: $responseType, praiseOrScold: $praiseOrScold, content: $content)';
}


}

/// @nodoc
abstract mixin class _$AiLessonResponseCopyWith<$Res> implements $AiLessonResponseCopyWith<$Res> {
  factory _$AiLessonResponseCopyWith(_AiLessonResponse value, $Res Function(_AiLessonResponse) _then) = __$AiLessonResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'praise_or_scold') String? praiseOrScold, LessonContent? content
});


@override $LessonContentCopyWith<$Res>? get content;

}
/// @nodoc
class __$AiLessonResponseCopyWithImpl<$Res>
    implements _$AiLessonResponseCopyWith<$Res> {
  __$AiLessonResponseCopyWithImpl(this._self, this._then);

  final _AiLessonResponse _self;
  final $Res Function(_AiLessonResponse) _then;

/// Create a copy of AiLessonResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? responseType = null,Object? praiseOrScold = freezed,Object? content = freezed,}) {
  return _then(_AiLessonResponse(
responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,praiseOrScold: freezed == praiseOrScold ? _self.praiseOrScold : praiseOrScold // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as LessonContent?,
  ));
}

/// Create a copy of AiLessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $LessonContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$LessonContent {

@JsonKey(name: 'lesson_id') String get lessonId; String get title; List<LessonScreen> get screens;@JsonKey(name: 'final_quiz') FinalQuiz get finalQuiz;@JsonKey(name: 'xp_reward') int get xpReward;
/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonContentCopyWith<LessonContent> get copyWith => _$LessonContentCopyWithImpl<LessonContent>(this as LessonContent, _$identity);

  /// Serializes this LessonContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonContent&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.screens, screens)&&(identical(other.finalQuiz, finalQuiz) || other.finalQuiz == finalQuiz)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,title,const DeepCollectionEquality().hash(screens),finalQuiz,xpReward);

@override
String toString() {
  return 'LessonContent(lessonId: $lessonId, title: $title, screens: $screens, finalQuiz: $finalQuiz, xpReward: $xpReward)';
}


}

/// @nodoc
abstract mixin class $LessonContentCopyWith<$Res>  {
  factory $LessonContentCopyWith(LessonContent value, $Res Function(LessonContent) _then) = _$LessonContentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId, String title, List<LessonScreen> screens,@JsonKey(name: 'final_quiz') FinalQuiz finalQuiz,@JsonKey(name: 'xp_reward') int xpReward
});


$FinalQuizCopyWith<$Res> get finalQuiz;

}
/// @nodoc
class _$LessonContentCopyWithImpl<$Res>
    implements $LessonContentCopyWith<$Res> {
  _$LessonContentCopyWithImpl(this._self, this._then);

  final LessonContent _self;
  final $Res Function(LessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? title = null,Object? screens = null,Object? finalQuiz = null,Object? xpReward = null,}) {
  return _then(_self.copyWith(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<LessonScreen>,finalQuiz: null == finalQuiz ? _self.finalQuiz : finalQuiz // ignore: cast_nullable_to_non_nullable
as FinalQuiz,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinalQuizCopyWith<$Res> get finalQuiz {
  
  return $FinalQuizCopyWith<$Res>(_self.finalQuiz, (value) {
    return _then(_self.copyWith(finalQuiz: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonContent].
extension LessonContentPatterns on LessonContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonContent value)  $default,){
final _that = this;
switch (_that) {
case _LessonContent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonContent value)?  $default,){
final _that = this;
switch (_that) {
case _LessonContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId,  String title,  List<LessonScreen> screens, @JsonKey(name: 'final_quiz')  FinalQuiz finalQuiz, @JsonKey(name: 'xp_reward')  int xpReward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonContent() when $default != null:
return $default(_that.lessonId,_that.title,_that.screens,_that.finalQuiz,_that.xpReward);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId,  String title,  List<LessonScreen> screens, @JsonKey(name: 'final_quiz')  FinalQuiz finalQuiz, @JsonKey(name: 'xp_reward')  int xpReward)  $default,) {final _that = this;
switch (_that) {
case _LessonContent():
return $default(_that.lessonId,_that.title,_that.screens,_that.finalQuiz,_that.xpReward);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'lesson_id')  String lessonId,  String title,  List<LessonScreen> screens, @JsonKey(name: 'final_quiz')  FinalQuiz finalQuiz, @JsonKey(name: 'xp_reward')  int xpReward)?  $default,) {final _that = this;
switch (_that) {
case _LessonContent() when $default != null:
return $default(_that.lessonId,_that.title,_that.screens,_that.finalQuiz,_that.xpReward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonContent implements LessonContent {
  const _LessonContent({@JsonKey(name: 'lesson_id') required this.lessonId, required this.title, required final  List<LessonScreen> screens, @JsonKey(name: 'final_quiz') required this.finalQuiz, @JsonKey(name: 'xp_reward') this.xpReward = 100}): _screens = screens;
  factory _LessonContent.fromJson(Map<String, dynamic> json) => _$LessonContentFromJson(json);

@override@JsonKey(name: 'lesson_id') final  String lessonId;
@override final  String title;
 final  List<LessonScreen> _screens;
@override List<LessonScreen> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}

@override@JsonKey(name: 'final_quiz') final  FinalQuiz finalQuiz;
@override@JsonKey(name: 'xp_reward') final  int xpReward;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonContentCopyWith<_LessonContent> get copyWith => __$LessonContentCopyWithImpl<_LessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonContent&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._screens, _screens)&&(identical(other.finalQuiz, finalQuiz) || other.finalQuiz == finalQuiz)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,title,const DeepCollectionEquality().hash(_screens),finalQuiz,xpReward);

@override
String toString() {
  return 'LessonContent(lessonId: $lessonId, title: $title, screens: $screens, finalQuiz: $finalQuiz, xpReward: $xpReward)';
}


}

/// @nodoc
abstract mixin class _$LessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory _$LessonContentCopyWith(_LessonContent value, $Res Function(_LessonContent) _then) = __$LessonContentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId, String title, List<LessonScreen> screens,@JsonKey(name: 'final_quiz') FinalQuiz finalQuiz,@JsonKey(name: 'xp_reward') int xpReward
});


@override $FinalQuizCopyWith<$Res> get finalQuiz;

}
/// @nodoc
class __$LessonContentCopyWithImpl<$Res>
    implements _$LessonContentCopyWith<$Res> {
  __$LessonContentCopyWithImpl(this._self, this._then);

  final _LessonContent _self;
  final $Res Function(_LessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? title = null,Object? screens = null,Object? finalQuiz = null,Object? xpReward = null,}) {
  return _then(_LessonContent(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<LessonScreen>,finalQuiz: null == finalQuiz ? _self.finalQuiz : finalQuiz // ignore: cast_nullable_to_non_nullable
as FinalQuiz,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinalQuizCopyWith<$Res> get finalQuiz {
  
  return $FinalQuizCopyWith<$Res>(_self.finalQuiz, (value) {
    return _then(_self.copyWith(finalQuiz: value));
  });
}
}


/// @nodoc
mixin _$LessonScreen {

 String get type;@JsonKey(name: 'text_content') String? get textContent;@JsonKey(name: 'analogy_highlight') String? get analogyHighlight;@JsonKey(name: 'visual_description') String? get visualDescription; String? get question; List<String>? get options;@JsonKey(name: 'correct_idx') int? get correctIdx;
/// Create a copy of LessonScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonScreenCopyWith<LessonScreen> get copyWith => _$LessonScreenCopyWithImpl<LessonScreen>(this as LessonScreen, _$identity);

  /// Serializes this LessonScreen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonScreen&&(identical(other.type, type) || other.type == type)&&(identical(other.textContent, textContent) || other.textContent == textContent)&&(identical(other.analogyHighlight, analogyHighlight) || other.analogyHighlight == analogyHighlight)&&(identical(other.visualDescription, visualDescription) || other.visualDescription == visualDescription)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIdx, correctIdx) || other.correctIdx == correctIdx));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,textContent,analogyHighlight,visualDescription,question,const DeepCollectionEquality().hash(options),correctIdx);

@override
String toString() {
  return 'LessonScreen(type: $type, textContent: $textContent, analogyHighlight: $analogyHighlight, visualDescription: $visualDescription, question: $question, options: $options, correctIdx: $correctIdx)';
}


}

/// @nodoc
abstract mixin class $LessonScreenCopyWith<$Res>  {
  factory $LessonScreenCopyWith(LessonScreen value, $Res Function(LessonScreen) _then) = _$LessonScreenCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'text_content') String? textContent,@JsonKey(name: 'analogy_highlight') String? analogyHighlight,@JsonKey(name: 'visual_description') String? visualDescription, String? question, List<String>? options,@JsonKey(name: 'correct_idx') int? correctIdx
});




}
/// @nodoc
class _$LessonScreenCopyWithImpl<$Res>
    implements $LessonScreenCopyWith<$Res> {
  _$LessonScreenCopyWithImpl(this._self, this._then);

  final LessonScreen _self;
  final $Res Function(LessonScreen) _then;

/// Create a copy of LessonScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? textContent = freezed,Object? analogyHighlight = freezed,Object? visualDescription = freezed,Object? question = freezed,Object? options = freezed,Object? correctIdx = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,textContent: freezed == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String?,analogyHighlight: freezed == analogyHighlight ? _self.analogyHighlight : analogyHighlight // ignore: cast_nullable_to_non_nullable
as String?,visualDescription: freezed == visualDescription ? _self.visualDescription : visualDescription // ignore: cast_nullable_to_non_nullable
as String?,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correctIdx: freezed == correctIdx ? _self.correctIdx : correctIdx // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonScreen].
extension LessonScreenPatterns on LessonScreen {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonScreen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonScreen() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonScreen value)  $default,){
final _that = this;
switch (_that) {
case _LessonScreen():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonScreen value)?  $default,){
final _that = this;
switch (_that) {
case _LessonScreen() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'text_content')  String? textContent, @JsonKey(name: 'analogy_highlight')  String? analogyHighlight, @JsonKey(name: 'visual_description')  String? visualDescription,  String? question,  List<String>? options, @JsonKey(name: 'correct_idx')  int? correctIdx)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonScreen() when $default != null:
return $default(_that.type,_that.textContent,_that.analogyHighlight,_that.visualDescription,_that.question,_that.options,_that.correctIdx);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'text_content')  String? textContent, @JsonKey(name: 'analogy_highlight')  String? analogyHighlight, @JsonKey(name: 'visual_description')  String? visualDescription,  String? question,  List<String>? options, @JsonKey(name: 'correct_idx')  int? correctIdx)  $default,) {final _that = this;
switch (_that) {
case _LessonScreen():
return $default(_that.type,_that.textContent,_that.analogyHighlight,_that.visualDescription,_that.question,_that.options,_that.correctIdx);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(name: 'text_content')  String? textContent, @JsonKey(name: 'analogy_highlight')  String? analogyHighlight, @JsonKey(name: 'visual_description')  String? visualDescription,  String? question,  List<String>? options, @JsonKey(name: 'correct_idx')  int? correctIdx)?  $default,) {final _that = this;
switch (_that) {
case _LessonScreen() when $default != null:
return $default(_that.type,_that.textContent,_that.analogyHighlight,_that.visualDescription,_that.question,_that.options,_that.correctIdx);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonScreen implements LessonScreen {
  const _LessonScreen({required this.type, @JsonKey(name: 'text_content') this.textContent, @JsonKey(name: 'analogy_highlight') this.analogyHighlight, @JsonKey(name: 'visual_description') this.visualDescription, this.question, final  List<String>? options, @JsonKey(name: 'correct_idx') this.correctIdx}): _options = options;
  factory _LessonScreen.fromJson(Map<String, dynamic> json) => _$LessonScreenFromJson(json);

@override final  String type;
@override@JsonKey(name: 'text_content') final  String? textContent;
@override@JsonKey(name: 'analogy_highlight') final  String? analogyHighlight;
@override@JsonKey(name: 'visual_description') final  String? visualDescription;
@override final  String? question;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'correct_idx') final  int? correctIdx;

/// Create a copy of LessonScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonScreenCopyWith<_LessonScreen> get copyWith => __$LessonScreenCopyWithImpl<_LessonScreen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonScreenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonScreen&&(identical(other.type, type) || other.type == type)&&(identical(other.textContent, textContent) || other.textContent == textContent)&&(identical(other.analogyHighlight, analogyHighlight) || other.analogyHighlight == analogyHighlight)&&(identical(other.visualDescription, visualDescription) || other.visualDescription == visualDescription)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIdx, correctIdx) || other.correctIdx == correctIdx));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,textContent,analogyHighlight,visualDescription,question,const DeepCollectionEquality().hash(_options),correctIdx);

@override
String toString() {
  return 'LessonScreen(type: $type, textContent: $textContent, analogyHighlight: $analogyHighlight, visualDescription: $visualDescription, question: $question, options: $options, correctIdx: $correctIdx)';
}


}

/// @nodoc
abstract mixin class _$LessonScreenCopyWith<$Res> implements $LessonScreenCopyWith<$Res> {
  factory _$LessonScreenCopyWith(_LessonScreen value, $Res Function(_LessonScreen) _then) = __$LessonScreenCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'text_content') String? textContent,@JsonKey(name: 'analogy_highlight') String? analogyHighlight,@JsonKey(name: 'visual_description') String? visualDescription, String? question, List<String>? options,@JsonKey(name: 'correct_idx') int? correctIdx
});




}
/// @nodoc
class __$LessonScreenCopyWithImpl<$Res>
    implements _$LessonScreenCopyWith<$Res> {
  __$LessonScreenCopyWithImpl(this._self, this._then);

  final _LessonScreen _self;
  final $Res Function(_LessonScreen) _then;

/// Create a copy of LessonScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? textContent = freezed,Object? analogyHighlight = freezed,Object? visualDescription = freezed,Object? question = freezed,Object? options = freezed,Object? correctIdx = freezed,}) {
  return _then(_LessonScreen(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,textContent: freezed == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String?,analogyHighlight: freezed == analogyHighlight ? _self.analogyHighlight : analogyHighlight // ignore: cast_nullable_to_non_nullable
as String?,visualDescription: freezed == visualDescription ? _self.visualDescription : visualDescription // ignore: cast_nullable_to_non_nullable
as String?,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correctIdx: freezed == correctIdx ? _self.correctIdx : correctIdx // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FinalQuiz {

 String get question; List<String> get options;@JsonKey(name: 'correct_idx') int get correctIdx;@JsonKey(name: 'retry_on_fail') bool get retryOnFail;
/// Create a copy of FinalQuiz
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinalQuizCopyWith<FinalQuiz> get copyWith => _$FinalQuizCopyWithImpl<FinalQuiz>(this as FinalQuiz, _$identity);

  /// Serializes this FinalQuiz to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinalQuiz&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIdx, correctIdx) || other.correctIdx == correctIdx)&&(identical(other.retryOnFail, retryOnFail) || other.retryOnFail == retryOnFail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,const DeepCollectionEquality().hash(options),correctIdx,retryOnFail);

@override
String toString() {
  return 'FinalQuiz(question: $question, options: $options, correctIdx: $correctIdx, retryOnFail: $retryOnFail)';
}


}

/// @nodoc
abstract mixin class $FinalQuizCopyWith<$Res>  {
  factory $FinalQuizCopyWith(FinalQuiz value, $Res Function(FinalQuiz) _then) = _$FinalQuizCopyWithImpl;
@useResult
$Res call({
 String question, List<String> options,@JsonKey(name: 'correct_idx') int correctIdx,@JsonKey(name: 'retry_on_fail') bool retryOnFail
});




}
/// @nodoc
class _$FinalQuizCopyWithImpl<$Res>
    implements $FinalQuizCopyWith<$Res> {
  _$FinalQuizCopyWithImpl(this._self, this._then);

  final FinalQuiz _self;
  final $Res Function(FinalQuiz) _then;

/// Create a copy of FinalQuiz
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? options = null,Object? correctIdx = null,Object? retryOnFail = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIdx: null == correctIdx ? _self.correctIdx : correctIdx // ignore: cast_nullable_to_non_nullable
as int,retryOnFail: null == retryOnFail ? _self.retryOnFail : retryOnFail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FinalQuiz].
extension FinalQuizPatterns on FinalQuiz {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinalQuiz value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinalQuiz() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinalQuiz value)  $default,){
final _that = this;
switch (_that) {
case _FinalQuiz():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinalQuiz value)?  $default,){
final _that = this;
switch (_that) {
case _FinalQuiz() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  List<String> options, @JsonKey(name: 'correct_idx')  int correctIdx, @JsonKey(name: 'retry_on_fail')  bool retryOnFail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinalQuiz() when $default != null:
return $default(_that.question,_that.options,_that.correctIdx,_that.retryOnFail);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  List<String> options, @JsonKey(name: 'correct_idx')  int correctIdx, @JsonKey(name: 'retry_on_fail')  bool retryOnFail)  $default,) {final _that = this;
switch (_that) {
case _FinalQuiz():
return $default(_that.question,_that.options,_that.correctIdx,_that.retryOnFail);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  List<String> options, @JsonKey(name: 'correct_idx')  int correctIdx, @JsonKey(name: 'retry_on_fail')  bool retryOnFail)?  $default,) {final _that = this;
switch (_that) {
case _FinalQuiz() when $default != null:
return $default(_that.question,_that.options,_that.correctIdx,_that.retryOnFail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinalQuiz implements FinalQuiz {
  const _FinalQuiz({required this.question, required final  List<String> options, @JsonKey(name: 'correct_idx') required this.correctIdx, @JsonKey(name: 'retry_on_fail') required this.retryOnFail}): _options = options;
  factory _FinalQuiz.fromJson(Map<String, dynamic> json) => _$FinalQuizFromJson(json);

@override final  String question;
 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(name: 'correct_idx') final  int correctIdx;
@override@JsonKey(name: 'retry_on_fail') final  bool retryOnFail;

/// Create a copy of FinalQuiz
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinalQuizCopyWith<_FinalQuiz> get copyWith => __$FinalQuizCopyWithImpl<_FinalQuiz>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinalQuizToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinalQuiz&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIdx, correctIdx) || other.correctIdx == correctIdx)&&(identical(other.retryOnFail, retryOnFail) || other.retryOnFail == retryOnFail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,const DeepCollectionEquality().hash(_options),correctIdx,retryOnFail);

@override
String toString() {
  return 'FinalQuiz(question: $question, options: $options, correctIdx: $correctIdx, retryOnFail: $retryOnFail)';
}


}

/// @nodoc
abstract mixin class _$FinalQuizCopyWith<$Res> implements $FinalQuizCopyWith<$Res> {
  factory _$FinalQuizCopyWith(_FinalQuiz value, $Res Function(_FinalQuiz) _then) = __$FinalQuizCopyWithImpl;
@override @useResult
$Res call({
 String question, List<String> options,@JsonKey(name: 'correct_idx') int correctIdx,@JsonKey(name: 'retry_on_fail') bool retryOnFail
});




}
/// @nodoc
class __$FinalQuizCopyWithImpl<$Res>
    implements _$FinalQuizCopyWith<$Res> {
  __$FinalQuizCopyWithImpl(this._self, this._then);

  final _FinalQuiz _self;
  final $Res Function(_FinalQuiz) _then;

/// Create a copy of FinalQuiz
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? options = null,Object? correctIdx = null,Object? retryOnFail = null,}) {
  return _then(_FinalQuiz(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIdx: null == correctIdx ? _self.correctIdx : correctIdx // ignore: cast_nullable_to_non_nullable
as int,retryOnFail: null == retryOnFail ? _self.retryOnFail : retryOnFail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
