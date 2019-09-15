import 'dart:io';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:zenden_app/chat/chat_main_screen.dart';
import 'package:zenden_app/notification/notification_screen.dart';
import 'package:zenden_app/screens/login.dart';





void main() => runApp(MyApp());

/// This Widget is the main application widget.


class MainScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserEmail;

  MainScreen(
      {Key key, @required this.currentUserId, @required this.currentUserEmail})
      : super(key: key);

  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final String currentUserId;
  final String currentUserEmail;

  MainScreenState(
      {Key key, @required this.currentUserId, @required this.currentUserEmail});


  bool check;
  bool empty;

  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    check = false;
    empty = false;


    /* if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((String token) {
      //print("token"+token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        addNotification(message,'notification');

      },
      onResume: (Map<String, dynamic> message) async {
        addNotification(message,'data');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage(currentUserId)),
        );

      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message.toString());
        addNotification(message,'data'); //custom data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage(currentUserId)),
        );
      },
    );*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                   color:themeColor,
                   child:
                    ListTile(
                      title: Text("Menu",style:TextStyle(fontSize: 18,color:Colors.white)),
                   )
                  )
                  : ListTile(
                  leading: Icon(
                    FontAwesomeIcons.home,
                    color: themeColor,
                  ),
                  title: Text("item " + index.toString()),
                  onTap: () {
                    //Navigator.pop(context);
                  },
                );
              }
          )
      ),

      body: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Center(
            child: Container(
                child: Text("Welcome")
            )
        ),
      ),
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

}
