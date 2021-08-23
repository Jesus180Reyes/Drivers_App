import 'dart:async';

import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:drivers_app/Models/drivers.dart';
import 'package:drivers_app/Notifications/pushNotificationsServices.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget
{
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newgoogleMapController;


  var geoLocator = Geolocator();

  String driverStatusText = " Offline Now - Go Online ";

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();

    getCurrentDriverInfo();
  }

  getRatings()
  {

    driversRef.child(currentFirebaseUser.uid).child("ratings").once().then((DataSnapshot dataSnapshot)
    {

      if(dataSnapshot.value != null)
      {
        double ratings = double.parse(dataSnapshot.value.toString());

        setState(() {
          starCounter = ratings;
        });

        if (starCounter <= 1)
        {
          setState(() {
            title = "Muy Malo";
          });
          return;
        }
      }

      if (starCounter <= 2)
      {
       setState(() {
         title = "Malo";
       });
        return;

      }

      if (starCounter <= 3) {
        setState(() {
          title = "Bueno";
        });
        return;

      }

      if (starCounter <= 4) {
        setState(() {
          title = "Muy Bueno";
        });
        return;

      }

      if (starCounter <= 5) {
        setState(() {
          title = "Exelente";
        });
        return;
      }
      homeTabPageStreamSubscription.pause();
      Geofire.removeLocation(currentFirebaseUser.uid);
      rideRequestRef.onDisconnect();
      rideRequestRef.remove();
      rideRequestRef = null;
    });
  }

  void locatePosition()async
  {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition,zoom: 14);
    newgoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //String address = await AsisstantMethods.searchCoordinateAdress(position,context);
    //print("Esta es Tu Ubicacion:: " + address);


  }

  void getCurrentDriverInfo() async
  {

    currentFirebaseUser = await FirebaseAuth.instance.currentUser;

    driversRef.child(currentFirebaseUser.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null)
        {
          driversInformation = Drivers.fromSnapshot(dataSnapshot);


        }
    });

    PushNotificationServices pushNotificationServices = PushNotificationServices();

    pushNotificationServices.initialize(context);
    pushNotificationServices.getToken();

    AsisstantMethods.retrieveHistoryInfo(context);
    getRatings();

  }

  @override
  Widget build(BuildContext context)
  {
    return Stack(
      children: [

        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller)

          {

            _controllerGoogleMap.complete(controller);
            newgoogleMapController = controller;

            locatePosition();
          },
        ),

        //online offline Driver container
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),


        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 16.0),
                 child: RaisedButton(
                   onPressed: ()
                   {
                     if(isDriverAvailable != true)
                       {
                         makeDriverOnlineNow();
                         getLocationLiveUpdates();

                         setState(() {
                           driverStatusColor = Colors.green;
                           driverStatusText = "Online Now";
                           isDriverAvailable = true;
                         });
                         displayToastMessage("You are Online Now.", context);
                       }
                     else
                       {
                         displayToastMessage("You are Offline Now.", context);
                         setState(() {
                           driverStatusColor = Colors.black;
                           driverStatusText = " Offline Now - Go Online ";
                           isDriverAvailable = false;
                         });
                         makeDriverOfflineNow();
                         _restartapp();


                       }
                   },
                   color: driverStatusColor,
                   child: Padding(
                     padding: EdgeInsets.all(17.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(driverStatusText,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                         Icon(Icons.phone_android,color: Colors.white,size: 26.0,),
                       ],
                     ),
                   ),
                 ),
               ),
             ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    rideRequestRef.set("searching");

    rideRequestRef.onValue.listen((event) {

    });
  }

  void getLocationLiveUpdates()
  {
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if(isDriverAvailable == true)
        {
          Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
        }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newgoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));

    });
  }

  void makeDriverOfflineNow()
  {
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;


  }
  void _restartapp() async
  {
    FlutterRestart.restartApp();
  }
}
