import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/MuseoDetailsPage.dart';
class ListMuseos extends StatefulWidget {
  @override
  _ListMuseosState createState() => _ListMuseosState();
}

class _ListMuseosState extends State<ListMuseos> {

  List<Widget> items ;
  List listado =[];

  @override
  void initState() {
    _cargarDatos();
    super.initState();
  }

  _cargarDatos()async{
    listado=await consultarMuseo();
    items = listado.map((item) {
      return ItemList(
        id: item["idMuseo"],
        name: item["name"],
        url: item["imageURL"],
        horarioA: item["horarioApertura"],
        horarioC: item["horarioCierre"],
        dias: item["diasHabiles"],
        descripcion: item["description"],
        ubicacion: item["ubicacion"],
        priceNac: double.parse(item["priceNational"].toString()) ,
        priceExt: double.parse(item["priceExtrangero"].toString()) ,
      );
    }).toList();
    setState(() {
      
    });
    // print(listado);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: items==null?[CircularProgressIndicator()]:items,
      ),
    );
  }
}

class MuseoItem{
  final String id;
  final String url;
  final String name;
  final String horarioA;
  final String horarioC;
  final String descripcion;
  final String ubicacion;
  final Map dias; 
  final double priceNac;
  final double priceExt;
  MuseoItem({ 
    @required this.priceNac, 
    @required this.priceExt, 
    @required this.id, 
    @required this.url, 
    @required this.name, 
    @required this.horarioA, 
    @required this.horarioC, 
    @required this.descripcion, 
    @required this.ubicacion,
    @required this.dias,
  });
}

class ItemList extends StatelessWidget {
  final String id;
  final String url;
  final String name;
  final String horarioA;
  final String horarioC;
  final String descripcion;
  final String ubicacion;
  final Map    dias;
  final double priceNac;
  final double priceExt;
  

  ItemList({this.url, this.name, this.horarioA, this.horarioC, this.dias, this.id, this.descripcion, this.ubicacion, this.priceNac, this.priceExt});

  @override
  Widget build(BuildContext context) {
  final MuseoItem museo = MuseoItem(
    id:           this.id, 
    url:          this.url, 
    name:         this.name, 
    horarioA:     this.horarioA, 
    horarioC:     this.horarioC, 
    descripcion:  this.descripcion, 
    ubicacion:    this.ubicacion,
    dias:         this.dias, 
    priceExt:     this.priceExt,
    priceNac:     this.priceNac,

  );
    return GestureDetector(
      onTap: () {
        print(this.id);
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => MuseoPage(museo: museo,)));
        // Flushbar(
        //           title:  "EN CONSTRUCCION",
        //           message:  "La pantalla aun no esta acabada",
        //           backgroundColor: Colors.red,
        //           duration:  Duration(seconds: 3),              
        //         )..show(context);
      },
      child: Container(
        color: Colors.orange.withOpacity(0.05),
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Row(
          children: [
            FadeInImage(
              width: 130,
              height: 100,
              fit: BoxFit.cover,
              placeholder: AssetImage("assets/images/loading.gif"), 
              image: NetworkImage(this.url)
            ),
            Expanded(
              child: Column(
                children: [
                  Text(this.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),overflow: TextOverflow.fade,textAlign: TextAlign.center,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                    text: TextSpan(
                        // text: 'Don\'t have an account?',
                        // style: TextStyle(
                        //     color: Colors.black, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(text: 'LU, ',
                              style: TextStyle(
                                  color: (this.dias["lun"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'MA, ',
                              style: TextStyle(
                                  color: (this.dias["mar"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'MI, ',
                              style: TextStyle(
                                  color: (this.dias["mie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'JU, ',
                              style: TextStyle(
                                  color: (this.dias["jue"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'VI, ',
                              style: TextStyle(
                                  color: (this.dias["vie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'SA, ',
                              style: TextStyle(
                                  color: (this.dias["sab"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'DO. ',
                              style: TextStyle(
                                  color: (this.dias["dom"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                        ]
                    ),
                  )
                ],
              ),
                  Text("${this.horarioA} - ${this.horarioC}")
          ],
        ),
            ),
          ]
        )
      ),
    );
  }
}