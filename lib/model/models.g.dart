// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      by: json['by'] as String,
      id: json['id'] as int,
      descendants: json['descendants'] as int,
      kids: (json['kids'] as List)?.map((e) => e as int)?.toList(),
      score: json['score'] as int,
      url: json['url'] as String,
      time: json['time'] as int,
      text: json['text'] as String,
      title: json['title'] as String,
      parts: (json['parts'] as List)?.map((e) => e as int)?.toList(),
      type: json['type'] as String);
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'by': instance.by,
      'id': instance.id,
      'descendants': instance.descendants,
      'kids': instance.kids,
      'score': instance.score,
      'url': instance.url,
      'time': instance.time,
      'text': instance.text,
      'title': instance.title,
      'parts': instance.parts,
      'type': instance.type
    };
