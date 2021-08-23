import 'package:drivers_app/Models/history.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/Assistants/requestAssistants.dart';
import 'package:drivers_app/DataHandler/appData.dart';
import 'package:drivers_app/Models/address.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:drivers_app/Models/directDetails.dart';
import 'package:drivers_app/configMaps.dart';

class AsisstantMethods
{
 //static Future <String> searchCoordinateAdress(Position position, context)async
//{
//String placeAddress = "";
//String st1, st2 , st3 , st4;
//String url= "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";

//var response = await RequestAssistant.getRequest(url);

//if(response !="failed"){
  //placeAddress = response["results"][0]["formatted_address"];
  //st1 = response["results"][0]["address_components"][0]["long_name"];
  //st2 = response["results"][0]["address_components"][1]["long_name"];
  //st3 = response["results"][0]["address_components"][5]["long_name"];
  //st4 = response["results"][0]["address_components"][6]["long_name"];
//placeAddress = st1 + ", " + st2 + ", "+ st3 + ", "+ st4;



  //Address userPickUpAddress = new Address();
  //userPickUpAddress.longitude = position.longitude;
  //userPickUpAddress.latitude = position.latitude;
  //userPickUpAddress.placename = placeAddress;

//Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(userPickUpAddress);


//}
//return placeAddress;

//}

static Future<DirectionDetails>  obtainDirectionDetails(LatLng initialPosition,LatLng finalPosition)async
{
String directionurl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

var res = await RequestAssistant.getRequest(directionurl);

if(res == "failed")
  return null;

DirectionDetails directionDetails = DirectionDetails();
directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

directionDetails.distanceText = res ["routes"][0]["legs"][0]["distance"]["text"];
directionDetails.distanceValue = res ["routes"][0]["legs"][0]["distance"]["value"];

directionDetails.durationText = res ["routes"][0]["legs"][0]["duration"]["text"];
directionDetails.durationValue = res ["routes"][0]["legs"][0]["duration"]["value"];

return directionDetails;

}
static int calculateFare(DirectionDetails directionDetails)
{
  //in term dolars
  //USA
  double timeTraveledFare = (directionDetails.durationValue / 60) * 1.50;
  double distanceTraveledFare = (directionDetails.distanceValue  / 1609.34) * 0.50;
  double totalFareAmount=  timeTraveledFare + distanceTraveledFare;



  //double totalFareAmount= distanceTraveledFare;

//HN
  // double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
  //double distanceTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
  //double totalFareAmount=  timeTraveledFare + distanceTraveledFare;


  return totalFareAmount.truncate();


}
//static void getCurrentOnlineUsersInfo()async
//{

  //firebaseUser = await FirebaseAuth.instance.currentUser;
  //String userid  = firebaseUser.uid;
  //DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userid);

//  reference.once().then((DataSnapshot dataSnapShot)
  //{
    //if(dataSnapShot.value != null)
    //{
      //userCurrentInfo = Users.fromSnapShot(dataSnapShot);

    //}
  //});
//}

 static void disableHomeTabLiveLocationUpdates()
 {
   homeTabPageStreamSubscription.pause();
   Geofire.removeLocation(currentFirebaseUser.uid);
}

 static void enabledHomeTabLiveLocationUpdates()
 {
   homeTabPageStreamSubscription.resume();
   Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
 }

 static void retrieveHistoryInfo(context)
 {
   // Update ratings
   //retrieve and display earnings
   driversRef.child(currentFirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapshot)
   {
     if(dataSnapshot.value != null)
       {
         String earnings = dataSnapshot.value.toString();
         Provider.of<AppData>(context, listen: false).updateEarnings(earnings);

         homeTabPageStreamSubscription.pause();
         Geofire.removeLocation(currentFirebaseUser.uid);
         rideRequestRef.onDisconnect();
         rideRequestRef.remove();
         rideRequestRef = null;

       }
   });

   //retrieve and display trip  History
   driversRef.child(currentFirebaseUser.uid).child("history").once().then((DataSnapshot dataSnapshot)
   {
     if(dataSnapshot.value != null)
     {
       //update total numbers trip counts to Provider
       Map<dynamic, dynamic> keys = dataSnapshot.value;
       int tripCounter =   keys.length;
       Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);

       //update trips keys  to Provider
       List<String> tripHistoryKeys = [];
       keys.forEach((key, value) {
         tripHistoryKeys.add(key);
       });
       Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
       obtainTripRequestsHistoryData(context);

       homeTabPageStreamSubscription.pause();
       Geofire.removeLocation(currentFirebaseUser.uid);
       rideRequestRef.onDisconnect();
       rideRequestRef.remove();
       rideRequestRef = null;
     }
   });
 }

 static void obtainTripRequestsHistoryData(context)
 {
  var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

   for(String key in keys)
  {
    newRequestRef.child(key).once().then((DataSnapshot snapshot) {
      if(snapshot.value != null)
      {
        var history = History.fromSnapShot(snapshot);
        Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
      }
    });
  }
 }

 static String formatTripDate(String date)
 {
   DateTime dateTime = DateTime.parse(date);
   String formattedDate ="${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

   return formattedDate;
 }
}
