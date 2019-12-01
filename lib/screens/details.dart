
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zenden_app/house/House.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailPage extends StatefulWidget {
  final String img;
  final Data house;
 // final int index;

  DetailPage(this.img,this.house);
  @override
  _DetailPageState createState() => new _DetailPageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  double _appBarHeight = 275.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);

  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 400.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    return Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        platform: Theme.of(context).platform,
      ),

      child: new Container(
        width: width.value,
        height: heigth.value,
        color: Colors.white,
        child: new Hero(
          tag: "img",
          child:
            new Card(
            color: Colors.transparent,
            child: new Container(
              alignment: Alignment.center,
              width: width.value,
              height: heigth.value,

              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new CustomScrollView(
                    shrinkWrap: false,
                    slivers: <Widget>[
                      new SliverAppBar(
                        elevation: 0.0,
                        forceElevated: true,
                        leading: new IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: new Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        flexibleSpace: new FlexibleSpaceBar(
                         // title: new Text("Details"),
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              CarouselSlider(
                               // height: _appBarHeight,
                                aspectRatio: 1 ,
                                viewportFraction: 0.99,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration: Duration(milliseconds: 3000),
                                //autoPlayCurve: Curve.,
                                pauseAutoPlayOnTouch: Duration(seconds: 4),
                                enlargeCenterPage: true,
                                items: widget.house.urls.trim().split(" ").map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(

                                        //width: width.value,
                                       // height: _appBarHeight,
                                        decoration: new BoxDecoration(
                                          image: DecorationImage(
                                              image: new NetworkImage(
                                                  i),
                                              fit:BoxFit.fill
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              )
                              /*new Container(
                                width: width.value,
                                height: _appBarHeight,
                                decoration: new BoxDecoration(
                                  image: DecorationImage(
                                    image: new AssetImage(
                                       widget.img),
                                    fit:BoxFit.fill
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                          new Container(
                            color: Colors.white,
                            child: new Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    padding: new EdgeInsets.only(bottom: 20.0),
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                            bottom: new BorderSide(
                                                color: Colors.black12))),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.access_time,
                                              color: widget.house.city=="Cupertino"?Colors.green:widget.house.city=="Campbell"||widget.house.city=="SanJose"||widget.house.city=="SunnyVale"||widget.house.city=="SantaClara"?Colors.blue:Colors.red

                                  ),
                                            new Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: new Text( widget.house.city=="Cupertino"?"Posted 10 min ago":widget.house.city=="Campbell"||widget.house.city=="SanJose"||widget.house.city=="SunnyVale"||widget.house.city=="SantaClara"?"Posted 1 hour ago":"Posted 1 day ago"),
                                            )
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.location_on,
                                              color: widget.house.city=="Cupertino"?Colors.green:widget.house.city=="Campbell"||widget.house.city=="SanJose"||widget.house.city=="SunnyVale"||widget.house.city=="SantaClara"?Colors.blue:Colors.red
                                            ),
                                            new Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: new Text(widget.house.city=="Cupertino"?"2 Miles Away":widget.house.city=="Campbell"||widget.house.city=="SanJose"||widget.house.city=="SunnyVale"||widget.house.city=="SantaClara"?"6 Miles Away":"30 Miles Away"),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 8.0),
                                    child: new Text(
                                      " DETAILS",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
//                                  new Text(
//                                      "This Single-Family Home is located at 23601 McKean Rd, San Jose, CA. 23601 McKean Rd is in San Jose, CA and in ZIP Code 95141. 23601 McKean Rd has 4 beds, 2 baths, approximately 1,850 square feet and was built in 1920.\n"),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.attach_money,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:0,left:15.0),
                                        child:  new Text(widget.house.numBedrooms.toString()=="1"?":  \$1500":widget.house.numBedrooms.toString()=="2"?":  \$2800":widget.house.numBedrooms.toString()=="3"?":  \$3500":":  \$5000"),
                                      )
                                    ],
                                  ),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        FontAwesomeIcons.bed,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:13,left:15.0),
                                        child:  new Text("\n:  "+ widget.house.numBedrooms.toString() + " Bedrooms"),
                                      )
                                    ],
                                  ),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        FontAwesomeIcons.bath,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:13,left:15.0),
                                        child:  new Text("\n:  " + widget.house.numBathrooms.toString() + " Bathrooms"),
                                      )
                                    ],
                                  ),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        FontAwesomeIcons.square,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:13,left:15.0),
                                        child:   new Text("\n:  "+ widget.house.houseSqft.toString() + " Square Foot"),
                                      )
                                    ],
                                  ),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        FontAwesomeIcons.chartArea,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:13,left:15.0),
                                        child:new Text("\n:  "+ widget.house.lotSqft.toString() + " Lot Square Foot"),
                                      )
                                    ],
                                  ),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        FontAwesomeIcons.city,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:13,left:15.0),
                                        child: new Text("\n:  "+ widget.house.city + ", " + widget.house.state + ", " + widget.house.zipcode.toString()),
                                      )
                                    ],
                                  ),

                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        FontAwesomeIcons.addressCard,
                                        color: themeColor,
                                      ),
                                      new Padding(
                                        padding:
                                        const EdgeInsets.only(bottom:13,left:15.0),
                                        child:new Text("\n:  "+widget.house.address),
                                      )
                                    ],
                                  ),

                                  new Container(
                                    margin: new EdgeInsets.only(top: 30.0),
                                    padding: new EdgeInsets.only(
                                        top: 15.0, bottom: 30.0),
                                   // height: 120.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                            top: new BorderSide(
                                                color: Colors.black12))),
                                    child: new Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          "OWNER",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new CircleAvatar(
                                                backgroundImage: new ExactAssetImage('assets/zenden_logo.png')),
                                            /* new CircleAvatar(
                                              backgroundImage: avatar2,
                                            ),
                                            new CircleAvatar(
                                              backgroundImage: avatar3,
                                            ),
                                            new CircleAvatar(
                                              backgroundImage: avatar4,
                                            ),
                                            new CircleAvatar(
                                              backgroundImage: avatar5,
                                            ),
                                            new CircleAvatar(
                                              backgroundImage: avatar6,
                                            )*/
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children:[
                                      new Container(
                                        child:RaisedButton(
                                          padding: EdgeInsets.only(top:9,bottom:9),
                                          color:Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(20.0),
                                             // side: BorderSide(color: Colors.red)
                                          ),
                                          onPressed: () {
                                            // The Yep button returns "Yep!" as the result.
                                            Navigator.pop(context, false);
                                          },
                                          child: Icon(Icons.cancel,color:Colors.white,size:30),
                                        ),
                                      ),
                                      new Container(
                                        child:RaisedButton(
                                          padding: EdgeInsets.only(top:9,bottom:9),
                                          color:Colors.greenAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(20.0),
                                            // side: BorderSide(color: Colors.red)
                                          ),
                                          onPressed: () {
                                            // The Yep button returns "Yep!" as the result.
                                            Navigator.pop(context, true);
                                          },
                                          child: Icon(FontAwesomeIcons.heart,color:Colors.white,size:30),
                                        ),
                                      ),
                                    ]
                                  )

                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  /*new Container(
                      width: 600.0,
                      height: 80.0,
                      decoration: new BoxDecoration(
                        color: Colors.black12,
                      ),
                      alignment: Alignment.center,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                new BorderRadius.circular(60.0),
                              ),
                              // color:Colors.red,
                              child:FlatButton.icon(
                                icon: Icon(
                                    Icons.cancel,color:Colors.white
                                ), //`Icon` to display
                                label:
                                new Text(
                                  "Dislike",
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  //swipeLeft();
                                },
                              )
                          ),
                          Container(
                            //color:Colors.cyan ,
                              decoration: new BoxDecoration(
                                color: Colors.cyan,
                                borderRadius:
                                new BorderRadius.circular(60.0),
                              ),
                              child:FlatButton.icon(
                                icon: Icon(
                                    Icons.check,color:Colors.white
                                ), //`Icon` to display
                                label:
                                new Text(
                                  "Like",
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  //swipeRight();
                                },
                              )
                          )

                        ],
                      )
                  )*/
                ],
              ),
            ),
         // ),
        ),
        )
      ),
    );
  }
}
