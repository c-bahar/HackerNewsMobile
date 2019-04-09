import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/models.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String stories = 'top';
  List<Item> items = [];
  bool isReady = false;
  bool loadMore = false;
  int top = 0;
  int news = 0;
  int best = 0;
  List<dynamic> topStories = [];
  List<dynamic> newStories = [];
  List<dynamic> bestStories = [];

  Future<List> fetchData() async {
    if (stories == 'top') {
      for (var i = top; i < top + 5; i++) {
        if(i+1 == topStories.length){
          break;
        }
        final itemJson = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${topStories[i]}.json?print=pretty');
        Map data = jsonDecode(itemJson.body);
        Item item = Item.fromJson(data);
        items.add(item);
      }
    } else if (stories == 'new') {
      for (var i = news; i < news + 5; i++) {
        if(i+1 == newStories.length){
          break;
        }
        final itemJson = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${newStories[i]}.json?print=pretty');
        Map data = jsonDecode(itemJson.body);
        Item item = Item.fromJson(data);
        items.add(item);
        //var item1 = Item.fromJson(item);
      }
    } else {
      for (var i = best; i < best + 5; i++) {
        if(i+1 == bestStories.length){
          break;
        }
        final itemJson = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${bestStories[i]}.json?print=pretty');
        Map data = jsonDecode(itemJson.body);
        Item item = Item.fromJson(data);
        items.add(item);
        //var item1 = Item.fromJson(item);
      }
    }
    return items;
  }

  Future<List> fetchOtherCategories() async {
    final newStoriesJson = await http.get(
        'https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty');
    var newstory = json.decode(newStoriesJson.body);
    newStories = newstory;
    final bestStoriesJson = await http.get(
        'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty');
    var beststory = json.decode(bestStoriesJson.body);
    bestStories = beststory;
  }

  Future<void> fetchTop() async {
    final topStoriesJson = await http.get(
        'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty');
    var topstory = json.decode(topStoriesJson.body);
    topStories = topstory;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTop().then((_) {
      fetchData().then((_) {
        setState(() {
          isReady = true;
        });
      });
      fetchOtherCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Column(
            children: <Widget>[
              Text('Hacker News'),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (stories != 'top') {
                              if (isReady) {
                                items = [];
                                news = 0;
                                best = 0;
                                setState(() {
                                  isReady = false;
                                  stories = 'top';
                                });
                                fetchData().then((_) {
                                  setState(() {
                                    isReady = true;
                                  });
                                });
                              }
                            }
                          },
                          child: Text(
                            'Top Stories',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (stories != 'new') {
                              if (isReady) {
                                top = 0;
                                best = 0;
                                items = [];
                                setState(() {
                                  stories = 'new';
                                  isReady = false;
                                });
                                fetchData().then((_) {
                                  setState(() {
                                    isReady = true;
                                  });
                                });
                              }
                            }
                          },
                          child: Text(
                            'New Stories',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (stories != 'best') {
                              if (isReady) {
                                top = 0;
                                news = 0;
                                items = [];
                                setState(() {
                                  stories = 'best';
                                  isReady = false;
                                });
                                fetchData().then((_) {
                                  setState(() {
                                    isReady = true;
                                  });
                                });
                              }
                            }
                          },
                          child: Text(
                            'Best Stories',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(255, 102, 0, 1),
        ),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          isReady
              ? Expanded(
                  child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              launch(items[index].url);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 246, 239, 1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.blueGrey,
                                  )),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      items[index].title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text('${items[index].score}'),
                                        Icon(
                                          Icons.star,
                                          semanticLabel: 'ghjk',
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: items.length,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            loadMore = true;
                          });
                          print('clicked');
                          if (stories == 'top') {
                            top = top + 5;
                            fetchData().then((_) {
                              setState(() {
                                loadMore = false;
                              });
                            });
                          } else if (stories == 'new') {
                            news = news + 5;
                            fetchData().then((_) {
                              setState(() {
                                loadMore = false;
                              });
                            });
                          } else {
                            best = best + 5;
                            fetchData().then((_) {
                              setState(() {
                                loadMore = false;
                              });
                            });
                          }
                        },
                        child: Container(
                          child: loadMore
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                  width: MediaQuery.of(context).size.height *
                                      0.025,
                                  child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation(
                                        Color.fromRGBO(255, 102, 0, 1)),
                                  ),
                                )
                              : Text(
                                  'More...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18,
                                  ),
                                ),
                        ))
                  ],
                ))
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(
                        Color.fromRGBO(255, 102, 0, 1)),
                  ),
                )
        ],
      )),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
