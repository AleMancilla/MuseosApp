import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
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
        name: item["name"],
        url: item["imageURL"],
        horarioA: item["horarioApertura"],
        horarioC: item["horarioCierre"],
        dias: item["diasHabiles"],
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

class ItemList extends StatelessWidget {
  final String url;
  final String name;
  final String horarioA;
  final String horarioC;
  final Map dias;

  const ItemList({this.url, this.name, this.horarioA, this.horarioC, this.dias});
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Column(
            children: [
              Text(this.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),overflow: TextOverflow.fade,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                children: [
                  RichText(
                  text: TextSpan(
                      // text: 'Don\'t have an account?',
                      // style: TextStyle(
                      //     color: Colors.black, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(text: 'LU,   ',
                            style: TextStyle(
                                color: (this.dias["lun"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                        ),
                        TextSpan(text: 'MA,   ',
                            style: TextStyle(
                                color: (this.dias["mar"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                        ),
                        TextSpan(text: 'MI,   ',
                            style: TextStyle(
                                color: (this.dias["mie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                        ),
                        TextSpan(text: 'JU,   ',
                            style: TextStyle(
                                color: (this.dias["jue"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                        ),
                        TextSpan(text: 'VI,   ',
                            style: TextStyle(
                                color: (this.dias["vie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                        ),
                        TextSpan(text: 'SA,   ',
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

              ),
              Text("${this.horarioA} - ${this.horarioC}")
        ],
      ),
        ]
      )
    );
  }
}