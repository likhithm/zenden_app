import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'dart:convert' show utf8;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:zenden_app/chat/chat_main_screen.dart';
import 'package:zenden_app/notification/notification_screen.dart';
import 'package:zenden_app/screens/login.dart';
import 'package:zenden_app/house/House.dart';
import 'package:zenden_app/screens/details.dart';
import 'package:zenden_app/screens/profile.dart';






void main() => runApp(MyApp());



class MainScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserEmail;

  MainScreen(
      {Key key, @required this.currentUserId, @required this.currentUserEmail})
      : super(key: key);

  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin  {
  final String currentUserId;
  final String currentUserEmail;

  MainScreenState(
      {Key key, @required this.currentUserId, @required this.currentUserEmail});


  List<Data> houses = List();
  bool check;
  bool empty;
  bool hasLoaded = false;

  //Queue<String> welcomeImages = new Queue<String>();

  List<String> welcomeImages= List();
  int length;
  int again;

  int i=0;

  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  /*List<String> welcomeImages = [
    "assets/house.jpg",
    "assets/background.gif",
    "assets/h1.jpg",
    "assets/h2.jpg",
    "assets/house.jpg",
    "assets/background.gif"
  ];*/


  @override
  void initState() {
    super.initState();
   // prefs = await SharedPreferences.getInstance();
    check = false;
    empty = false;

    http
        .get(
        'https://zenden-api-heroku.herokuapp.com/api/Predictions?user_id=2')
        .then((res) => (res.body))
        .then(json.decode)
        .then((map) => map["data"])
        .then((data) => data.forEach(addHouse))
        .catchError(onError)
        .then((e) {
      setState(() {
        for(int i=0;i<houses.length;i++){
          welcomeImages.add(houses[i].urls.split(" ")[0]);

        }
        length = houses.length;
        again = length - 5;
        hasLoaded = true;
      });

    });


     if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((String token) {
      //print("token"+token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //addNotification(message,'notification');


      },
      onResume: (Map<String, dynamic> message) async {
        //addNotification(message,'data');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage(currentUserId)),
        );

      },
      onLaunch: (Map<String, dynamic> message) async {
        //addNotification(message,'data'); //custom data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage(currentUserId)),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    houses.clear();
  }

  void addHouse(item) {
    setState(() {
      houses.add(Data.fromJson(item));
    });


  }

  void onError(dynamic d) {
    print(d);
    setState(() {
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
      automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
       // leading: Icon(FontAwesomeIcons.home,
         //   color: themeColor),
        title: Row(children: [
           IconButton(
              icon: new Icon(Icons.menu, color: themeColor),
              onPressed: () => _scaffoldKey.currentState.openDrawer()
            ),
          Divider(indent: 7.0),
          Text('Zen',
              style:
              TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w700)),
          Text('Den',
              style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.w700)
          ),
        ]),
        actions: <Widget>[

          InkWell(
            child:
            Stack(
                children:
                <Widget>[
                  Center(
                      child:
                      Icon(Icons.notifications,
                          color: themeColor
                      )
                  ),
                  _buildNotificationBadge()
                ]
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage(widget.currentUserId)),
              );
            },

          ),

          SizedBox(width:20),

          InkWell(
            child:
            Icon(Icons.message,
                color:themeColor
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(widget.currentUserId)),
              );
            },
          ),

          SizedBox(width:10),


        ],

        // leading: Icon(Icons.menu),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
          child: new ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return index == 0
                ? Container(
                   color:Color.fromRGBO(24, 160, 255, 1),
                   child:
                    ListTile(
                      title: Text(widget.currentUserEmail,style:TextStyle(fontSize: 16,color:Colors.white)),
                   )
                  )
                  : ListTile(
                  leading: Icon(
                    index==1?Icons.person:FontAwesomeIcons.home,
                    color: themeColor,
                  ),
                  title: Text(index==1?"Profile":"Post",style:TextStyle(fontWeight: FontWeight.w600)),
                  onTap: (){
                     // if(index==1) {
                       // print("hi");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Settings(widget.currentUserEmail)
                          ),
                        );
                      //}
                    }
                );
              }
          )
      ),

      body: hasLoaded?WillPopScope(
        onWillPop: () {
          exit(0);
          return;
        },
            child: Container(
               // height: MediaQuery.of(context).size.height * 0.6,
                child: new TinderSwapCard(
                    orientation: AmassOrientation.TOP,
                    totalNum: 100,
                    stackNum: 2,
                    swipeEdge: 1.0,
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height,
                    minWidth: MediaQuery.of(context).size.width*0.95,
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                    cardBuilder: (context, imgIndex) => Card(

                      child: GestureDetector(
                       // child:Image.network('${welcomeImages[imgIndex]}',fit:BoxFit.fitHeight),
                        child:Image.network('${welcomeImages.elementAt(imgIndex)}',fit:BoxFit.fitHeight),
                        onTap: () async {
                          bool result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => DetailPage(welcomeImages[imgIndex],houses[imgIndex])
                                builder: (context) => DetailPage(welcomeImages.elementAt(imgIndex),houses[imgIndex])
                            ),
                          );
                          if(result){
                            controller.triggerRight();
                          }
                          else{
                            controller.triggerLeft();
                          }
                        },
                      ),
                    ),
                    cardController: controller = CardController(),
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {

                      /// Get swiping card's alignment
                      if (align.x < 0) {
                        //Card is LEFT swiping
                      } else if (align.x > 0) {
                        //Card is RIGHT swiping
                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                        if(index==again){
                          http
                              .get(
                              'https://zenden-api-heroku.herokuapp.com/api/Predictions?user_id=1')
                              .then((res) => (res.body))
                              .then(json.decode)
                              .then((map) => map["data"])
                              .then((data) => data.forEach(addHouse))
                              .catchError(onError)
                              .then((e) {
                            setState(() {
                              for(int i=length;i<houses.length;i++){
                                welcomeImages.add(houses[i].urls.split(" ")[0]);
                                //print(welcomeImages[i]);
                              }
                              //hasLoaded = true;
                            });
                            length = houses.length;
                            again = length-5;



                          });


                      /// Get orientation & index of swiped card!
                    }
                   }
                )

            ),
      ):
        Container(
          child:
            Center(child:CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),)
          ),
        )
    );
  }


  Widget _buildNotificationBadge() {
    return Positioned( // draw a red marble
      top: 13.0,
      right: 3.0,
      child: Stack(
        children: <Widget>[
          Icon(
              Icons.brightness_1,
              size: 11,
              color: Colors.red.shade600.withOpacity(1)
          ),
          //  _buildNotificationCount()
        ],
      ),
    );
  }

  Widget _buildNotificationCount() {
    return Positioned(
      top: 2,
      right: 4.0,
      child: Text(
          "2",
          //counter.toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w500
          )
      ),
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  Future<Null> addNotification(Map<String, dynamic> message, String notificationOrData) async {
    print (message);
    try {
      final notification = message[notificationOrData];
      await Firestore.instance
          //.collection('app_users')
          //.document(currentUserId)
          .collection('notifications')
          .add(
        {'body':notification['body'].toString(),'read':false,'title':notification['title'].toString(),'day':'Today'},
      );
    } catch (exception) {
      print("exception caught in add notification");
    }
  }


}
