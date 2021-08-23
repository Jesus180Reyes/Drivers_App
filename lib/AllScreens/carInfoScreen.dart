import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CarInfoScreen extends StatelessWidget
{
  static const String idScreen = "carinfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();
  TextEditingController yearVehicleTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("images/logo.png",width: 390.0,height: 250.0,),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Ingrese Detalles De Vehiculo",style: TextStyle(fontFamily: "Brand-Bold",fontSize: 24.0),),

                    SizedBox(height: 26.0,),
                    TextField(
                      controller: carModelTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Modelo del Vehiculo",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),

                    ),

                    SizedBox(height: 10.0,),


                    SizedBox(height: 26.0,),
                    TextField(
                      controller: carNumberTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Placa de Vehiculo",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),

                    ),

                    SizedBox(height: 12.0,),


                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carColorTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Color del Vehiculo",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),

                    ),

                    TextField(
                      controller: yearVehicleTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Año del Vehiculo",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize: 15.0),

                    ),
                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: ()
                        {
                          if(carModelTextEditingController.text.isEmpty)
                            {
                              displayToastMessage(" Porfavor ingresa Modelo del Vehiculo", context);

                            }

                         else if(carNumberTextEditingController.text.isEmpty)
                          {
                            displayToastMessage(" Porfavor ingresa Placa del Vehiculo", context);

                          }

                          else if(yearVehicleTextEditingController.text.length >4)
                          {
                            displayToastMessage("Porfavor Ingrse El Ano Correcto", context);

                          }
                          else if(yearVehicleTextEditingController.text.length < 4)
                            {
                              displayToastMessage("Porfavor Ingrese el Ano Correcto", context);
                            }
                          else if(carColorTextEditingController.text.isEmpty)
                          {
                            displayToastMessage(" Porfavor ingresa Color del Vehiculo", context);
                          }
                          else if(yearVehicleTextEditingController.text.isEmpty )
                          {
                            displayToastMessage(" Porfavor Ingrese Correctamente el Ano del Vehiculo", context);

                          }


                          else if(yearVehicleTextEditingController.text.contains("2008"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }

                          else if(yearVehicleTextEditingController.text.contains("2007"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("2006"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }
                          else if(yearVehicleTextEditingController.text.contains("2005"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }
                          else if(yearVehicleTextEditingController.text.contains("2004"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("2003"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("2002"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("2001"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("2000"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }
                          else if(yearVehicleTextEditingController.text.contains("1999"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1998"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1997"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1996"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1995"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1994"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1993"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);

                          }
                          else if(yearVehicleTextEditingController.text.contains("1992"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }
                          else if(yearVehicleTextEditingController.text.contains("1991"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }
                          else if(yearVehicleTextEditingController.text.contains("1990"))
                          {
                            displayToastMessage("El Ano Del Vehiculo debe ser Mayor a 2009", context);
                          }
                          else
                            {
                              saveDriverCarInfo(context);
                            }

                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Siguiente",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                              Icon(Icons.arrow_forward,color: Colors.white,size: 26.0,),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  void saveDriverCarInfo(context)
  {
   String userid = currentFirebaseUser.uid;

   Map carInfoMap =
       {
   "car_color": carColorTextEditingController.text,
   "car_number": carNumberTextEditingController.text,
   "car_model": carModelTextEditingController.text,
   "car_year": yearVehicleTextEditingController.text,
  };
   driversRef.child(userid).child("car_details").set(carInfoMap);

   Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

}
}
