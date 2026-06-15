// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chore.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chore {

 String get id; String get title; int get completedTasks; int get totalTasks; bool get isStarted;
/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoreCopyWith<Chore> get copyWith => _$ChoreCopyWithImpl<Chore>(this as Chore, _$identity);

  /// Serializes this Chore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chore&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.isStarted, isStarted) || other.isStarted == isStarted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,completedTasks,totalTasks,isStarted);

@override
String toString() {
  return 'Chore(id: $id, title: $title, completedTasks: $completedTasks, totalTasks: $totalTasks, isStarted: $isStarted)';
}


}

/// @nodoc
abstract mixin class $ChoreCopyWith<$Res>  {
  factory $ChoreCopyWith(Chore value, $Res Function(Chore) _then) = _$ChoreCopyWithImpl;
@useResult
$Res call({
 String id, String title, int completedTasks, int totalTasks, bool isStarted
});




}
/// @nodoc
class _$ChoreCopyWithImpl<$Res>
    implements $ChoreCopyWith<$Res> {
  _$ChoreCopyWithImpl(this._self, this._then);

  final Chore _self;
  final $Res Function(Chore) _then;

/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? completedTasks = null,Object? totalTasks = null,Object? isStarted = null,}) {
  return _then(Chore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,isStarted: null == isStarted ? _self.isStarted : isStarted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Chore].
extension ChorePatterns on Chore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chore value)  $default,){
final _that = this;
switch (_that) {
case _Chore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chore value)?  $default,){
final _that = this;
switch (_that) {
case _Chore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int completedTasks,  int totalTasks,  bool isStarted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chore() when $default != null:
return $default(_that.id,_that.title,_that.completedTasks,_that.totalTasks,_that.isStarted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int completedTasks,  int totalTasks,  bool isStarted)  $default,) {final _that = this;
switch (_that) {
case _Chore():
return $default(_that.id,_that.title,_that.completedTasks,_that.totalTasks,_that.isStarted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int completedTasks,  int totalTasks,  bool isStarted)?  $default,) {final _that = this;
switch (_that) {
case _Chore() when $default != null:
return $default(_that.id,_that.title,_that.completedTasks,_that.totalTasks,_that.isStarted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chore implements Chore {
  const _Chore({required this.id, required this.title, required this.completedTasks, required this.totalTasks, required this.isStarted});
  factory _Chore.fromJson(Map<String, dynamic> json) => _$ChoreFromJson(json);

@override final  String id;
@override final  String title;
@override final  int completedTasks;
@override final  int totalTasks;
@override final  bool isStarted;

/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChoreCopyWith<_Chore> get copyWith => __$ChoreCopyWithImpl<_Chore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chore&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.isStarted, isStarted) || other.isStarted == isStarted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,completedTasks,totalTasks,isStarted);

@override
String toString() {
  return 'Chore(id: $id, title: $title, completedTasks: $completedTasks, totalTasks: $totalTasks, isStarted: $isStarted)';
}


}

/// @nodoc
abstract mixin class _$ChoreCopyWith<$Res> implements $ChoreCopyWith<$Res> {
  factory _$ChoreCopyWith(_Chore value, $Res Function(_Chore) _then) = __$ChoreCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int completedTasks, int totalTasks, bool isStarted
});




}
/// @nodoc
class __$ChoreCopyWithImpl<$Res>
    implements _$ChoreCopyWith<$Res> {
  __$ChoreCopyWithImpl(this._self, this._then);

  final _Chore _self;
  final $Res Function(_Chore) _then;

/// Create a copy of Chore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? completedTasks = null,Object? totalTasks = null,Object? isStarted = null,}) {
  return _then(_Chore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,isStarted: null == isStarted ? _self.isStarted : isStarted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
