import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenden_app/chat/chat.dart';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;

  ChatScreen(this.currentUserId,{Key key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  bool isSwitched = true;
  bool isLoaded = false;
  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);
  final String s1 = "Zack";
  final String s2 = "Pratap";


  List<DocumentSnapshot> documents = List();

  @override
  void initState() {
    super.initState();

    loadData();

  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return isLoaded?Scaffold(
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
            activeTrackColor:Colors.lightBlueAccent,
            activeColor: themeColor,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
      body: viewList(context)
    ):Container(
      color:Colors.white
    );
  }

  Widget viewList(BuildContext context) {
    return ListView.builder(
      //padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) => buildItem(context,index),
      itemCount: documents.length,
    );
  }


  Widget buildItem(BuildContext context,int i) {
     print(documents[i].documentID);
    if (documents[i].documentID == widget.currentUserId) {
       return Container();
    }
    else
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            new Container(
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                color: i%2==0?Colors.cyan:Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child:
              Center(
                  child:
                  Text(documents[i]['name'].toString().substring(0,1),
                      style: TextStyle(
                          color:Colors.white,
                          fontSize: 20
                      )
                  )
              ),
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        documents[i]['name'].toString()
                        //'${document['nickname']}',
                        // style: TextStyle(color: primaryColor),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        i%2==0?"10 miles away":"30 miles away",// gLocation.distanceList[i].toString()+ " miles away",
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          isSwitched?Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                      documents[i].documentID,
                      documents[i]['name'].toString(),
                      widget.currentUserId
                  )
              )
          )
          :
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Car pool disabled"),
                content: new Text("Please enable it to get access!!"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        // color: greyColor2,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      decoration: new BoxDecoration(
          border: new Border(bottom: new BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  loadData() async  {

    final QuerySnapshot result = await Firestore.instance
        .collection('app_users')
        .getDocuments();

    setState(() {
      documents = result.documents;

      isLoaded=true;
    });



  }
}