import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:zenden_app/constants/const.dart';

class Chat extends StatefulWidget {
  final String peerId;
  final String peerName;
  final String id;

  Chat(this.peerId,  this.peerName, this.id);

  @override
  State createState() => new ChatScreenState(peerId,peerName,id);
}

class ChatScreenState extends State<Chat> {
  ChatScreenState(this.peerId, this.peerName,this.id);

  String peerId;
  String peerName;
  String id;

  var listMessage;
  String groupChatId;


  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();


  @override
  void initState() {
    super.initState();
   // focusNode.addListener(onFocusChange);
    groupChatId = '';
    readLocal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title:
        Row(
            children:[
              showIcon(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    new Text(
                      peerName,
                      style: TextStyle(color: themeColor),
                    ),
                  ]
              )
            ]
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:themeColor),
        actions: <Widget>[
        ],
      ),
      body:  Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildListMessage(),
              buildInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget showIcon(){
    return Container(
      margin: EdgeInsets.only(right:10),
      width: 25.0,
      height:25.0,
      decoration: new BoxDecoration(
        color: themeColor,
        shape: BoxShape.circle,
      ),
      child:
      Center(
          child:
          Text(peerName.substring(0,1),
              style: TextStyle(
                  color:Colors.white,
                  fontSize: 15
              )
          )
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child:Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left:20,top:0),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
               // focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send,color:themeColor),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 70.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  void onSendMessage(String content, int type) async {

    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      await Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData(
        {
          'idFrom': id,
          'idTo': peerId,
          'timestamp': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          'content': content,
          'type': type
        },
      );


     /*var documentReference =  Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

       Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'idFrom': id,
              'idTo': peerId,
              'timestamp': DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              'content': content,
              'type': type
            },
          );
        });*/

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }

    else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }



  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(20.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
          : LimitedBox()
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document['type'] == 0
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color:greyColor2, borderRadius: BorderRadius.circular(20.0),
                      border:Border.all(color:Colors.grey) ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                : LimitedBox()
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  readLocal() async {
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    setState(() {});
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }
}