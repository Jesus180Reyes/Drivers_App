import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/AllWidgets/progressDialog.dart';

import 'AllScreens/mainscreen.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget
{
  static const String idScreen = "login";

  TextEditingController emailTextEditingController = TextEditingController();
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
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0 ,
                height: 250.0,
                alignment: Alignment.center,

              ),

              SizedBox(height: 1.0,),
              Text(
                "Inicia Sesion Como Conductor:",
                style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

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
                            "Login",
                            style: TextStyle(fontSize: 20.0,fontFamily: "Brand Bold"),

                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),

                      ),
                      onPressed: ()
                        {
                          if(!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Email no Valido", context);
                          }
                          else if(passwordTextEditingController.text.isEmpty){
                            displayToastMessage("Error, Escribe Tu Contrasena Para Iniciar Sesion", context);
                          }
                          else
                            {
                              loginAndAuthenticateUser(context);

                            }
                       },
                    ),
                  ],
                ),
              ),

FlatButton(
  onPressed: (){
   Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);


  },
  child: Text(
    "¿Todavia no estas Registrado? Registrate Aqui.",

  ),
),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

 void loginAndAuthenticateUser(BuildContext context)async
  {
    showDialog(
        context: context,
    barrierDismissible: false,
       builder: (BuildContext context)
       {
       return ProgressDialog(message: "Autenticando, Por Favor Espera...",);

       }


    );

    final User firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
Navigator.pop(context);

      displayToastMessage("Error:"+ errMsg.toString(), context);
    })).user ;

    if(firebaseUser != null) //user creado
        {
// guardar usuario a basededatos
      driversRef.child(firebaseUser.uid).once().then((DataSnapshot snap){

        if(snap.value != null)
          {
            currentFirebaseUser = firebaseUser;
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
            displayToastMessage("Inicio De Sesion Exitosamente", context);

          }
        else
          {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("No se pudo Iniciar Sesion, PorFavor Crea Una Cuenta", context);

          }
      });


    }
    else
    {
      Navigator.pop(context);

      displayToastMessage("No Se pudo Iniciar Sesion", context);
    }
  }
}
