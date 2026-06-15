// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fine_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FineEntry {

 String get id; String get memberName; String get reason; int get amount; double get completionPercentage; DateTime get date; FineStatus get status;
/// Create a copy of FineEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FineEntryCopyWith<FineEntry> get copyWith => _$FineEntryCopyWithImpl<FineEntry>(this as FineEntry, _$identity);

  /// Serializes this FineEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FineEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberName,reason,amount,completionPercentage,date,status);

@override
String toString() {
  return 'FineEntry(id: $id, memberName: $memberName, reason: $reason, amount: $amount, completionPercentage: $completionPercentage, date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class $FineEntryCopyWith<$Res>  {
  factory $FineEntryCopyWith(FineEntry value, $Res Function(FineEntry) _then) = _$FineEntryCopyWithImpl;
@useResult
$Res call({
 String id, String memberName, String reason, int amount, double completionPercentage, DateTime date, FineStatus status
});




}
/// @nodoc
class _$FineEntryCopyWithImpl<$Res>
    implements $FineEntryCopyWith<$Res> {
  _$FineEntryCopyWithImpl(this._self, this._then);

  final FineEntry _self;
  final $Res Function(FineEntry) _then;

/// Create a copy of FineEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberName = null,Object? reason = null,Object? amount = null,Object? completionPercentage = null,Object? date = null,Object? status = null,}) {
  return _then(FineEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FineStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [FineEntry].
extension FineEntryPatterns on FineEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FineEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FineEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FineEntry value)  $default,){
final _that = this;
switch (_that) {
case _FineEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FineEntry value)?  $default,){
final _that = this;
switch (_that) {
case _FineEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String memberName,  String reason,  int amount,  double completionPercentage,  DateTime date,  FineStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FineEntry() when $default != null:
return $default(_that.id,_that.memberName,_that.reason,_that.amount,_that.completionPercentage,_that.date,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String memberName,  String reason,  int amount,  double completionPercentage,  DateTime date,  FineStatus status)  $default,) {final _that = this;
switch (_that) {
case _FineEntry():
return $default(_that.id,_that.memberName,_that.reason,_that.amount,_that.completionPercentage,_that.date,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String memberName,  String reason,  int amount,  double completionPercentage,  DateTime date,  FineStatus status)?  $default,) {final _that = this;
switch (_that) {
case _FineEntry() when $default != null:
return $default(_that.id,_that.memberName,_that.reason,_that.amount,_that.completionPercentage,_that.date,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FineEntry extends FineEntry {
  const _FineEntry({required this.id, required this.memberName, required this.reason, required this.amount, required this.completionPercentage, required this.date, required this.status}): super._();
  factory _FineEntry.fromJson(Map<String, dynamic> json) => _$FineEntryFromJson(json);

@override final  String id;
@override final  String memberName;
@override final  String reason;
@override final  int amount;
@override final  double completionPercentage;
@override final  DateTime date;
@override final  FineStatus status;

/// Create a copy of FineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FineEntryCopyWith<_FineEntry> get copyWith => __$FineEntryCopyWithImpl<_FineEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FineEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FineEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberName,reason,amount,completionPercentage,date,status);

@override
String toString() {
  return 'FineEntry(id: $id, memberName: $memberName, reason: $reason, amount: $amount, completionPercentage: $completionPercentage, date: $date, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FineEntryCopyWith<$Res> implements $FineEntryCopyWith<$Res> {
  factory _$FineEntryCopyWith(_FineEntry value, $Res Function(_FineEntry) _then) = __$FineEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String memberName, String reason, int amount, double completionPercentage, DateTime date, FineStatus status
});




}
/// @nodoc
class __$FineEntryCopyWithImpl<$Res>
    implements _$FineEntryCopyWith<$Res> {
  __$FineEntryCopyWithImpl(this._self, this._then);

  final _FineEntry _self;
  final $Res Function(_FineEntry) _then;

/// Create a copy of FineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberName = null,Object? reason = null,Object? amount = null,Object? completionPercentage = null,Object? date = null,Object? status = null,}) {
  return _then(_FineEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FineStatus,
  ));
}


}

// dart format on
