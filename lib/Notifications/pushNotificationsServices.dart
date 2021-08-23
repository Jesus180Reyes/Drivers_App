
import 'dart:ffi';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/Models/rideDetails.dart';
import 'package:drivers_app/Notifications/notificationDialog.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationServices
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future initialize(context)async
  {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message),context);

      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message),context);
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
      },
    );

  }

  Future<String> getToken() async
  {
    String token = await firebaseMessaging.getToken();
    print("this is token ::");
    print(token);
    driversRef.child(currentFirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");

  }

  String getRideRequestId(Map<String, dynamic> message)
  {
    String rideRequestId = "";
    if(Platform.isAndroid)
      {
         rideRequestId =  message['data']['ride_request_id'];

      }
    else
      {
        rideRequestId =  message['ride_request_id'];

      }

    return rideRequestId;
  }

 void retrieveRideRequestInfo(String rideRequestId, BuildContext context)
 {
newRequestRef.child(rideRequestId).once().then((DataSnapshot datasnapshot)
{
  if(datasnapshot.value != null)
    {
      assetAudioPlayer.open(Audio("sounds/alert.mp3"));
      assetAudioPlayer.play();


      double pickUpLocationLat = double.parse(datasnapshot.value['pickup']['latitude'].toString());
      double pickUpLocationLng = double.parse(datasnapshot.value['pickup']['longitude'].toString());
      String pickUpAddress = datasnapshot.value['pickup_address'].toString();

      double dropOffLocationLat = double.parse(datasnapshot.value['dropoff']['latitude'].toString());
      double dropOffLocationLng = double.parse(datasnapshot.value['dropoff']['longitude'].toString());
      String dropOffAddress = datasnapshot.value['dropoff_address'].toString();


      String paymentMethod = datasnapshot.value['payment_method'].toString();

      String rider_name = datasnapshot.value["rider_name"];
      String rider_phone = datasnapshot.value["rider_phone"];




      RideDetails rideDetails = RideDetails();
      rideDetails.ride_request_id = rideRequestId;
      rideDetails.pickup_address = pickUpAddress;
      rideDetails.dropoff_address = dropOffAddress;
      rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
      rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
      rideDetails.payment_method = paymentMethod;
      rideDetails.rider_name = rider_name;
      rideDetails.rider_phone = rider_phone;

      
      print("Information :: ");
      print(rideDetails.pickup_address);
      print(rideDetails.dropoff_address);

      showDialog(
        context: context,
        barrierDismissible:  false,
        builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),


      );


    }
});

 }
}