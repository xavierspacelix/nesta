// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upcoming_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpcomingTask {

 String get id; String get dayLabel; String get dateLabel; String get areaName; String get assignedUser; int get completedItems; int get totalItems;
/// Create a copy of UpcomingTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingTaskCopyWith<UpcomingTask> get copyWith => _$UpcomingTaskCopyWithImpl<UpcomingTask>(this as UpcomingTask, _$identity);

  /// Serializes this UpcomingTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingTask&&(identical(other.id, id) || other.id == id)&&(identical(other.dayLabel, dayLabel) || other.dayLabel == dayLabel)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.areaName, areaName) || other.areaName == areaName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dayLabel,dateLabel,areaName,assignedUser,completedItems,totalItems);

@override
String toString() {
  return 'UpcomingTask(id: $id, dayLabel: $dayLabel, dateLabel: $dateLabel, areaName: $areaName, assignedUser: $assignedUser, completedItems: $completedItems, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class $UpcomingTaskCopyWith<$Res>  {
  factory $UpcomingTaskCopyWith(UpcomingTask value, $Res Function(UpcomingTask) _then) = _$UpcomingTaskCopyWithImpl;
@useResult
$Res call({
 String id, String dayLabel, String dateLabel, String areaName, String assignedUser, int completedItems, int totalItems
});




}
/// @nodoc
class _$UpcomingTaskCopyWithImpl<$Res>
    implements $UpcomingTaskCopyWith<$Res> {
  _$UpcomingTaskCopyWithImpl(this._self, this._then);

  final UpcomingTask _self;
  final $Res Function(UpcomingTask) _then;

/// Create a copy of UpcomingTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dayLabel = null,Object? dateLabel = null,Object? areaName = null,Object? assignedUser = null,Object? completedItems = null,Object? totalItems = null,}) {
  return _then(UpcomingTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dayLabel: null == dayLabel ? _self.dayLabel : dayLabel // ignore: cast_nullable_to_non_nullable
as String,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,areaName: null == areaName ? _self.areaName : areaName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpcomingTask].
extension UpcomingTaskPatterns on UpcomingTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpcomingTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpcomingTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpcomingTask value)  $default,){
final _that = this;
switch (_that) {
case _UpcomingTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpcomingTask value)?  $default,){
final _that = this;
switch (_that) {
case _UpcomingTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dayLabel,  String dateLabel,  String areaName,  String assignedUser,  int completedItems,  int totalItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpcomingTask() when $default != null:
return $default(_that.id,_that.dayLabel,_that.dateLabel,_that.areaName,_that.assignedUser,_that.completedItems,_that.totalItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dayLabel,  String dateLabel,  String areaName,  String assignedUser,  int completedItems,  int totalItems)  $default,) {final _that = this;
switch (_that) {
case _UpcomingTask():
return $default(_that.id,_that.dayLabel,_that.dateLabel,_that.areaName,_that.assignedUser,_that.completedItems,_that.totalItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dayLabel,  String dateLabel,  String areaName,  String assignedUser,  int completedItems,  int totalItems)?  $default,) {final _that = this;
switch (_that) {
case _UpcomingTask() when $default != null:
return $default(_that.id,_that.dayLabel,_that.dateLabel,_that.areaName,_that.assignedUser,_that.completedItems,_that.totalItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpcomingTask implements UpcomingTask {
  const _UpcomingTask({required this.id, required this.dayLabel, required this.dateLabel, required this.areaName, required this.assignedUser, this.completedItems = 0, this.totalItems = 0});
  factory _UpcomingTask.fromJson(Map<String, dynamic> json) => _$UpcomingTaskFromJson(json);

@override final  String id;
@override final  String dayLabel;
@override final  String dateLabel;
@override final  String areaName;
@override final  String assignedUser;
@override@JsonKey() final  int completedItems;
@override@JsonKey() final  int totalItems;

/// Create a copy of UpcomingTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpcomingTaskCopyWith<_UpcomingTask> get copyWith => __$UpcomingTaskCopyWithImpl<_UpcomingTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpcomingTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpcomingTask&&(identical(other.id, id) || other.id == id)&&(identical(other.dayLabel, dayLabel) || other.dayLabel == dayLabel)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.areaName, areaName) || other.areaName == areaName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dayLabel,dateLabel,areaName,assignedUser,completedItems,totalItems);

@override
String toString() {
  return 'UpcomingTask(id: $id, dayLabel: $dayLabel, dateLabel: $dateLabel, areaName: $areaName, assignedUser: $assignedUser, completedItems: $completedItems, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class _$UpcomingTaskCopyWith<$Res> implements $UpcomingTaskCopyWith<$Res> {
  factory _$UpcomingTaskCopyWith(_UpcomingTask value, $Res Function(_UpcomingTask) _then) = __$UpcomingTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String dayLabel, String dateLabel, String areaName, String assignedUser, int completedItems, int totalItems
});




}
/// @nodoc
class __$UpcomingTaskCopyWithImpl<$Res>
    implements _$UpcomingTaskCopyWith<$Res> {
  __$UpcomingTaskCopyWithImpl(this._self, this._then);

  final _UpcomingTask _self;
  final $Res Function(_UpcomingTask) _then;

/// Create a copy of UpcomingTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dayLabel = null,Object? dateLabel = null,Object? areaName = null,Object? assignedUser = null,Object? completedItems = null,Object? totalItems = null,}) {
  return _then(_UpcomingTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dayLabel: null == dayLabel ? _self.dayLabel : dayLabel // ignore: cast_nullable_to_non_nullable
as String,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,areaName: null == areaName ? _self.areaName : areaName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
