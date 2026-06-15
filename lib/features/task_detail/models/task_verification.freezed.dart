// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskVerification {

 String get id; String get roomName; String get assignedUser; DateTime get assignedDate; DateTime? get completedAt; double get completionPercentage; int get completedItems; int get totalItems; String? get beforePhoto; String? get afterPhoto; VerificationStatus get status;
/// Create a copy of TaskVerification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskVerificationCopyWith<TaskVerification> get copyWith => _$TaskVerificationCopyWithImpl<TaskVerification>(this as TaskVerification, _$identity);

  /// Serializes this TaskVerification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.assignedDate, assignedDate) || other.assignedDate == assignedDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.beforePhoto, beforePhoto) || other.beforePhoto == beforePhoto)&&(identical(other.afterPhoto, afterPhoto) || other.afterPhoto == afterPhoto)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomName,assignedUser,assignedDate,completedAt,completionPercentage,completedItems,totalItems,beforePhoto,afterPhoto,status);

@override
String toString() {
  return 'TaskVerification(id: $id, roomName: $roomName, assignedUser: $assignedUser, assignedDate: $assignedDate, completedAt: $completedAt, completionPercentage: $completionPercentage, completedItems: $completedItems, totalItems: $totalItems, beforePhoto: $beforePhoto, afterPhoto: $afterPhoto, status: $status)';
}


}

/// @nodoc
abstract mixin class $TaskVerificationCopyWith<$Res>  {
  factory $TaskVerificationCopyWith(TaskVerification value, $Res Function(TaskVerification) _then) = _$TaskVerificationCopyWithImpl;
@useResult
$Res call({
 String id, String roomName, String assignedUser, DateTime assignedDate, DateTime? completedAt, double completionPercentage, int completedItems, int totalItems, String? beforePhoto, String? afterPhoto, VerificationStatus status
});




}
/// @nodoc
class _$TaskVerificationCopyWithImpl<$Res>
    implements $TaskVerificationCopyWith<$Res> {
  _$TaskVerificationCopyWithImpl(this._self, this._then);

  final TaskVerification _self;
  final $Res Function(TaskVerification) _then;

/// Create a copy of TaskVerification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomName = null,Object? assignedUser = null,Object? assignedDate = null,Object? completedAt = freezed,Object? completionPercentage = null,Object? completedItems = null,Object? totalItems = null,Object? beforePhoto = freezed,Object? afterPhoto = freezed,Object? status = null,}) {
  return _then(TaskVerification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,assignedDate: null == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as double,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,beforePhoto: freezed == beforePhoto ? _self.beforePhoto : beforePhoto // ignore: cast_nullable_to_non_nullable
as String?,afterPhoto: freezed == afterPhoto ? _self.afterPhoto : afterPhoto // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskVerification].
extension TaskVerificationPatterns on TaskVerification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskVerification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskVerification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskVerification value)  $default,){
final _that = this;
switch (_that) {
case _TaskVerification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskVerification value)?  $default,){
final _that = this;
switch (_that) {
case _TaskVerification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String roomName,  String assignedUser,  DateTime assignedDate,  DateTime? completedAt,  double completionPercentage,  int completedItems,  int totalItems,  String? beforePhoto,  String? afterPhoto,  VerificationStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskVerification() when $default != null:
return $default(_that.id,_that.roomName,_that.assignedUser,_that.assignedDate,_that.completedAt,_that.completionPercentage,_that.completedItems,_that.totalItems,_that.beforePhoto,_that.afterPhoto,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String roomName,  String assignedUser,  DateTime assignedDate,  DateTime? completedAt,  double completionPercentage,  int completedItems,  int totalItems,  String? beforePhoto,  String? afterPhoto,  VerificationStatus status)  $default,) {final _that = this;
switch (_that) {
case _TaskVerification():
return $default(_that.id,_that.roomName,_that.assignedUser,_that.assignedDate,_that.completedAt,_that.completionPercentage,_that.completedItems,_that.totalItems,_that.beforePhoto,_that.afterPhoto,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String roomName,  String assignedUser,  DateTime assignedDate,  DateTime? completedAt,  double completionPercentage,  int completedItems,  int totalItems,  String? beforePhoto,  String? afterPhoto,  VerificationStatus status)?  $default,) {final _that = this;
switch (_that) {
case _TaskVerification() when $default != null:
return $default(_that.id,_that.roomName,_that.assignedUser,_that.assignedDate,_that.completedAt,_that.completionPercentage,_that.completedItems,_that.totalItems,_that.beforePhoto,_that.afterPhoto,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskVerification implements TaskVerification {
  const _TaskVerification({required this.id, required this.roomName, required this.assignedUser, required this.assignedDate, this.completedAt, required this.completionPercentage, required this.completedItems, required this.totalItems, this.beforePhoto, this.afterPhoto, required this.status});
  factory _TaskVerification.fromJson(Map<String, dynamic> json) => _$TaskVerificationFromJson(json);

@override final  String id;
@override final  String roomName;
@override final  String assignedUser;
@override final  DateTime assignedDate;
@override final  DateTime? completedAt;
@override final  double completionPercentage;
@override final  int completedItems;
@override final  int totalItems;
@override final  String? beforePhoto;
@override final  String? afterPhoto;
@override final  VerificationStatus status;

/// Create a copy of TaskVerification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskVerificationCopyWith<_TaskVerification> get copyWith => __$TaskVerificationCopyWithImpl<_TaskVerification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskVerificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.assignedDate, assignedDate) || other.assignedDate == assignedDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.beforePhoto, beforePhoto) || other.beforePhoto == beforePhoto)&&(identical(other.afterPhoto, afterPhoto) || other.afterPhoto == afterPhoto)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomName,assignedUser,assignedDate,completedAt,completionPercentage,completedItems,totalItems,beforePhoto,afterPhoto,status);

@override
String toString() {
  return 'TaskVerification(id: $id, roomName: $roomName, assignedUser: $assignedUser, assignedDate: $assignedDate, completedAt: $completedAt, completionPercentage: $completionPercentage, completedItems: $completedItems, totalItems: $totalItems, beforePhoto: $beforePhoto, afterPhoto: $afterPhoto, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TaskVerificationCopyWith<$Res> implements $TaskVerificationCopyWith<$Res> {
  factory _$TaskVerificationCopyWith(_TaskVerification value, $Res Function(_TaskVerification) _then) = __$TaskVerificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String roomName, String assignedUser, DateTime assignedDate, DateTime? completedAt, double completionPercentage, int completedItems, int totalItems, String? beforePhoto, String? afterPhoto, VerificationStatus status
});




}
/// @nodoc
class __$TaskVerificationCopyWithImpl<$Res>
    implements _$TaskVerificationCopyWith<$Res> {
  __$TaskVerificationCopyWithImpl(this._self, this._then);

  final _TaskVerification _self;
  final $Res Function(_TaskVerification) _then;

/// Create a copy of TaskVerification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomName = null,Object? assignedUser = null,Object? assignedDate = null,Object? completedAt = freezed,Object? completionPercentage = null,Object? completedItems = null,Object? totalItems = null,Object? beforePhoto = freezed,Object? afterPhoto = freezed,Object? status = null,}) {
  return _then(_TaskVerification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,assignedDate: null == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as double,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,beforePhoto: freezed == beforePhoto ? _self.beforePhoto : beforePhoto // ignore: cast_nullable_to_non_nullable
as String?,afterPhoto: freezed == afterPhoto ? _self.afterPhoto : afterPhoto // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,
  ));
}


}

// dart format on
