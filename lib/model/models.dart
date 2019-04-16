import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class Categories {
  List<dynamic> topStories = [];
  List<dynamic> newStories = [];
  List<dynamic> bestStories = [];

  Future<void> fetchTop() async {
    final topStoriesJson = await http.get(
        'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty');
    var topstory = json.decode(topStoriesJson.body);
    topStories = topstory;
  }

  Future<void> fetchNew() async {
    final newStoriesJson = await http.get(
        'https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty');
    var newstory = json.decode(newStoriesJson.body);
    newStories = newstory;
  }

  Future<void> fetchBest() async {
    final bestStoriesJson = await http.get(
        'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty');
    var beststory = json.decode(bestStoriesJson.body);
    bestStories = beststory;
  }
}

class Data {
  List<Item> items = [];
  String stories = 'top';
  int top = 0;
  int news = 0;
  int best = 0;
  Categories ctg;

  Data(Categories category){
    this.ctg = category;
  }

  Future<List> fetchData() async {
    if (stories == 'top') {
      for (var i = top; i < top + 5; i++) {
        if (i >= ctg.topStories.length) {
          print('thats all');
          break;
        }
        final itemJson = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${ctg.topStories[i]}.json?print=pretty');
        Map data = jsonDecode(itemJson.body);
        Item item = Item.fromJson(data);
        items.add(item);
      }
    } else if (stories == 'new') {
      for (var i = news; i < news + 5; i++) {
        if (i >= ctg.newStories.length) {
          break;
        }
        final itemJson = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${ctg.newStories[i]}.json?print=pretty');
        Map data = jsonDecode(itemJson.body);
        Item item = Item.fromJson(data);
        items.add(item);
        //var item1 = Item.fromJson(item);
      }
    } else {
      for (var i = best; i < best + 5; i++) {
        if (i >= ctg.bestStories.length) {
          break;
        }
        final itemJson = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${ctg.bestStories[i]}.json?print=pretty');
        Map data = jsonDecode(itemJson.body);
        Item item = Item.fromJson(data);
        items.add(item);
        //var item1 = Item.fromJson(item);
      }
    }
    return items;
  }
}
