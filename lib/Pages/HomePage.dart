import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/BienvenidaPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text("BIENVENIDO"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("cerrar session"),
          onPressed: (){
            myPrefs.setString("email", null);
            myPrefs.setString("pass", null);
            limpiarGrapql();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BienvenidaPage()));
          },
        ),
      ),
    );
  }
}