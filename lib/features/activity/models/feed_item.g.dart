// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedItem _$FeedItemFromJson(Map<String, dynamic> json) => _FeedItem(
  id: json['id'] as String,
  userName: json['userName'] as String,
  userInitial: json['userInitial'] as String,
  description: json['description'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  category: $enumDecode(_$FeedCategoryEnumMap, json['category']),
);

Map<String, dynamic> _$FeedItemToJson(_FeedItem instance) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'userInitial': instance.userInitial,
  'description': instance.description,
  'timestamp': instance.timestamp.toIso8601String(),
  'category': _$FeedCategoryEnumMap[instance.category]!,
};

const _$FeedCategoryEnumMap = {
  FeedCategory.chore: 'chore',
  FeedCategory.photo: 'photo',
  FeedCategory.swap: 'swap',
  FeedCategory.fine: 'fine',
};
