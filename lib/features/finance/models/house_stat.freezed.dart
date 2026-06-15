// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'house_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HouseStat {

 String get completedToday; String get activeFines; String get monthlyPerformance; String get upcomingBills;
/// Create a copy of HouseStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseStatCopyWith<HouseStat> get copyWith => _$HouseStatCopyWithImpl<HouseStat>(this as HouseStat, _$identity);

  /// Serializes this HouseStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseStat&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.activeFines, activeFines) || other.activeFines == activeFines)&&(identical(other.monthlyPerformance, monthlyPerformance) || other.monthlyPerformance == monthlyPerformance)&&(identical(other.upcomingBills, upcomingBills) || other.upcomingBills == upcomingBills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completedToday,activeFines,monthlyPerformance,upcomingBills);

@override
String toString() {
  return 'HouseStat(completedToday: $completedToday, activeFines: $activeFines, monthlyPerformance: $monthlyPerformance, upcomingBills: $upcomingBills)';
}


}

/// @nodoc
abstract mixin class $HouseStatCopyWith<$Res>  {
  factory $HouseStatCopyWith(HouseStat value, $Res Function(HouseStat) _then) = _$HouseStatCopyWithImpl;
@useResult
$Res call({
 String completedToday, String activeFines, String monthlyPerformance, String upcomingBills
});




}
/// @nodoc
class _$HouseStatCopyWithImpl<$Res>
    implements $HouseStatCopyWith<$Res> {
  _$HouseStatCopyWithImpl(this._self, this._then);

  final HouseStat _self;
  final $Res Function(HouseStat) _then;

/// Create a copy of HouseStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedToday = null,Object? activeFines = null,Object? monthlyPerformance = null,Object? upcomingBills = null,}) {
  return _then(HouseStat(
completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as String,activeFines: null == activeFines ? _self.activeFines : activeFines // ignore: cast_nullable_to_non_nullable
as String,monthlyPerformance: null == monthlyPerformance ? _self.monthlyPerformance : monthlyPerformance // ignore: cast_nullable_to_non_nullable
as String,upcomingBills: null == upcomingBills ? _self.upcomingBills : upcomingBills // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HouseStat].
extension HouseStatPatterns on HouseStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseStat value)  $default,){
final _that = this;
switch (_that) {
case _HouseStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseStat value)?  $default,){
final _that = this;
switch (_that) {
case _HouseStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String completedToday,  String activeFines,  String monthlyPerformance,  String upcomingBills)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseStat() when $default != null:
return $default(_that.completedToday,_that.activeFines,_that.monthlyPerformance,_that.upcomingBills);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String completedToday,  String activeFines,  String monthlyPerformance,  String upcomingBills)  $default,) {final _that = this;
switch (_that) {
case _HouseStat():
return $default(_that.completedToday,_that.activeFines,_that.monthlyPerformance,_that.upcomingBills);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String completedToday,  String activeFines,  String monthlyPerformance,  String upcomingBills)?  $default,) {final _that = this;
switch (_that) {
case _HouseStat() when $default != null:
return $default(_that.completedToday,_that.activeFines,_that.monthlyPerformance,_that.upcomingBills);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HouseStat implements HouseStat {
  const _HouseStat({required this.completedToday, required this.activeFines, required this.monthlyPerformance, required this.upcomingBills});
  factory _HouseStat.fromJson(Map<String, dynamic> json) => _$HouseStatFromJson(json);

@override final  String completedToday;
@override final  String activeFines;
@override final  String monthlyPerformance;
@override final  String upcomingBills;

/// Create a copy of HouseStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseStatCopyWith<_HouseStat> get copyWith => __$HouseStatCopyWithImpl<_HouseStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseStat&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.activeFines, activeFines) || other.activeFines == activeFines)&&(identical(other.monthlyPerformance, monthlyPerformance) || other.monthlyPerformance == monthlyPerformance)&&(identical(other.upcomingBills, upcomingBills) || other.upcomingBills == upcomingBills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completedToday,activeFines,monthlyPerformance,upcomingBills);

@override
String toString() {
  return 'HouseStat(completedToday: $completedToday, activeFines: $activeFines, monthlyPerformance: $monthlyPerformance, upcomingBills: $upcomingBills)';
}


}

/// @nodoc
abstract mixin class _$HouseStatCopyWith<$Res> implements $HouseStatCopyWith<$Res> {
  factory _$HouseStatCopyWith(_HouseStat value, $Res Function(_HouseStat) _then) = __$HouseStatCopyWithImpl;
@override @useResult
$Res call({
 String completedToday, String activeFines, String monthlyPerformance, String upcomingBills
});




}
/// @nodoc
class __$HouseStatCopyWithImpl<$Res>
    implements _$HouseStatCopyWith<$Res> {
  __$HouseStatCopyWithImpl(this._self, this._then);

  final _HouseStat _self;
  final $Res Function(_HouseStat) _then;

/// Create a copy of HouseStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedToday = null,Object? activeFines = null,Object? monthlyPerformance = null,Object? upcomingBills = null,}) {
  return _then(_HouseStat(
completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as String,activeFines: null == activeFines ? _self.activeFines : activeFines // ignore: cast_nullable_to_non_nullable
as String,monthlyPerformance: null == monthlyPerformance ? _self.monthlyPerformance : monthlyPerformance // ignore: cast_nullable_to_non_nullable
as String,upcomingBills: null == upcomingBills ? _self.upcomingBills : upcomingBills // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
