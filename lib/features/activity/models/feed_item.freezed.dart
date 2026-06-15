// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedItem {

 String get id; String get userName; String get userInitial; String get description; DateTime get timestamp; FeedCategory get category;
/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedItemCopyWith<FeedItem> get copyWith => _$FeedItemCopyWithImpl<FeedItem>(this as FeedItem, _$identity);

  /// Serializes this FeedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userInitial, userInitial) || other.userInitial == userInitial)&&(identical(other.description, description) || other.description == description)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userName,userInitial,description,timestamp,category);

@override
String toString() {
  return 'FeedItem(id: $id, userName: $userName, userInitial: $userInitial, description: $description, timestamp: $timestamp, category: $category)';
}


}

/// @nodoc
abstract mixin class $FeedItemCopyWith<$Res>  {
  factory $FeedItemCopyWith(FeedItem value, $Res Function(FeedItem) _then) = _$FeedItemCopyWithImpl;
@useResult
$Res call({
 String id, String userName, String userInitial, String description, DateTime timestamp, FeedCategory category
});




}
/// @nodoc
class _$FeedItemCopyWithImpl<$Res>
    implements $FeedItemCopyWith<$Res> {
  _$FeedItemCopyWithImpl(this._self, this._then);

  final FeedItem _self;
  final $Res Function(FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userName = null,Object? userInitial = null,Object? description = null,Object? timestamp = null,Object? category = null,}) {
  return _then(FeedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userInitial: null == userInitial ? _self.userInitial : userInitial // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeedCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedItem].
extension FeedItemPatterns on FeedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedItem value)  $default,){
final _that = this;
switch (_that) {
case _FeedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedItem value)?  $default,){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userName,  String userInitial,  String description,  DateTime timestamp,  FeedCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.id,_that.userName,_that.userInitial,_that.description,_that.timestamp,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userName,  String userInitial,  String description,  DateTime timestamp,  FeedCategory category)  $default,) {final _that = this;
switch (_that) {
case _FeedItem():
return $default(_that.id,_that.userName,_that.userInitial,_that.description,_that.timestamp,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userName,  String userInitial,  String description,  DateTime timestamp,  FeedCategory category)?  $default,) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.id,_that.userName,_that.userInitial,_that.description,_that.timestamp,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedItem extends FeedItem {
  const _FeedItem({required this.id, required this.userName, required this.userInitial, required this.description, required this.timestamp, required this.category}): super._();
  factory _FeedItem.fromJson(Map<String, dynamic> json) => _$FeedItemFromJson(json);

@override final  String id;
@override final  String userName;
@override final  String userInitial;
@override final  String description;
@override final  DateTime timestamp;
@override final  FeedCategory category;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedItemCopyWith<_FeedItem> get copyWith => __$FeedItemCopyWithImpl<_FeedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userInitial, userInitial) || other.userInitial == userInitial)&&(identical(other.description, description) || other.description == description)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userName,userInitial,description,timestamp,category);

@override
String toString() {
  return 'FeedItem(id: $id, userName: $userName, userInitial: $userInitial, description: $description, timestamp: $timestamp, category: $category)';
}


}

/// @nodoc
abstract mixin class _$FeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory _$FeedItemCopyWith(_FeedItem value, $Res Function(_FeedItem) _then) = __$FeedItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String userName, String userInitial, String description, DateTime timestamp, FeedCategory category
});




}
/// @nodoc
class __$FeedItemCopyWithImpl<$Res>
    implements _$FeedItemCopyWith<$Res> {
  __$FeedItemCopyWithImpl(this._self, this._then);

  final _FeedItem _self;
  final $Res Function(_FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userName = null,Object? userInitial = null,Object? description = null,Object? timestamp = null,Object? category = null,}) {
  return _then(_FeedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userInitial: null == userInitial ? _self.userInitial : userInitial // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeedCategory,
  ));
}


}

// dart format on
