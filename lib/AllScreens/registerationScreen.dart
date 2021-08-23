import 'dart:developer';

import 'package:drivers_app/AllScreens/carInfoScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/AllWidgets/progressDialog.dart';
import 'package:drivers_app/loginScreen.dart';
import 'package:drivers_app/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RegisterationScreen extends StatelessWidget
{
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0 ,
                height: 250.0,
                alignment: Alignment.center,

              ),

              SizedBox(height: 1.0,),
              Text(
                "Registrate Como Conductor:",
                style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        labelStyle: TextStyle(
                          fontSize: 14.0,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,

                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,

                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Numero De Telefono",
                        labelStyle: TextStyle(
                          fontSize: 14.0,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,

                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,

                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),
                    SizedBox(height: 1.0,),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Crear Cuenta",
                            style: TextStyle(fontSize: 20.0,fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),

                      ),
                      onPressed: ()
                      {
                    if(nameTextEditingController.text.length < 3 )
                    {
                    displayToastMessage("El Nombre necesita  tener al menos 3 caracteres", context);
                    }
                    else if(!emailTextEditingController.text.contains("@"))
                    {
                    displayToastMessage("Email no Valido", context);
                    }
                    else if(phoneTextEditingController.text.isEmpty)
                    {
                      displayToastMessage("El Numero de Telefono es obligatorio", context);
                    }
                    else if(passwordTextEditingController.text.length < 6){
                      displayToastMessage("La Contrasena debe tener al menos y caracteres", context);
                    }
                    else
                      {
                      registerNewUser(context);
                      }
                      },
                    ),
                  ],
                ),
              ),

              FlatButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

                },
                child: Text(
                  "¿Ya estas Registrado? Inicia Sesion.",

                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context)async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
       builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registrando, Por Favor Espera...",);
        }


    );
final User firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
    email: emailTextEditingController.text,
    password: passwordTextEditingController.text
).catchError((errMsg){
  Navigator.pop(context);

  displayToastMessage("Error:"+ errMsg.toString(), context);
})).user ;

if(firebaseUser != null) //user creado
{
// guardar usuario a basededatos

Map userDataMap = {
  "name": nameTextEditingController.text.trim(),
  "email": emailTextEditingController.text.trim(),
  "phone": phoneTextEditingController.text.trim(),
  "password": passwordTextEditingController.text.trim(),

};
driversRef.child(firebaseUser.uid).set(userDataMap);

currentFirebaseUser = firebaseUser;

displayToastMessage("Felicitaciones, Tu Cuenta ha sido Creada Exitosamente", context);
Navigator.pushNamed(context, CarInfoScreen.idScreen);
}
else
  {
    Navigator.pop(context);

    //error msg
    displayToastMessage("Usuario no se a podido Registrar", context);
}
  }


}
displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
  }
