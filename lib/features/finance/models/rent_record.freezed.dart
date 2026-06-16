// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RentRecord {

 int get year; int get month; int get totalRent; int get totalWifi; List<MemberPayment> get payments; bool get isPaid; DateTime? get paidAt; String? get bankName; String? get bankAccountNumber;
/// Create a copy of RentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentRecordCopyWith<RentRecord> get copyWith => _$RentRecordCopyWithImpl<RentRecord>(this as RentRecord, _$identity);

  /// Serializes this RentRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentRecord&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalRent, totalRent) || other.totalRent == totalRent)&&(identical(other.totalWifi, totalWifi) || other.totalWifi == totalWifi)&&const DeepCollectionEquality().equals(other.payments, payments)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankAccountNumber, bankAccountNumber) || other.bankAccountNumber == bankAccountNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,totalRent,totalWifi,const DeepCollectionEquality().hash(payments),isPaid,paidAt,bankName,bankAccountNumber);

@override
String toString() {
  return 'RentRecord(year: $year, month: $month, totalRent: $totalRent, totalWifi: $totalWifi, payments: $payments, isPaid: $isPaid, paidAt: $paidAt, bankName: $bankName, bankAccountNumber: $bankAccountNumber)';
}


}

/// @nodoc
abstract mixin class $RentRecordCopyWith<$Res>  {
  factory $RentRecordCopyWith(RentRecord value, $Res Function(RentRecord) _then) = _$RentRecordCopyWithImpl;
@useResult
$Res call({
 int year, int month, int totalRent, int totalWifi, List<MemberPayment> payments, bool isPaid, DateTime? paidAt, String? bankName, String? bankAccountNumber
});




}
/// @nodoc
class _$RentRecordCopyWithImpl<$Res>
    implements $RentRecordCopyWith<$Res> {
  _$RentRecordCopyWithImpl(this._self, this._then);

  final RentRecord _self;
  final $Res Function(RentRecord) _then;

/// Create a copy of RentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? totalRent = null,Object? totalWifi = null,Object? payments = null,Object? isPaid = null,Object? paidAt = freezed,Object? bankName = freezed,Object? bankAccountNumber = freezed,}) {
  return _then(RentRecord(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalRent: null == totalRent ? _self.totalRent : totalRent // ignore: cast_nullable_to_non_nullable
as int,totalWifi: null == totalWifi ? _self.totalWifi : totalWifi // ignore: cast_nullable_to_non_nullable
as int,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<MemberPayment>,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,bankAccountNumber: freezed == bankAccountNumber ? _self.bankAccountNumber : bankAccountNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RentRecord].
extension RentRecordPatterns on RentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentRecord value)  $default,){
final _that = this;
switch (_that) {
case _RentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RentRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  int totalRent,  int totalWifi,  List<MemberPayment> payments,  bool isPaid,  DateTime? paidAt,  String? bankName,  String? bankAccountNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentRecord() when $default != null:
return $default(_that.year,_that.month,_that.totalRent,_that.totalWifi,_that.payments,_that.isPaid,_that.paidAt,_that.bankName,_that.bankAccountNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  int totalRent,  int totalWifi,  List<MemberPayment> payments,  bool isPaid,  DateTime? paidAt,  String? bankName,  String? bankAccountNumber)  $default,) {final _that = this;
switch (_that) {
case _RentRecord():
return $default(_that.year,_that.month,_that.totalRent,_that.totalWifi,_that.payments,_that.isPaid,_that.paidAt,_that.bankName,_that.bankAccountNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  int totalRent,  int totalWifi,  List<MemberPayment> payments,  bool isPaid,  DateTime? paidAt,  String? bankName,  String? bankAccountNumber)?  $default,) {final _that = this;
switch (_that) {
case _RentRecord() when $default != null:
return $default(_that.year,_that.month,_that.totalRent,_that.totalWifi,_that.payments,_that.isPaid,_that.paidAt,_that.bankName,_that.bankAccountNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentRecord extends RentRecord {
  const _RentRecord({required this.year, required this.month, required this.totalRent, required this.totalWifi, required  List<MemberPayment> payments, required this.isPaid, this.paidAt, this.bankName, this.bankAccountNumber}): _payments = payments,super._();
  factory _RentRecord.fromJson(Map<String, dynamic> json) => _$RentRecordFromJson(json);

@override final  int year;
@override final  int month;
@override final  int totalRent;
@override final  int totalWifi;
 final  List<MemberPayment> _payments;
@override List<MemberPayment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override final  bool isPaid;
@override final  DateTime? paidAt;
@override final  String? bankName;
@override final  String? bankAccountNumber;

/// Create a copy of RentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentRecordCopyWith<_RentRecord> get copyWith => __$RentRecordCopyWithImpl<_RentRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentRecord&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalRent, totalRent) || other.totalRent == totalRent)&&(identical(other.totalWifi, totalWifi) || other.totalWifi == totalWifi)&&const DeepCollectionEquality().equals(other._payments, _payments)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankAccountNumber, bankAccountNumber) || other.bankAccountNumber == bankAccountNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,totalRent,totalWifi,const DeepCollectionEquality().hash(_payments),isPaid,paidAt,bankName,bankAccountNumber);

@override
String toString() {
  return 'RentRecord(year: $year, month: $month, totalRent: $totalRent, totalWifi: $totalWifi, payments: $payments, isPaid: $isPaid, paidAt: $paidAt, bankName: $bankName, bankAccountNumber: $bankAccountNumber)';
}


}

/// @nodoc
abstract mixin class _$RentRecordCopyWith<$Res> implements $RentRecordCopyWith<$Res> {
  factory _$RentRecordCopyWith(_RentRecord value, $Res Function(_RentRecord) _then) = __$RentRecordCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, int totalRent, int totalWifi, List<MemberPayment> payments, bool isPaid, DateTime? paidAt, String? bankName, String? bankAccountNumber
});




}
/// @nodoc
class __$RentRecordCopyWithImpl<$Res>
    implements _$RentRecordCopyWith<$Res> {
  __$RentRecordCopyWithImpl(this._self, this._then);

  final _RentRecord _self;
  final $Res Function(_RentRecord) _then;

/// Create a copy of RentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? totalRent = null,Object? totalWifi = null,Object? payments = null,Object? isPaid = null,Object? paidAt = freezed,Object? bankName = freezed,Object? bankAccountNumber = freezed,}) {
  return _then(_RentRecord(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalRent: null == totalRent ? _self.totalRent : totalRent // ignore: cast_nullable_to_non_nullable
as int,totalWifi: null == totalWifi ? _self.totalWifi : totalWifi // ignore: cast_nullable_to_non_nullable
as int,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<MemberPayment>,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,bankAccountNumber: freezed == bankAccountNumber ? _self.bankAccountNumber : bankAccountNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MemberPayment {

 String get memberName; bool get isPaid; String? get proofPhoto;
/// Create a copy of MemberPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberPaymentCopyWith<MemberPayment> get copyWith => _$MemberPaymentCopyWithImpl<MemberPayment>(this as MemberPayment, _$identity);

  /// Serializes this MemberPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberPayment&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.proofPhoto, proofPhoto) || other.proofPhoto == proofPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberName,isPaid,proofPhoto);

@override
String toString() {
  return 'MemberPayment(memberName: $memberName, isPaid: $isPaid, proofPhoto: $proofPhoto)';
}


}

/// @nodoc
abstract mixin class $MemberPaymentCopyWith<$Res>  {
  factory $MemberPaymentCopyWith(MemberPayment value, $Res Function(MemberPayment) _then) = _$MemberPaymentCopyWithImpl;
@useResult
$Res call({
 String memberName, bool isPaid, String? proofPhoto
});




}
/// @nodoc
class _$MemberPaymentCopyWithImpl<$Res>
    implements $MemberPaymentCopyWith<$Res> {
  _$MemberPaymentCopyWithImpl(this._self, this._then);

  final MemberPayment _self;
  final $Res Function(MemberPayment) _then;

/// Create a copy of MemberPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberName = null,Object? isPaid = null,Object? proofPhoto = freezed,}) {
  return _then(MemberPayment(
memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,proofPhoto: freezed == proofPhoto ? _self.proofPhoto : proofPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberPayment].
extension MemberPaymentPatterns on MemberPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberPayment value)  $default,){
final _that = this;
switch (_that) {
case _MemberPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberPayment value)?  $default,){
final _that = this;
switch (_that) {
case _MemberPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String memberName,  bool isPaid,  String? proofPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberPayment() when $default != null:
return $default(_that.memberName,_that.isPaid,_that.proofPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String memberName,  bool isPaid,  String? proofPhoto)  $default,) {final _that = this;
switch (_that) {
case _MemberPayment():
return $default(_that.memberName,_that.isPaid,_that.proofPhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String memberName,  bool isPaid,  String? proofPhoto)?  $default,) {final _that = this;
switch (_that) {
case _MemberPayment() when $default != null:
return $default(_that.memberName,_that.isPaid,_that.proofPhoto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberPayment extends MemberPayment {
  const _MemberPayment({required this.memberName, required this.isPaid, this.proofPhoto}): super._();
  factory _MemberPayment.fromJson(Map<String, dynamic> json) => _$MemberPaymentFromJson(json);

@override final  String memberName;
@override final  bool isPaid;
@override final  String? proofPhoto;

/// Create a copy of MemberPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberPaymentCopyWith<_MemberPayment> get copyWith => __$MemberPaymentCopyWithImpl<_MemberPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberPayment&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid)&&(identical(other.proofPhoto, proofPhoto) || other.proofPhoto == proofPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberName,isPaid,proofPhoto);

@override
String toString() {
  return 'MemberPayment(memberName: $memberName, isPaid: $isPaid, proofPhoto: $proofPhoto)';
}


}

/// @nodoc
abstract mixin class _$MemberPaymentCopyWith<$Res> implements $MemberPaymentCopyWith<$Res> {
  factory _$MemberPaymentCopyWith(_MemberPayment value, $Res Function(_MemberPayment) _then) = __$MemberPaymentCopyWithImpl;
@override @useResult
$Res call({
 String memberName, bool isPaid, String? proofPhoto
});




}
/// @nodoc
class __$MemberPaymentCopyWithImpl<$Res>
    implements _$MemberPaymentCopyWith<$Res> {
  __$MemberPaymentCopyWithImpl(this._self, this._then);

  final _MemberPayment _self;
  final $Res Function(_MemberPayment) _then;

/// Create a copy of MemberPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberName = null,Object? isPaid = null,Object? proofPhoto = freezed,}) {
  return _then(_MemberPayment(
memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,proofPhoto: freezed == proofPhoto ? _self.proofPhoto : proofPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
