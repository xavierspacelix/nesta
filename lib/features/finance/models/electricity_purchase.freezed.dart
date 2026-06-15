// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'electricity_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ElectricityPurchase {

 String get id; int get amount; String get purchasedBy; DateTime get date; String? get proofPhoto;
/// Create a copy of ElectricityPurchase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ElectricityPurchaseCopyWith<ElectricityPurchase> get copyWith => _$ElectricityPurchaseCopyWithImpl<ElectricityPurchase>(this as ElectricityPurchase, _$identity);

  /// Serializes this ElectricityPurchase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ElectricityPurchase&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.purchasedBy, purchasedBy) || other.purchasedBy == purchasedBy)&&(identical(other.date, date) || other.date == date)&&(identical(other.proofPhoto, proofPhoto) || other.proofPhoto == proofPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,purchasedBy,date,proofPhoto);

@override
String toString() {
  return 'ElectricityPurchase(id: $id, amount: $amount, purchasedBy: $purchasedBy, date: $date, proofPhoto: $proofPhoto)';
}


}

/// @nodoc
abstract mixin class $ElectricityPurchaseCopyWith<$Res>  {
  factory $ElectricityPurchaseCopyWith(ElectricityPurchase value, $Res Function(ElectricityPurchase) _then) = _$ElectricityPurchaseCopyWithImpl;
@useResult
$Res call({
 String id, int amount, String purchasedBy, DateTime date, String? proofPhoto
});




}
/// @nodoc
class _$ElectricityPurchaseCopyWithImpl<$Res>
    implements $ElectricityPurchaseCopyWith<$Res> {
  _$ElectricityPurchaseCopyWithImpl(this._self, this._then);

  final ElectricityPurchase _self;
  final $Res Function(ElectricityPurchase) _then;

/// Create a copy of ElectricityPurchase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? purchasedBy = null,Object? date = null,Object? proofPhoto = freezed,}) {
  return _then(ElectricityPurchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,purchasedBy: null == purchasedBy ? _self.purchasedBy : purchasedBy // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,proofPhoto: freezed == proofPhoto ? _self.proofPhoto : proofPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ElectricityPurchase].
extension ElectricityPurchasePatterns on ElectricityPurchase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ElectricityPurchase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ElectricityPurchase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ElectricityPurchase value)  $default,){
final _that = this;
switch (_that) {
case _ElectricityPurchase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ElectricityPurchase value)?  $default,){
final _that = this;
switch (_that) {
case _ElectricityPurchase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int amount,  String purchasedBy,  DateTime date,  String? proofPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ElectricityPurchase() when $default != null:
return $default(_that.id,_that.amount,_that.purchasedBy,_that.date,_that.proofPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int amount,  String purchasedBy,  DateTime date,  String? proofPhoto)  $default,) {final _that = this;
switch (_that) {
case _ElectricityPurchase():
return $default(_that.id,_that.amount,_that.purchasedBy,_that.date,_that.proofPhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int amount,  String purchasedBy,  DateTime date,  String? proofPhoto)?  $default,) {final _that = this;
switch (_that) {
case _ElectricityPurchase() when $default != null:
return $default(_that.id,_that.amount,_that.purchasedBy,_that.date,_that.proofPhoto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ElectricityPurchase implements ElectricityPurchase {
  const _ElectricityPurchase({required this.id, required this.amount, required this.purchasedBy, required this.date, this.proofPhoto});
  factory _ElectricityPurchase.fromJson(Map<String, dynamic> json) => _$ElectricityPurchaseFromJson(json);

@override final  String id;
@override final  int amount;
@override final  String purchasedBy;
@override final  DateTime date;
@override final  String? proofPhoto;

/// Create a copy of ElectricityPurchase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ElectricityPurchaseCopyWith<_ElectricityPurchase> get copyWith => __$ElectricityPurchaseCopyWithImpl<_ElectricityPurchase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ElectricityPurchaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ElectricityPurchase&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.purchasedBy, purchasedBy) || other.purchasedBy == purchasedBy)&&(identical(other.date, date) || other.date == date)&&(identical(other.proofPhoto, proofPhoto) || other.proofPhoto == proofPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,purchasedBy,date,proofPhoto);

@override
String toString() {
  return 'ElectricityPurchase(id: $id, amount: $amount, purchasedBy: $purchasedBy, date: $date, proofPhoto: $proofPhoto)';
}


}

/// @nodoc
abstract mixin class _$ElectricityPurchaseCopyWith<$Res> implements $ElectricityPurchaseCopyWith<$Res> {
  factory _$ElectricityPurchaseCopyWith(_ElectricityPurchase value, $Res Function(_ElectricityPurchase) _then) = __$ElectricityPurchaseCopyWithImpl;
@override @useResult
$Res call({
 String id, int amount, String purchasedBy, DateTime date, String? proofPhoto
});




}
/// @nodoc
class __$ElectricityPurchaseCopyWithImpl<$Res>
    implements _$ElectricityPurchaseCopyWith<$Res> {
  __$ElectricityPurchaseCopyWithImpl(this._self, this._then);

  final _ElectricityPurchase _self;
  final $Res Function(_ElectricityPurchase) _then;

/// Create a copy of ElectricityPurchase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? purchasedBy = null,Object? date = null,Object? proofPhoto = freezed,}) {
  return _then(_ElectricityPurchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,purchasedBy: null == purchasedBy ? _self.purchasedBy : purchasedBy // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,proofPhoto: freezed == proofPhoto ? _self.proofPhoto : proofPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
