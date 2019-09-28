import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

import 'package:zenden_app/screens/main.dart';


class SubmitProfilePage extends StatefulWidget {
  final String currentUserId;
  final String currentUserEmail;

  SubmitProfilePage({@required this.currentUserId,@required this.currentUserEmail,Key key}) : super(key: key);

  @override
  SubmitProfilePageState createState() => SubmitProfilePageState();
}

class SubmitProfilePageState extends State<SubmitProfilePage> {

  final Color themeColor = Color.fromRGBO(24, 154, 255, 1);
  static const kGoogleApiKey = "AIzaSyDs0Gobkb_PYGXTMrsduyBXLpJAmiFzDVE";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  GeoPoint geoPoint; //cloud firestore primitive type

  GoogleMapController mapController;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();

  String address;


  bool disableButton;
  bool carPoolEnabled;
  bool isSwitched = true;

  double lat;
  double lng;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.currentUserEmail;

  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        //leading: Icon(Icons.notifications,color:Color.fromRGBO(49, 109, 152, 1)),
        title:
        Row(
            children: [
              Text('Submit Profile',
                  style: TextStyle( color: Colors.white,fontWeight: FontWeight.w500,)
              ),

            ]
        ),
      ),*/
      body: WillPopScope(
        onWillPop: () {
          return;
        },
        child:
        Stack(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Image.asset(
                'assets/house.jpg',
                fit: BoxFit.fitHeight,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0.7)),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 20,right:20,top:10),
                child: Center(child:registerForm(context))
            ),

            // Loading
          ],
        ),

      )
    );
  }

  Widget registerForm(BuildContext context) {
    return SingleChildScrollView(
        child:Form(
        key: _formKey,
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10.0),

              TextFormField(
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),
                controller: _emailController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: themeColor,fontSize: 18),
                    hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,),
                    hintText: "example@gmail.com",
                    errorStyle: TextStyle(color: Colors.red),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    )

                ),
                validator: (String value) {
                  if (value.trim().isEmpty || !value.contains("@")||!value.contains(".")) {
                    return 'Invalid Email address';
                  }
                  else return null;
                },
              ),

              const SizedBox(height: 20.0),

              TextFormField(
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),
                controller: _nameController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  labelText: 'Name',
                  labelStyle: TextStyle(color: themeColor,fontSize: 18),
                  hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,),
                  hintText: "First_name  Last_name",
                  errorStyle: TextStyle(color: Colors.red),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ) ,
                ),
                //autovalidate: true,
                validator: (String value) {
                  if (value.trim().isEmpty || value.length<=2) {
                    return 'Invalid Name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20.0),


              TextFormField(
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),
                controller: _phoneController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: themeColor,fontSize: 18),
                  hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,),
                  hintText: "+14081110000",
                  errorStyle: TextStyle(color: Colors.red),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  )

                ),
                autovalidate: true,
              ),

              const SizedBox(height: 20.0),

              TextFormField(
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),
                controller: _ageController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                  labelText: 'Age',
                  labelStyle: TextStyle(color: themeColor,fontSize: 18),
                  hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,),
                  hintText: "21",
                  errorStyle: TextStyle(color: Colors.red),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  )

                ),
                //autovalidate: true,
                validator: (String value) {
                  if (value.trim().isEmpty || value.length<=16||value.contains('-')||value.contains(',')||value.contains('.')) {
                    return 'Invalid Age';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30.0),


              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>
                  [
                    Icon(Icons.location_on,color:Colors.white
                    ),
                    Divider(indent: 15),
                    Expanded(child:Container
                      (
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.white),

                          ),
                        ),
                        child:
                        _addressController.text.length<=1?
                        Container(
                            margin: EdgeInsets.only(bottom: 10.0,left: 1.0),
                            child:Text("  Location",
                                style:TextStyle(
                                    color:themeColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                )
                            )
                        ):
                        Text(_addressController.text,
                            style:TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color:Colors.white
                            )
                        )
                    ),)
                  ],
                ),
                onTap: () {
                  _handlePressButton();
                },
              ),

              const SizedBox(height: 25.0),

              new Container(
                  margin: const EdgeInsets.only(left: 100.0, right:100.0, top: 25.0),
                  child: registerButton()
              ),
            ]
        )
     )
    );
  }



  Widget registerButton(){
    return PimpedButton(
      particle: DemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        return new RaisedButton(
            //color: disableButton?Colors.blueGrey:Color.fromRGBO(49, 109, 152, 1),
            color: themeColor,
            elevation: 3.0,
            splashColor: Colors.cyan,
            highlightColor: Colors.cyan,
            child:
            Text(
              "Submit Profile",
              style:
              TextStyle(
                  color: Colors.white),
            ),
            onPressed:() {
              controller.forward(from: 0.0);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(
                        currentUserId: widget.currentUserId,
                        currentUserEmail: widget.currentUserEmail
                    )
                ),
              );
            }
        );
      },
    );

  }

  Future<void> _handleSubmitButton() async {

    await Firestore.instance
        .collection('app_users')
        .document(widget.currentUserEmail)
        .updateData({'name': widget.currentUserEmail,
          'phone':_phoneController.text,
          'age':_ageController.text,
          'location': _addressController.text,
          'geo_point': GeoPoint(lat, lng)});
  }

  ///----------------- Background Functions ---------------------------

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "en",
    );

    String addressCurr = await displayPrediction(p);
    setState(() {
      address = addressCurr;
      _addressController.text = addressCurr;
    });
  }



  Future<String> displayPrediction(Prediction p) async {
    //GeoPoint gp;
    String address;
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        lat = detail.result.geometry.location.lat;
        lng = detail.result.geometry.location.lng;
        //gp = new GeoPoint(lat, lng);
      });
      address = p.description;
    }
    return address;
  }

}