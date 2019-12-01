import 'package:cloud_firestore/cloud_firestore.dart';


class Message {

   String title;
   String body;
   String docId;
   String day;
   bool  read;
// String timeStamp;
  Message({
     this.title,
     this.body,
     this.docId,
     this.day,
     this.read,
     //this.timeStamp
  });


  Message.getData(DocumentSnapshot document){
    docId =   document.documentID;
    title =  document['title'];
    body =  document['body'];
    day = document['day'];
    read=  document['read'];

  }
}