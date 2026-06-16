// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterSchedule {

 String get nextBuyer; String get lastBuyer; DateTime? get lastPurchaseDate; int get daysSinceLastPurchase; List<WaterPurchase> get history;
/// Create a copy of WaterSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterScheduleCopyWith<WaterSchedule> get copyWith => _$WaterScheduleCopyWithImpl<WaterSchedule>(this as WaterSchedule, _$identity);

  /// Serializes this WaterSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterSchedule&&(identical(other.nextBuyer, nextBuyer) || other.nextBuyer == nextBuyer)&&(identical(other.lastBuyer, lastBuyer) || other.lastBuyer == lastBuyer)&&(identical(other.lastPurchaseDate, lastPurchaseDate) || other.lastPurchaseDate == lastPurchaseDate)&&(identical(other.daysSinceLastPurchase, daysSinceLastPurchase) || other.daysSinceLastPurchase == daysSinceLastPurchase)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextBuyer,lastBuyer,lastPurchaseDate,daysSinceLastPurchase,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'WaterSchedule(nextBuyer: $nextBuyer, lastBuyer: $lastBuyer, lastPurchaseDate: $lastPurchaseDate, daysSinceLastPurchase: $daysSinceLastPurchase, history: $history)';
}


}

/// @nodoc
abstract mixin class $WaterScheduleCopyWith<$Res>  {
  factory $WaterScheduleCopyWith(WaterSchedule value, $Res Function(WaterSchedule) _then) = _$WaterScheduleCopyWithImpl;
@useResult
$Res call({
 String nextBuyer, String lastBuyer, DateTime? lastPurchaseDate, int daysSinceLastPurchase, List<WaterPurchase> history
});




}
/// @nodoc
class _$WaterScheduleCopyWithImpl<$Res>
    implements $WaterScheduleCopyWith<$Res> {
  _$WaterScheduleCopyWithImpl(this._self, this._then);

  final WaterSchedule _self;
  final $Res Function(WaterSchedule) _then;

/// Create a copy of WaterSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextBuyer = null,Object? lastBuyer = null,Object? lastPurchaseDate = freezed,Object? daysSinceLastPurchase = null,Object? history = null,}) {
  return _then(WaterSchedule(
nextBuyer: null == nextBuyer ? _self.nextBuyer : nextBuyer // ignore: cast_nullable_to_non_nullable
as String,lastBuyer: null == lastBuyer ? _self.lastBuyer : lastBuyer // ignore: cast_nullable_to_non_nullable
as String,lastPurchaseDate: freezed == lastPurchaseDate ? _self.lastPurchaseDate : lastPurchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysSinceLastPurchase: null == daysSinceLastPurchase ? _self.daysSinceLastPurchase : daysSinceLastPurchase // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<WaterPurchase>,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterSchedule].
extension WaterSchedulePatterns on WaterSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterSchedule value)  $default,){
final _that = this;
switch (_that) {
case _WaterSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _WaterSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nextBuyer,  String lastBuyer,  DateTime? lastPurchaseDate,  int daysSinceLastPurchase,  List<WaterPurchase> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterSchedule() when $default != null:
return $default(_that.nextBuyer,_that.lastBuyer,_that.lastPurchaseDate,_that.daysSinceLastPurchase,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nextBuyer,  String lastBuyer,  DateTime? lastPurchaseDate,  int daysSinceLastPurchase,  List<WaterPurchase> history)  $default,) {final _that = this;
switch (_that) {
case _WaterSchedule():
return $default(_that.nextBuyer,_that.lastBuyer,_that.lastPurchaseDate,_that.daysSinceLastPurchase,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nextBuyer,  String lastBuyer,  DateTime? lastPurchaseDate,  int daysSinceLastPurchase,  List<WaterPurchase> history)?  $default,) {final _that = this;
switch (_that) {
case _WaterSchedule() when $default != null:
return $default(_that.nextBuyer,_that.lastBuyer,_that.lastPurchaseDate,_that.daysSinceLastPurchase,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterSchedule implements WaterSchedule {
  const _WaterSchedule({required this.nextBuyer, required this.lastBuyer, required this.lastPurchaseDate, required this.daysSinceLastPurchase, required  List<WaterPurchase> history}): _history = history;
  factory _WaterSchedule.fromJson(Map<String, dynamic> json) => _$WaterScheduleFromJson(json);

@override final  String nextBuyer;
@override final  String lastBuyer;
@override final  DateTime? lastPurchaseDate;
@override final  int daysSinceLastPurchase;
 final  List<WaterPurchase> _history;
@override List<WaterPurchase> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of WaterSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterScheduleCopyWith<_WaterSchedule> get copyWith => __$WaterScheduleCopyWithImpl<_WaterSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterSchedule&&(identical(other.nextBuyer, nextBuyer) || other.nextBuyer == nextBuyer)&&(identical(other.lastBuyer, lastBuyer) || other.lastBuyer == lastBuyer)&&(identical(other.lastPurchaseDate, lastPurchaseDate) || other.lastPurchaseDate == lastPurchaseDate)&&(identical(other.daysSinceLastPurchase, daysSinceLastPurchase) || other.daysSinceLastPurchase == daysSinceLastPurchase)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextBuyer,lastBuyer,lastPurchaseDate,daysSinceLastPurchase,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'WaterSchedule(nextBuyer: $nextBuyer, lastBuyer: $lastBuyer, lastPurchaseDate: $lastPurchaseDate, daysSinceLastPurchase: $daysSinceLastPurchase, history: $history)';
}


}

/// @nodoc
abstract mixin class _$WaterScheduleCopyWith<$Res> implements $WaterScheduleCopyWith<$Res> {
  factory _$WaterScheduleCopyWith(_WaterSchedule value, $Res Function(_WaterSchedule) _then) = __$WaterScheduleCopyWithImpl;
@override @useResult
$Res call({
 String nextBuyer, String lastBuyer, DateTime? lastPurchaseDate, int daysSinceLastPurchase, List<WaterPurchase> history
});




}
/// @nodoc
class __$WaterScheduleCopyWithImpl<$Res>
    implements _$WaterScheduleCopyWith<$Res> {
  __$WaterScheduleCopyWithImpl(this._self, this._then);

  final _WaterSchedule _self;
  final $Res Function(_WaterSchedule) _then;

/// Create a copy of WaterSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextBuyer = null,Object? lastBuyer = null,Object? lastPurchaseDate = freezed,Object? daysSinceLastPurchase = null,Object? history = null,}) {
  return _then(_WaterSchedule(
nextBuyer: null == nextBuyer ? _self.nextBuyer : nextBuyer // ignore: cast_nullable_to_non_nullable
as String,lastBuyer: null == lastBuyer ? _self.lastBuyer : lastBuyer // ignore: cast_nullable_to_non_nullable
as String,lastPurchaseDate: freezed == lastPurchaseDate ? _self.lastPurchaseDate : lastPurchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysSinceLastPurchase: null == daysSinceLastPurchase ? _self.daysSinceLastPurchase : daysSinceLastPurchase // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<WaterPurchase>,
  ));
}


}


/// @nodoc
mixin _$WaterPurchase {

 String get id; String get buyerName; DateTime get date; String? get proofPhoto; bool get isVerified;
/// Create a copy of WaterPurchase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterPurchaseCopyWith<WaterPurchase> get copyWith => _$WaterPurchaseCopyWithImpl<WaterPurchase>(this as WaterPurchase, _$identity);

  /// Serializes this WaterPurchase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterPurchase&&(identical(other.id, id) || other.id == id)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.date, date) || other.date == date)&&(identical(other.proofPhoto, proofPhoto) || other.proofPhoto == proofPhoto)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,buyerName,date,proofPhoto,isVerified);

@override
String toString() {
  return 'WaterPurchase(id: $id, buyerName: $buyerName, date: $date, proofPhoto: $proofPhoto, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $WaterPurchaseCopyWith<$Res>  {
  factory $WaterPurchaseCopyWith(WaterPurchase value, $Res Function(WaterPurchase) _then) = _$WaterPurchaseCopyWithImpl;
@useResult
$Res call({
 String id, String buyerName, DateTime date, String? proofPhoto, bool isVerified
});




}
/// @nodoc
class _$WaterPurchaseCopyWithImpl<$Res>
    implements $WaterPurchaseCopyWith<$Res> {
  _$WaterPurchaseCopyWithImpl(this._self, this._then);

  final WaterPurchase _self;
  final $Res Function(WaterPurchase) _then;

/// Create a copy of WaterPurchase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? buyerName = null,Object? date = null,Object? proofPhoto = freezed,Object? isVerified = null,}) {
  return _then(WaterPurchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,buyerName: null == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,proofPhoto: freezed == proofPhoto ? _self.proofPhoto : proofPhoto // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterPurchase].
extension WaterPurchasePatterns on WaterPurchase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterPurchase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterPurchase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterPurchase value)  $default,){
final _that = this;
switch (_that) {
case _WaterPurchase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterPurchase value)?  $default,){
final _that = this;
switch (_that) {
case _WaterPurchase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String buyerName,  DateTime date,  String? proofPhoto,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterPurchase() when $default != null:
return $default(_that.id,_that.buyerName,_that.date,_that.proofPhoto,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String buyerName,  DateTime date,  String? proofPhoto,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _WaterPurchase():
return $default(_that.id,_that.buyerName,_that.date,_that.proofPhoto,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String buyerName,  DateTime date,  String? proofPhoto,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _WaterPurchase() when $default != null:
return $default(_that.id,_that.buyerName,_that.date,_that.proofPhoto,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterPurchase extends WaterPurchase {
  const _WaterPurchase({required this.id, required this.buyerName, required this.date, this.proofPhoto, this.isVerified = false}): super._();
  factory _WaterPurchase.fromJson(Map<String, dynamic> json) => _$WaterPurchaseFromJson(json);

@override final  String id;
@override final  String buyerName;
@override final  DateTime date;
@override final  String? proofPhoto;
@override@JsonKey() final  bool isVerified;

/// Create a copy of WaterPurchase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterPurchaseCopyWith<_WaterPurchase> get copyWith => __$WaterPurchaseCopyWithImpl<_WaterPurchase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterPurchaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterPurchase&&(identical(other.id, id) || other.id == id)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.date, date) || other.date == date)&&(identical(other.proofPhoto, proofPhoto) || other.proofPhoto == proofPhoto)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,buyerName,date,proofPhoto,isVerified);

@override
String toString() {
  return 'WaterPurchase(id: $id, buyerName: $buyerName, date: $date, proofPhoto: $proofPhoto, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$WaterPurchaseCopyWith<$Res> implements $WaterPurchaseCopyWith<$Res> {
  factory _$WaterPurchaseCopyWith(_WaterPurchase value, $Res Function(_WaterPurchase) _then) = __$WaterPurchaseCopyWithImpl;
@override @useResult
$Res call({
 String id, String buyerName, DateTime date, String? proofPhoto, bool isVerified
});




}
/// @nodoc
class __$WaterPurchaseCopyWithImpl<$Res>
    implements _$WaterPurchaseCopyWith<$Res> {
  __$WaterPurchaseCopyWithImpl(this._self, this._then);

  final _WaterPurchase _self;
  final $Res Function(_WaterPurchase) _then;

/// Create a copy of WaterPurchase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? buyerName = null,Object? date = null,Object? proofPhoto = freezed,Object? isVerified = null,}) {
  return _then(_WaterPurchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,buyerName: null == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,proofPhoto: freezed == proofPhoto ? _self.proofPhoto : proofPhoto // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
