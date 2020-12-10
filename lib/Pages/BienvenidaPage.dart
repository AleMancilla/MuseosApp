import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/Pages/LoginPage.dart';
import 'package:museosapp/Pages/RegisterPage.dart';

/////////////////////////////////////////////////////
///[PANTALLA DE BIENVENIDA]
/////////////////////////////////////////////////////
///
class BienvenidaPage extends StatelessWidget {
  /////////////////////////////////////////////////////
    ///[BUILD CREA LA PANTALLA VISIBLE]
    /////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(bottomRight:Radius.circular(300))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /////////////////////////////////////////////////////
            ///[MUESTRA 2 PANTALLAS UNA DE LOGIN Y LA OTRA DE REGISTRO]
            /////////////////////////////////////////////////////
            _botonLogin(context),
            _botonRegister(context)
          ],
        ),
      ),
    );
  }

/////////////////////////////////////////////////////
    ///[PANTALLA DE LOGIN]
    /////////////////////////////////////////////////////
  _botonLogin(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        child: Text("LOGIN", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),), 
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        }
      ),
    );
  }

  /////////////////////////////////////////////////////
    ///[PANTALLA DE REGISTRO]
    /////////////////////////////////////////////////////
  _botonRegister(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(100),
        color: Colors.orange[400],
        child: Text("REGISTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), 
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
        }
      ),
    );
  }
}