// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleEntry {

 String get id; DateTime get date; String get roomName; String get assignedUser; ScheduleStatus get status;
/// Create a copy of ScheduleEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleEntryCopyWith<ScheduleEntry> get copyWith => _$ScheduleEntryCopyWithImpl<ScheduleEntry>(this as ScheduleEntry, _$identity);

  /// Serializes this ScheduleEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,roomName,assignedUser,status);

@override
String toString() {
  return 'ScheduleEntry(id: $id, date: $date, roomName: $roomName, assignedUser: $assignedUser, status: $status)';
}


}

/// @nodoc
abstract mixin class $ScheduleEntryCopyWith<$Res>  {
  factory $ScheduleEntryCopyWith(ScheduleEntry value, $Res Function(ScheduleEntry) _then) = _$ScheduleEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String roomName, String assignedUser, ScheduleStatus status
});




}
/// @nodoc
class _$ScheduleEntryCopyWithImpl<$Res>
    implements $ScheduleEntryCopyWith<$Res> {
  _$ScheduleEntryCopyWithImpl(this._self, this._then);

  final ScheduleEntry _self;
  final $Res Function(ScheduleEntry) _then;

/// Create a copy of ScheduleEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? roomName = null,Object? assignedUser = null,Object? status = null,}) {
  return _then(ScheduleEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleEntry].
extension ScheduleEntryPatterns on ScheduleEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleEntry value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String roomName,  String assignedUser,  ScheduleStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleEntry() when $default != null:
return $default(_that.id,_that.date,_that.roomName,_that.assignedUser,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String roomName,  String assignedUser,  ScheduleStatus status)  $default,) {final _that = this;
switch (_that) {
case _ScheduleEntry():
return $default(_that.id,_that.date,_that.roomName,_that.assignedUser,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String roomName,  String assignedUser,  ScheduleStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleEntry() when $default != null:
return $default(_that.id,_that.date,_that.roomName,_that.assignedUser,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleEntry implements ScheduleEntry {
  const _ScheduleEntry({required this.id, required this.date, required this.roomName, required this.assignedUser, required this.status});
  factory _ScheduleEntry.fromJson(Map<String, dynamic> json) => _$ScheduleEntryFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String roomName;
@override final  String assignedUser;
@override final  ScheduleStatus status;

/// Create a copy of ScheduleEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleEntryCopyWith<_ScheduleEntry> get copyWith => __$ScheduleEntryCopyWithImpl<_ScheduleEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,roomName,assignedUser,status);

@override
String toString() {
  return 'ScheduleEntry(id: $id, date: $date, roomName: $roomName, assignedUser: $assignedUser, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ScheduleEntryCopyWith<$Res> implements $ScheduleEntryCopyWith<$Res> {
  factory _$ScheduleEntryCopyWith(_ScheduleEntry value, $Res Function(_ScheduleEntry) _then) = __$ScheduleEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String roomName, String assignedUser, ScheduleStatus status
});




}
/// @nodoc
class __$ScheduleEntryCopyWithImpl<$Res>
    implements _$ScheduleEntryCopyWith<$Res> {
  __$ScheduleEntryCopyWithImpl(this._self, this._then);

  final _ScheduleEntry _self;
  final $Res Function(_ScheduleEntry) _then;

/// Create a copy of ScheduleEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? roomName = null,Object? assignedUser = null,Object? status = null,}) {
  return _then(_ScheduleEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,assignedUser: null == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,
  ));
}


}

// dart format on
