import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/Assistants/assistantMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_restart/flutter_restart.dart';

import '../configMaps.dart';
import '../main.dart';

class CollectFareDialog extends StatelessWidget {

  final String paymentMethod;
  final int fareAmount;

  CollectFareDialog({this.paymentMethod, this.fareAmount});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),

      backgroundColor: Colors.transparent,
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
            SizedBox(height: 22.0,),
            Text("Tarifa de Viaje"),

            SizedBox(height: 22.0,),

            Divider(),

            SizedBox(height: 16.0,),

            Text("\$$fareAmount",
              style: TextStyle(fontSize: 55.0, fontFamily: "Brand-Bold"),),

            SizedBox(height: 16.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Este es el Total del Viaje, Cliente ya se le Cobro el Monto",
                textAlign: TextAlign.center,),
            ),

            SizedBox(height: 30.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                onPressed: () async
                {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  displayToastMessage("Viaje Finalizado Exitosamente", context);
                  AsisstantMethods.enabledHomeTabLiveLocationUpdates();
                },
                color: Colors.deepPurpleAccent,
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recoger Efectivo", style: TextStyle(fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),),
                      Icon(
                        Icons.attach_money, color: Colors.white, size: 26.0,),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0,),

          ],
        ),
      ),
    );
  }

  void _restartApp() async {
    FlutterRestart.restartApp();
  }


  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;
  }
}