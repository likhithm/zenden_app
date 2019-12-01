import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zenden_app/constants/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {

  final String currentUserEmail;


  Settings(this.currentUserEmail);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
      title:
      Row(
          children: [
            Text('Profile',
                style: TextStyle( color: themeColor,fontWeight: FontWeight.w700)
            ),

            Container(
              margin: EdgeInsets.only(left: 5),
              child:Icon(Icons.person,color:themeColor),
            )
          ]
      ),
        //centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:Colors.lightBlue),
      ),
      body: new SettingsScreen(currentUserEmail),
    );
  }
}

class SettingsScreen extends StatefulWidget {

  final String currentUserEmail;
  SettingsScreen(this.currentUserEmail);

  @override
  State createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllerNickname;
  TextEditingController controllerAge;
  TextEditingController controllerPhone;


  SharedPreferences prefs;

  String id = '';
  String nickname = 'Likhith';
  String age = '21';
  String phone = '4082154323';

  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = new FocusNode();
  final FocusNode focusNodeAboutMe = new FocusNode();
  final FocusNode focusNodePhone = new FocusNode();

  @override
  void initState() {
    super.initState();
    controllerNickname = new TextEditingController(text: nickname);
    controllerAge = new TextEditingController(text: age);
    controllerPhone = new TextEditingController(text:phone);
    //readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    // id = prefs.getString('id') ?? '';
    nickname =  prefs.getString('nickname') ?? '';
    age = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';

    controllerNickname = new TextEditingController(text: nickname);
    controllerAge = new TextEditingController(text: age);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('profile')
              .document(widget.currentUserEmail)
              .updateData({'name': nickname, 'age': age, 'phone':phone, 'photoUrl': photoUrl}).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection('profile')
        .document(widget.currentUserEmail)
        .updateData({'name': nickname, 'age': age, 'phone': phone,'photoUrl': photoUrl}).then((data) async {
      await prefs.setString('name', nickname);
      await prefs.setString('age', age);
      await prefs.setString('phone', phone);
      await prefs.setString('photoUrl', photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                          ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 90.0,
                            height: 90.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: photoUrl,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 90.0,
                        color: greyColor2,
                      ))
                          : Material(
                        child: Image.file(
                          avatarImageFile,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.cyan),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'username',
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color:Colors.grey),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'Age',
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.cyan),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '21',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),

                        ),
                        controller: controllerAge,
                        onChanged: (value) {
                          age = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  Container(
                    child: Text(
                      'Phone',
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.cyan),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '4081110000',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),

                        ),
                        controller:  controllerPhone,
                        onChanged: (value) {
                          age = value;
                        },
                        focusNode: focusNodePhone,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: RaisedButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  color: themeColor,
                  highlightColor: Colors.lightBlue,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        ),
      ],
    );
  }
}