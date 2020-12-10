import 'package:flutter/cupertino.dart';

/////////////////////////////////////////////////////
///[MANEJO DE LOS DATOS DE INDEX DE PANTALLA] VARIABLE GLOBAL
/////////////////////////////////////////////////////
class MuseoProvider with ChangeNotifier{

  String _page = "home";
  String get page => this._page;
  set page(String pg){
    this._page = pg;
    notifyListeners();
  }


  
}