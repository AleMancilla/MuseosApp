import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/Pages/LoginPage.dart';
import 'package:museosapp/Pages/RegisterPage.dart';

class BienvenidaPage extends StatelessWidget {
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
            _botonLogin(context),
            _botonRegister(context)
          ],
        ),
      ),
    );
  }

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