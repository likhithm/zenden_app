import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatScreen extends StatefulWidget {
  final String currentUserId;

  ChatScreen(this.currentUserId,{Key key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  bool isSwitched = true;
  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color:themeColor),
        backgroundColor: Colors.white,
        //leading: Icon(Icons.notifications,color:Color.fromRGBO(49, 109, 152, 1)),
        title:
        Row(
            children: [
              Text('Matches',
                  style: TextStyle( color: themeColor,fontWeight: FontWeight.w500)
              ),

              Container(
                margin: EdgeInsets.only(left: 5),
                child:Icon(FontAwesomeIcons.handsHelping,color:themeColor),
              )
            ]
        ),
        actions: <Widget>[
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                /* if(value) {
                 _firebaseMessaging.subscribeToTopic("general");
                  _firebaseMessaging.subscribeToTopic("season");
                 }
                 else{
                  _firebaseMessaging.unsubscribeFromTopic("general");
                  _firebaseMessaging.unsubscribeFromTopic(season);
                 }*/
              });
            },
            activeTrackColor:Colors.lightGreenAccent,
            activeColor: themeColor,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
      body: Center(
          child: Container(
              child: Text("Chat")
          )
      ),

    );
  }
}