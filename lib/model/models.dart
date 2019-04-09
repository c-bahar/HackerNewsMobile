import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Item {
  String by;
  int id;
  int descendants;
  List<int> kids;
  int score;
  String url;
  int time;
  String text;
  String title;
  List<int> parts;
  String type;

  Item({
    this.by,
    this.id,
    this.descendants,
    this.kids,
    this.score,
    this.url,
    this.time,
    this.text,
    this.title,
    this.parts,
    this.type,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
