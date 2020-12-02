import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/AddMuseos.dart';
import 'package:museosapp/Pages/BienvenidaPage.dart';
import 'package:museosapp/Pages/ListMuseos.dart';
import 'package:museosapp/Providers/MuseoProvider.dart';
import 'package:museosapp/Widgets/ButtomBar.dart';
import 'package:provider/provider.dart';
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
    MuseoProvider museo = Provider.of<MuseoProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(child: _returnPage(museo)),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: ButtomBar(),
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   label: Text("cerrar session"),
        //   onPressed: (){
        //     myPrefs.setString("email", null);
        //     myPrefs.setString("pass", null);
        //     limpiarGrapql();
        //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BienvenidaPage()));
        //   },
        // ),
      ),
    );
  }

  _returnPage(MuseoProvider museo){
    if(museo.page == "home"){
      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.orange,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("assets/images/descarga.png",fit: BoxFit.cover,height: 100,width: 100,)),
              Text("Museos", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListMuseos()
                ),
              ),
            ],
          )
        );
    }else if(museo.page == "addMuseo"){
      // _cargandoPage();
      _cargandoPage();
      return pagina;
      // return AddMuseos();
    }
  }
  Widget pagina = CircularProgressIndicator();
  bool aux = true;
  _cargandoPage()async {
    bool stado = await consultarEditor(myPrefs.getString("email"));
    print("object ${myPrefs.getString("email")} _____ $stado");
    if (stado) {
      pagina =  AddMuseos();
    }else{
      pagina = Container(
        width: double.infinity,
        height: 250,
        padding: EdgeInsets.all(30),    
        child: Text("NO TIENES PERMISOS DE ADMINISTRADOR",style: TextStyle(fontSize: 30,color: Colors.grey),),
      );
    }
    if (aux) {
      aux = false;
      setState(() {
        
      });
    }
    // return stado? AddMuseos():Container(
    //   width: double.infinity,
    //   height: 250,
    //   padding: EdgeInsets.all(30),
    //   child: Text("NO TIENES PERMISOS DE ADMINISTRADOR",style: TextStyle(fontSize: 40,color: Colors.grey),),
    // );
  }
}