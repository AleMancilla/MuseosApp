import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/BienvenidaPage.dart';
import 'package:museosapp/Pages/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

/////////////////////////////////////////////////////
///[PANTALLA DE SPLASHSCREEN]
/////////////////////////////////////////////////////
class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  ///[SharedPreferences - PERSISTENCIA DE DATOS]
  SharedPreferences myPrefs;

  @override
  void initState() {
    cargando();
    super.initState();
  }

  cargando()async{
    /////////////////////////////////////////////////////
    ///[INICIAMOS OBTENIENDO LO GUARDADO EN PREFERENS]
    /////////////////////////////////////////////////////
    myPrefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    ///[sPLASH SCREEN]
    ///[DESPUES DE 2 SEGUNDOS IRA A LA FUNCION _comprobandoPage]
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
    /////////////////////////////////////////////////////
    ///[VERIFICA SI EL USUARIO EXISTE O NO]
    ///[SI NO EXISTE PIDE CREAR UNA CUENTA]
    ///[SI EXISTE REDIRECCIONA A LA PAGINA PRINCIPAL]
    /////////////////////////////////////////////////////
    
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
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BienvenidaPage()));
                    return BienvenidaPage();
          }else{
            Flushbar(
                      title:  "Sesion iniciada",
                      message:  "El usuario se logueo exitosamente.",
                      backgroundColor: Colors.green,
                      duration:  Duration(seconds: 3),              
                    )..show(context);
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                    return HomePage();
          }
        // print(usuario[0]["name"]);
        // print(usuario[0]["phone"]);
      }
    }
    print(state);
    /////////////////////////////////////////////////////
    ///[REDIRECCIONA A LA PAGINA DE LOGUEO]
    /////////////////////////////////////////////////////
    return BienvenidaPage();
  }
}