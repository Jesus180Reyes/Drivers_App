import 'package:drivers_app/AllScreens/carInfoScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/DataHandler/appData.dart';
import 'package:drivers_app/loginScreen.dart';
import 'package:screen/screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentFirebaseUser =FirebaseAuth.instance.currentUser;


  runApp(MyApp());
  Screen.keepOn(true);
}
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("drivers").child(currentFirebaseUser.uid).child("newRide");

class MyApp extends StatelessWidget
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MaterialApp(
        title: 'Transpote Kariken Driver App',
        theme: ThemeData(
          primarySwatch: Colors.blue,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute:  FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MainScreen.idScreen,
        routes:
        {
          RegisterationScreen.idScreen:(context )=>RegisterationScreen(),
          LoginScreen.idScreen:(context )=>LoginScreen(),
          MainScreen.idScreen:(context )=>MainScreen(),
          CarInfoScreen.idScreen:(context )=> CarInfoScreen(),

        },

        debugShowCheckedModeBanner: false,

      ),
    );
  }

}



