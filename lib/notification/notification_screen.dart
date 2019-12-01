import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenden_app/constants/const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zenden_app/notification/message.dart';


class NotificationPage extends StatefulWidget {
  final String currentUserId;

  NotificationPage(this.currentUserId,{Key key}) : super(key: key);

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool loading;
  bool isSwitched;

  List<Message> message =[];

  @override
  void initState() {
    super.initState();
    loading = true;
    isSwitched = true;
    getNotificationList();
  }

  @override
  void dispose() {
    super.dispose();
    message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return  loading?Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(Colors.blue[900]),
        ),
      ),
      color: Colors.white,
    ): Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color:themeColor),
          backgroundColor: Colors.white,
          //leading: Icon(Icons.notifications,color:Color.fromRGBO(49, 109, 152, 1)),
          title:
          Row(
              children: [
                Text('Notifications',
                    style: TextStyle( color: themeColor,fontWeight: FontWeight.w700)
                ),

                Container(
                  margin: EdgeInsets.only(left: 5),
                  child:Icon(Icons.notifications_active,color:themeColor),
                )
              ]
          ),
          actions: <Widget>[
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeTrackColor: Colors.lightBlueAccent,
              activeColor: themeColor,
              inactiveTrackColor: Colors.grey,
            ),
          ],
        ),
        body: isSwitched?viewList(context): Container(
          color:Colors.white,
          child: Center(child:Text("Notifications turned off"))
        )

    );
  }

  Widget viewList(BuildContext context) {
    return ListView.builder(
      //padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index){
        /*return Dismissible(
          key: Key(index.toString()),
            onDismissed: (direction) {
            setState(() {
               message.notificationList.removeAt(index);
            });

            // Then show a snackbar.
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("dismissed")));
            },
            child:  buildItem(context,index)
          );*/
        return buildItem(context,index);
      },
      itemCount:message.length,
    );
  }


  Widget buildItem(BuildContext context,int i) {
    i= message.length-i-1;
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            new Container(
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                color: i==0?Colors.grey[400]:i%2==0?Colors.blueGrey[400]:Colors.deepPurple[200],
                shape: BoxShape.circle,
              ),
              child:
              Center(
                  child:
                  Text(i%2==0?"Z":"D",
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
                        message[i].title,
                        style: TextStyle(
                            color:message[i].read?Colors.grey:Colors.black,
                            fontSize: 16,
                            fontWeight:FontWeight.w900
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child:
                      Text(message[i].body.substring(0, (message[i].body.length/1.5).floor())+"...",
                        style: TextStyle(
                            color:message[i].read?Colors.grey:Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    ),
                    Container(
                      child:
                      Text(message[i].day,
                          style: TextStyle(
                              color:message[i].read?Colors.grey:Colors.black,
                              fontSize: 12,
                              fontStyle: FontStyle.italic
                          )
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text( message[i].title,
                    style:TextStyle(
                        color:themeColor,
                        fontWeight: FontWeight.w900
                    )
                ),
                content:
                new Text(message[i].body,
                    style:
                    TextStyle(
                        color:Colors.black,
                        fontStyle: FontStyle.italic
                    )
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      if(message[i].read)
                        updateRead(i);
                      setState(() {
                        message[i].read=true;
                      });
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
          border: new Border(bottom: new BorderSide(color: Colors.blue, width: 0.5)), color: Colors.white),
    );
  }

  void getNotificationList() async {
    try {
      QuerySnapshot notificationData= await Firestore.instance
         // .collection('app_users')
          //.document(widget.currentUserId)
          .collection("notifications")
          .getDocuments();

      if (notificationData!= null && notificationData.documents.length > 0){
        List<DocumentSnapshot> eDocuments = notificationData.documents;
        setState(() {
          for (DocumentSnapshot snapshot in eDocuments) {
            Message m = Message.getData(snapshot);
            message.add(m);
            //print(snapshot.data.toString());
          }
          loading=false;
        });
      }

      else {
        setState(() {
          loading =false;
        });
      }
    }

    catch(exception){
      print("Exception caught in getNotificationList");
    }
  }

  void updateRead(int i) async {
    try {
      await Firestore.instance
         // .collection('app_users')
          //.document(widget.currentUserId)
          .collection("notifications")
          .document(message[i].docId)
          .updateData(
        {'read':true,},
      );

    }
    catch(exception){
      print("Exception caught in getNotificationList");
    }
  }
}

