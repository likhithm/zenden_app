import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:zenden_app/screens/main.dart';
import 'package:zenden_app/screens/sumbit_profile.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Lab',
      home: LoginScreen(title: 'Tech Lab'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;


  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
 // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;
  bool check = false;
  bool checkProfile = false;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController forgotController = new TextEditingController();


  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    await checkForProfile(prefs.getString('id'));


    firebaseAuth.currentUser().then((FirebaseUser user) async  {
      if (user?.uid != null && prefs.get('email') != null) {


     checkProfile?Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                  currentUserId: prefs.getString('id'),
                  currentUserEmail: prefs.getString('email'))),
        ):
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubmitProfilePage(
                  currentUserId: prefs.getString('id'),
                  currentUserEmail: prefs.getString('email'))
          ),
        );
      }
    });


    isLoggedIn = await googleSignIn.isSignedIn();

    if (isLoggedIn) {

      checkProfile?Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                currentUserId: prefs.getString('id'),
                currentUserEmail: prefs.getString('email')
            )
        ),
      ):
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubmitProfilePage(
                currentUserId: prefs.getString('id'),
                currentUserEmail: prefs.getString('email'))
        ),
      );
    }

    //print("email:"+prefs.getString('email'));


    if(!isLoggedIn && prefs.get('email') == null){
    this.setState(() {
      check = true;
      isLoading = false;

    });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return check?
    Scaffold(
            body: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Image.asset(
                  'assets/background.gif',
                  fit: BoxFit.fitHeight,
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.5)),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 100),
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/zenden_logo.png', height: 60,width: 60,
                            ),

                            Container(
                              margin: EdgeInsets.only(top:10),
                              child:
                              Text("Zenden",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Katibeh',
                                  color:Colors.white,
                                  fontSize: 24)
                              )
                            ),

                            Container(
                                margin: EdgeInsets.only(left: 20.0, right: 20.0,top:40),
                                child: registerForm(context)),
                            Container(
                              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              child:
                                  Text("Or", style: TextStyle(color: Colors.white)),
                            ),
                            RaisedButton.icon(
                              onPressed: _submittable() ? handleGoogleSignIn: null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              icon: Icon(FontAwesomeIcons.google,
                                  color: Colors.white),
                              label: Text('Sign in with Google',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                              highlightColor: Colors.redAccent,
                              splashColor: Colors.transparent,
                              textColor: Colors.white,
                            ),
                          ]
                      )
                  )
              ),
              // Loading
              Positioned(
                child: isLoading
                    ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                  ),
                  color: Colors.white,
                )
                    : LimitedBox()
              ),
            ],
          ))
        : Container(
            color: Colors.white,
          );
  }

  Widget registerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5.0),

          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: emailController,
            cursorColor: Colors.white,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              icon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: "example@gmail.com",
              errorStyle: TextStyle(color: Colors.white),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              )
            ),
            //autovalidate: true,
            validator: (String value) {
              if (value.trim().isEmpty || !value.contains("@")) {
                return 'Invalid Email address';
              }
              else return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            style: TextStyle(color: Colors.white),
            obscureText: true,
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              icon: Icon(
                Icons.security,
                color: Colors.white,
              ),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              errorStyle: TextStyle(color: Colors.white),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
              )
            ),
            controller: passwordController,
            validator: (String value) {
              if (value.trim().isEmpty || value.length <= 6) {
                return 'Password must be atleast 7 characters';
              }
              else return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: handleForgotPassword,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _agreedToTOS,
                  onChanged: _setAgreedToTOS,
                ),
                GestureDetector(
                    onTap: () => _setAgreedToTOS(!_agreedToTOS),
                    child: InkWell(
                      child: const Text(
                        'I agree to the terms of services and privacy policy',
                        style: TextStyle(
                            color: Colors.white,
                            decorationColor: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                      //onTap: redirect  ,
                    )),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RaisedButton.icon(
              onPressed: _submittable() ? _submit : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              icon: Icon(FontAwesomeIcons.signInAlt, color: Colors.white),
              label: Text('Sign In via Email',
                  style: TextStyle(color: Colors.white)),
              color: themeColor,
              highlightColor: Colors.cyan,
              splashColor: Colors.transparent,
              textColor: Colors.white,
            ),
            Divider(indent: 10),
            RaisedButton.icon(
              onPressed: _submittable() ? _submitSignUp : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              icon: Icon(Icons.person_add, color: Colors.white),
              label: Text('Sign Up via Email ',
                  style: TextStyle(color: Colors.white)),
              color: themeColor,
              highlightColor: Colors.cyan,
              splashColor: Colors.transparent,
              textColor: Colors.white,
            ),
          ])
        ],
      ),
    );
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
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
  }

  /// Functions

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.validate();
    signInWithEmail();
  }

  void _submitSignUp() {
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.validate();
    signUpWithEmail();
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  /// Google Sign In
  Future<Null> handleGoogleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser =
        await firebaseAuth.signInWithCredential(credential);

    if (firebaseUser != null) {
      // Check if already signed up
      final QuerySnapshot result = await Firestore.instance
          .collection('app_users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
          .collection('app_users')
          .document(firebaseUser.uid)
          .setData({'emailId': firebaseUser.email, 'profileSubmitted':false});

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('email', currentUser.email);
      }
      else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('email', firebaseUser.email);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });
      /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentUserId: firebaseUser.uid,
                  currentUserEmail: firebaseUser.email,
                )),
      );*/
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubmitProfilePage(
                currentUserId: prefs.getString('id'),
                currentUserEmail: prefs.getString('email'))
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  void signUpWithEmail() async {
    // marked async
    FirebaseUser user;
    try {
      user = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        await user.sendEmailVerification();
        setState(() {
          isLoading = false;
        });
        _showDialog("Verify your account",
            "Thanks for signing up.\nCheck your inbox and confirm your email address to activate your account");
        // sign up successful!
      } else {
        _showDialog("Error Signing Up",
            "Please check your internet connection or credentials ");
        setState(() {
          isLoading = false;
        });
        //fail
      }
    }
  }

  void signInWithEmail() async {
    // marked async
    FirebaseUser firebaseUser;
    try {
      firebaseUser = await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      print(e.toString());
    } finally {
      if (firebaseUser != null && firebaseUser.isEmailVerified) {
        // Check if already signed up
        final QuerySnapshot result = await Firestore.instance
            .collection('app_users')
            .where('id', isEqualTo: firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        if (documents.length == 0) {
          // Update data to server if new user
          Firestore.instance
              .collection('app_users')
              .document(firebaseUser.uid)
              .setData({'emailId': emailController.text,'profileSubmitted':false});

          await prefs.setString('id', firebaseUser.uid);
          await prefs.setString('email', emailController.text);
        } else {
          // Write data to local
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('email', emailController.text);
          //print(documents[0].data['emailId']);
        }
       // _firebaseMessaging.subscribeToTopic("general");
        Fluttertoast.showToast(msg: "Sign in success");
       /* Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                  currentUserId: firebaseUser.uid,
                  currentUserEmail: prefs.getString('email'))),
        );*/
        Navigator.push(
            context,MaterialPageRoute(
            builder: (context) => SubmitProfilePage(
                currentUserId: prefs.getString('id'),
                currentUserEmail: prefs.getString('email'))
            )
        );
      } else {
        if (firebaseUser == null)
          Fluttertoast.showToast(msg: "Sign in failed!! Please SignUp");
        else
          Fluttertoast.showToast(
              msg: "Sign in failed!! Please verify your account");

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void handleForgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Reset password"),
          content: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: forgotController,
            cursorColor: Colors.blue,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.grey),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: "Enter your email to reset password",
            ),
            //autovalidate: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Send Reset Link"),
              onPressed: () async {
                await firebaseAuth.sendPasswordResetEmail(
                    email: forgotController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkForProfile(String id) async {
    if(id!=null){
      try {
        await
        Firestore.instance
            .collection('app_users')
            .document(id)
            .get()
            .then((DocumentSnapshot ds) {
          if(ds['profileSubmitted']) {
             setState(() {
               checkProfile = true;
             });
          }
        });
      }
      catch(e){
        print("Exception caught in checkForCarPoolEnroll");
      }
    }

    return false;
  }
}
