// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskDetail {

 String get id; String get roomName; String get assignedUser; DateTime get date; TaskStatus get status; List<ChecklistItem> get checklist; String? get beforePhoto; String? get afterPhoto;
/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailCopyWith<TaskDetail> get copyWith => _$TaskDetailCopyWithImpl<TaskDetail>(this as TaskDetail, _$identity);

  /// Serializes this TaskDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&(identical(other.beforePhoto, beforePhoto) || other.beforePhoto == beforePhoto)&&(identical(other.afterPhoto, afterPhoto) || other.afterPhoto == afterPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomName,assignedUser,date,status,const DeepCollectionEquality().hash(checklist),beforePhoto,afterPhoto);

@override
String toString() {
  return 'TaskDetail(id: $id, roomName: $roomName, assignedUser: $assignedUser, date: $date, status: $status, checklist: $checklist, beforePhoto: $beforePhoto, afterPhoto: $afterPhoto)';
}


}

/// @nodoc
abstract mixin class $TaskDetailCopyWith<$Res>  {
  factory $TaskDetailCopyWith(TaskDetail value, $Res Function(TaskDetail) _then) = _$TaskDetailCopyWithImpl;
@useResult
$Res call({
 String id, String roomName, String assignedUser, DateTime date, TaskStatus status, List<ChecklistItem> checklist, String? beforePhoto, String? afterPhoto
});




}
/// @nodoc
class _$TaskDetailCopyWithImpl<$Res>
    implements $TaskDetailCopyWith<$Res> {
  _$TaskDetailCopyWithImpl(this._self, this._then);

  final TaskDetail _self;
  final $Res Function(TaskDetail) _then;

/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomName = null,Object? assignedUser = null,Object? date = null,Object? status = null,Object? checklist = null,Object? beforePhoto = freezed,Object? afterPhoto = freezed,}) {
  return _then(TaskDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,beforePhoto: freezed == beforePhoto ? _self.beforePhoto : beforePhoto // ignore: cast_nullable_to_non_nullable
as String?,afterPhoto: freezed == afterPhoto ? _self.afterPhoto : afterPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDetail].
extension TaskDetailPatterns on TaskDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDetail value)  $default,){
final _that = this;
switch (_that) {
case _TaskDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String roomName,  String assignedUser,  DateTime date,  TaskStatus status,  List<ChecklistItem> checklist,  String? beforePhoto,  String? afterPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
return $default(_that.id,_that.roomName,_that.assignedUser,_that.date,_that.status,_that.checklist,_that.beforePhoto,_that.afterPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String roomName,  String assignedUser,  DateTime date,  TaskStatus status,  List<ChecklistItem> checklist,  String? beforePhoto,  String? afterPhoto)  $default,) {final _that = this;
switch (_that) {
case _TaskDetail():
return $default(_that.id,_that.roomName,_that.assignedUser,_that.date,_that.status,_that.checklist,_that.beforePhoto,_that.afterPhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String roomName,  String assignedUser,  DateTime date,  TaskStatus status,  List<ChecklistItem> checklist,  String? beforePhoto,  String? afterPhoto)?  $default,) {final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
return $default(_that.id,_that.roomName,_that.assignedUser,_that.date,_that.status,_that.checklist,_that.beforePhoto,_that.afterPhoto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskDetail extends TaskDetail {
  const _TaskDetail({required this.id, required this.roomName, required this.assignedUser, required this.date, required this.status,  List<ChecklistItem> checklist = const [], this.beforePhoto, this.afterPhoto}): _checklist = checklist,super._();
  factory _TaskDetail.fromJson(Map<String, dynamic> json) => _$TaskDetailFromJson(json);

@override final  String id;
@override final  String roomName;
@override final  String assignedUser;
@override final  DateTime date;
@override final  TaskStatus status;
 final  List<ChecklistItem> _checklist;
@override@JsonKey() List<ChecklistItem> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

@override final  String? beforePhoto;
@override final  String? afterPhoto;

/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDetailCopyWith<_TaskDetail> get copyWith => __$TaskDetailCopyWithImpl<_TaskDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&(identical(other.beforePhoto, beforePhoto) || other.beforePhoto == beforePhoto)&&(identical(other.afterPhoto, afterPhoto) || other.afterPhoto == afterPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomName,assignedUser,date,status,const DeepCollectionEquality().hash(_checklist),beforePhoto,afterPhoto);

@override
String toString() {
  return 'TaskDetail(id: $id, roomName: $roomName, assignedUser: $assignedUser, date: $date, status: $status, checklist: $checklist, beforePhoto: $beforePhoto, afterPhoto: $afterPhoto)';
}


}

/// @nodoc
abstract mixin class _$TaskDetailCopyWith<$Res> implements $TaskDetailCopyWith<$Res> {
  factory _$TaskDetailCopyWith(_TaskDetail value, $Res Function(_TaskDetail) _then) = __$TaskDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String roomName, String assignedUser, DateTime date, TaskStatus status, List<ChecklistItem> checklist, String? beforePhoto, String? afterPhoto
});




}
/// @nodoc
class __$TaskDetailCopyWithImpl<$Res>
    implements _$TaskDetailCopyWith<$Res> {
  __$TaskDetailCopyWithImpl(this._self, this._then);

  final _TaskDetail _self;
  final $Res Function(_TaskDetail) _then;

/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomName = null,Object? assignedUser = null,Object? date = null,Object? status = null,Object? checklist = null,Object? beforePhoto = freezed,Object? afterPhoto = freezed,}) {
  return _then(_TaskDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,beforePhoto: freezed == beforePhoto ? _self.beforePhoto : beforePhoto // ignore: cast_nullable_to_non_nullable
as String?,afterPhoto: freezed == afterPhoto ? _self.afterPhoto : afterPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
