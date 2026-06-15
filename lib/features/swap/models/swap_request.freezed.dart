// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SwapRequest {

 String get id; String get requesterName; String get targetMemberName; DateTime get scheduleDate; String get reason; SwapStatus get status; DateTime get createdAt;
/// Create a copy of SwapRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwapRequestCopyWith<SwapRequest> get copyWith => _$SwapRequestCopyWithImpl<SwapRequest>(this as SwapRequest, _$identity);

  /// Serializes this SwapRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.targetMemberName, targetMemberName) || other.targetMemberName == targetMemberName)&&(identical(other.scheduleDate, scheduleDate) || other.scheduleDate == scheduleDate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requesterName,targetMemberName,scheduleDate,reason,status,createdAt);

@override
String toString() {
  return 'SwapRequest(id: $id, requesterName: $requesterName, targetMemberName: $targetMemberName, scheduleDate: $scheduleDate, reason: $reason, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SwapRequestCopyWith<$Res>  {
  factory $SwapRequestCopyWith(SwapRequest value, $Res Function(SwapRequest) _then) = _$SwapRequestCopyWithImpl;
@useResult
$Res call({
 String id, String requesterName, String targetMemberName, DateTime scheduleDate, String reason, SwapStatus status, DateTime createdAt
});




}
/// @nodoc
class _$SwapRequestCopyWithImpl<$Res>
    implements $SwapRequestCopyWith<$Res> {
  _$SwapRequestCopyWithImpl(this._self, this._then);

  final SwapRequest _self;
  final $Res Function(SwapRequest) _then;

/// Create a copy of SwapRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requesterName = null,Object? targetMemberName = null,Object? scheduleDate = null,Object? reason = null,Object? status = null,Object? createdAt = null,}) {
  return _then(SwapRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,targetMemberName: null == targetMemberName ? _self.targetMemberName : targetMemberName // ignore: cast_nullable_to_non_nullable
as String,scheduleDate: null == scheduleDate ? _self.scheduleDate : scheduleDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SwapStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SwapRequest].
extension SwapRequestPatterns on SwapRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwapRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwapRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwapRequest value)  $default,){
final _that = this;
switch (_that) {
case _SwapRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwapRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SwapRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requesterName,  String targetMemberName,  DateTime scheduleDate,  String reason,  SwapStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwapRequest() when $default != null:
return $default(_that.id,_that.requesterName,_that.targetMemberName,_that.scheduleDate,_that.reason,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requesterName,  String targetMemberName,  DateTime scheduleDate,  String reason,  SwapStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SwapRequest():
return $default(_that.id,_that.requesterName,_that.targetMemberName,_that.scheduleDate,_that.reason,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requesterName,  String targetMemberName,  DateTime scheduleDate,  String reason,  SwapStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SwapRequest() when $default != null:
return $default(_that.id,_that.requesterName,_that.targetMemberName,_that.scheduleDate,_that.reason,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwapRequest implements SwapRequest {
  const _SwapRequest({required this.id, required this.requesterName, required this.targetMemberName, required this.scheduleDate, required this.reason, this.status = SwapStatus.pending, required this.createdAt});
  factory _SwapRequest.fromJson(Map<String, dynamic> json) => _$SwapRequestFromJson(json);

@override final  String id;
@override final  String requesterName;
@override final  String targetMemberName;
@override final  DateTime scheduleDate;
@override final  String reason;
@override@JsonKey() final  SwapStatus status;
@override final  DateTime createdAt;

/// Create a copy of SwapRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwapRequestCopyWith<_SwapRequest> get copyWith => __$SwapRequestCopyWithImpl<_SwapRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwapRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwapRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.targetMemberName, targetMemberName) || other.targetMemberName == targetMemberName)&&(identical(other.scheduleDate, scheduleDate) || other.scheduleDate == scheduleDate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requesterName,targetMemberName,scheduleDate,reason,status,createdAt);

@override
String toString() {
  return 'SwapRequest(id: $id, requesterName: $requesterName, targetMemberName: $targetMemberName, scheduleDate: $scheduleDate, reason: $reason, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SwapRequestCopyWith<$Res> implements $SwapRequestCopyWith<$Res> {
  factory _$SwapRequestCopyWith(_SwapRequest value, $Res Function(_SwapRequest) _then) = __$SwapRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String requesterName, String targetMemberName, DateTime scheduleDate, String reason, SwapStatus status, DateTime createdAt
});




}
/// @nodoc
class __$SwapRequestCopyWithImpl<$Res>
    implements _$SwapRequestCopyWith<$Res> {
  __$SwapRequestCopyWithImpl(this._self, this._then);

  final _SwapRequest _self;
  final $Res Function(_SwapRequest) _then;

/// Create a copy of SwapRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requesterName = null,Object? targetMemberName = null,Object? scheduleDate = null,Object? reason = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_SwapRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,targetMemberName: null == targetMemberName ? _self.targetMemberName : targetMemberName // ignore: cast_nullable_to_non_nullable
as String,scheduleDate: null == scheduleDate ? _self.scheduleDate : scheduleDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SwapStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
