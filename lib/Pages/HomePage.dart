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
      return ListMuseos();
    }else if(museo.page == "addMuseo"){
      return AddMuseos();
    }
  }
}