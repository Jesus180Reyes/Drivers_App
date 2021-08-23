import 'package:drivers_app/AllScreens/newRideScreen.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:drivers_app/Models/rideDetails.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget
{
  final RideDetails rideDetails;
  int distance;

  NotificationDialog({this.rideDetails,this.distance});

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0,),
            Image.asset("images/uberx.png", width: 120.0,),
            SizedBox(height: 18.0,),
            Text("Nueva Solicitud De Viaje", style: TextStyle(fontFamily: "Brand-Bold",fontSize: 18.0,),),
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child:  Container(child: Text(rideDetails.pickup_address, style: TextStyle(fontSize: 18.0),)), 
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded
                        (child: Text(rideDetails.dropoff_address, style: TextStyle(fontSize: 18.0),)
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),


                  SizedBox(height: 15.0,),
                ],
              ),
            ),

            SizedBox(height: 20.0,),
            Divider(height: 2.0,color:  Colors.black, thickness: 2.0,),
            SizedBox(height: 8.0,),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
               color: Colors.white,
              textColor: Colors.red,
              padding: EdgeInsets.all(8.0),
              onPressed: ()
              {
                   assetAudioPlayer.stop();
                  Navigator.pop(context);

              },
                  child: Text(
                "Cancelar".toUpperCase(),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
                  ),

                  SizedBox(width: 25.0,),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)),
                    onPressed: ()
                    {
                      assetAudioPlayer.stop();
                      checkAvailabilityOfRide(context);

                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Aceptar".toUpperCase(),
                      style: TextStyle(fontSize: 14.0)),
                    ),

                ],
              ),
            ),

            SizedBox(height: 10.0,),

          ],
        ),
      ),

    );
  }

  void checkAvailabilityOfRide(context)
  {
    rideRequestRef.once().then((DataSnapshot dataSnapShot){
      Navigator.pop(context);
      String theRideId = "";
      if(dataSnapShot.value != null)
        {
           theRideId =  dataSnapShot.value.toString();
        }
      else
        {
          displayToastMessage("Ride not Exists.", context);
        }



      if(theRideId == rideDetails.ride_request_id)
        {
          rideRequestRef.set("accepted");
          AsisstantMethods.disableHomeTabLiveLocationUpdates();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewRideScreen(rideDetails: rideDetails)));
          displayToastMessage("Dirigete al Lugar De Recogida",  context);
        }
      else if(theRideId == "cancelled")
        {
          displayToastMessage("Ride has been Cancelled.", context);
        }
      else if(theRideId == "timeout")
      {
        displayToastMessage("Ride has time out", context);
      }
      else
      {
        displayToastMessage("Ride not Exists.", context);

      }

    });
  }
}
