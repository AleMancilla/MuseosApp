import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/BienvenidaPage.dart';
import 'package:museosapp/Pages/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SharedPreferences myPrefs;

  @override
  void initState() {
    cargando();
    super.initState();
  }

  cargando()async{
    myPrefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: 'assets/images/descarga.png',
      duration: 2000,
      screenFunction: _comprobandoPage,
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.scale,
    );
  }

  Future<Widget> _comprobandoPage()async{
    bool state = await comprovandoPago();
    print("""
    
    ${myPrefs.getString("email")}
    ${myPrefs.getString("pass")}
    
    """);
    if(state){
      if(myPrefs.getString("email")!=null && myPrefs.getString("pass")!=null){
        List usuario = await iniciandoSesion(email: myPrefs.getString("email"), pass: myPrefs.getString("pass"));
        if(usuario.length==0)
          {
            Flushbar(
                      title:  "Fallo inicio de sesion",
                      message:  "El usuario no fue encontrado, por favor vuelva a intentarlo.",
                      backgroundColor: Colors.red,
                      duration:  Duration(seconds: 3),              
                    )..show(context);
                    return BienvenidaPage();
          }else{
            Flushbar(
                      title:  "Sesion iniciada",
                      message:  "El usuario se logueo exitosamente.",
                      backgroundColor: Colors.green,
                      duration:  Duration(seconds: 3),              
                    )..show(context);
                    return HomePage();
          }
        // print(usuario[0]["name"]);
        // print(usuario[0]["phone"]);
      }
    }
    print(state);
    return BienvenidaPage();
  }
}