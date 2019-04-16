import 'package:flutter/material.dart';
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
  static Categories ctg = new Categories();
  Data data = new Data(ctg);
  
  bool menuOpen = false;
  bool isReady = false;
  bool loadMore = false;
  double width1 = 10;
  double _opacity = 0;
  Color menuColor = Color.fromRGBO(255, 150, 0, 1);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctg.fetchTop().then((_) {
      data.fetchData().then((_) {
        setState(() {
          isReady = true;
        });
      });
      ctg.fetchBest();
      ctg.fetchNew();
    });
  }

  void topMenu(String str) {
    if (isReady) {
      data.items = [];
      setState(() {
        isReady = false;
        data.stories = str;
      });
      data.fetchData().then((_) {
        setState(() {
          isReady = true;
        });
      });
    }
  }
  
  Widget menu() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (data.stories != 'top') {
                      if (isReady) {
                        data.news = 0;
                        data.best = 0;
                        topMenu('top');
                      }
                    }
                  },
                  child: Text(
                    'Top Stories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (data.stories != 'new') {
                      if (isReady) {
                        data.top = 0;
                        data.best = 0;
                        topMenu('new');
                      }
                    }
                  },
                  child: Text(
                    'New Stories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (data.stories != 'best') {
                      if (isReady) {
                        data.top = 0;
                        data.news = 0;
                        topMenu('best');
                      }
                    }
                  },
                  child: Text(
                    'Best Stories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text('Hacker News'),
          backgroundColor: Color.fromRGBO(255, 102, 0, 1),
        ),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            GestureDetector(
              child: AnimatedContainer(
                foregroundDecoration: BoxDecoration(
                  border: Border(right: BorderSide(
                    color: Colors.black
                  ))
                ),
                duration: Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                height: MediaQuery.of(context).size.height,
                width: width1,
                decoration:
                    BoxDecoration(color: menuColor),
                child: AnimatedOpacity(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 2000),
                  opacity: _opacity,
                  child: menuOpen ? menu() : null,
                ),
              ), //menuOpen ? menu() : null,
              onTap: () {
                setState(() {
                  width1 = width1 == 10
                      ? MediaQuery.of(context).size.width * 0.35
                      : 10;
                  menuOpen = !menuOpen;
                  _opacity = _opacity == 1 ? 0 : 1;
                  menuColor = menuOpen ? Color.fromRGBO(246, 246, 239, 1) : Color.fromRGBO(255, 150, 0, 1);
                });
              },
            ),
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
                                launch(data.items[index].url);
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
                                        data.items[index].title,
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
                                          Text('${data.items[index].score}'),
                                          Icon(
                                            Icons.star,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.items.length,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loadMore = true;
                          });
                          print('clicked');
                          if (data.stories == 'top') {
                            data.top = data.top + 5;
                            data.fetchData().then((_) {
                              setState(() {
                                loadMore = false;
                              });
                            });
                          } else if (data.stories == 'new') {
                           data.news = data.news + 5;
                            data.fetchData().then((_) {
                              setState(() {
                                loadMore = false;
                              });
                            });
                          } else {
                            data.best = data.best + 5;
                            data.fetchData().then((_) {
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
                        ),
                      ),
                    ],
                  ))
                : Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation(
                            Color.fromRGBO(255, 102, 0, 1)),
                      ),
                    ),
                  )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
