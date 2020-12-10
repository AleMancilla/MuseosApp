import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/MuseoDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


/////////////////////////////////////////////////////
///[PANTALLA DE LISTADO DE MUSEOS]
/////////////////////////////////////////////////////
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

class ItemList extends StatefulWidget {
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
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> with SingleTickerProviderStateMixin{

  SharedPreferences myPrefs;
  @override
  void initState() { 
    super.initState();
    print("Init state ##");
    _cargandoDatos();
  }
  List lista = [];
  _cargandoDatos()async{
    myPrefs = await SharedPreferences.getInstance();
    lista = await consultarLike(
      idUser: myPrefs.getString("idUser"),
      idMuseo: this.widget.id
    );

    if(lista.length>0){
      setState(() {
        
      });
    }

    print("""
    lista => $lista ==> ${this.widget.id} ==> ${myPrefs.getString("idUser")}
    """);
  }
  
  _likeButton(String idMuseo, bool status){
    bool isLikedOFICIAL = status;
    return LikeButton(
      isLiked: isLikedOFICIAL,
      size: 30,
      circleColor:
          CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
          size: 30,
        );
      },
      // likeCount: 665,
      onTap: (isLiked) {
        return onLikeButtonTapped(isLiked,idMuseo);
      },
      countBuilder: (int count, bool isLiked, String text) {
        var color = isLiked ? Colors.red : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            "love",
            style: TextStyle(color: color),
          );
        } else
          result = Text(
            text,
            style: TextStyle(color: color),
          );
        return result;
      },
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, String idMuseo) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    if(!isLiked){
      insertLike(
        idUser: myPrefs.getString("idUser"),
        idMuseo: this.widget.id
      );
    }else{
      deleteLike(
        idUser: myPrefs.getString("idUser"),
        idMuseo: this.widget.id
      );
    }

    print(" ###### line ${!isLiked} ad $idMuseo");

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
  final MuseoItem museo = MuseoItem(
    id:           this.widget.id, 
    url:          this.widget.url, 
    name:         this.widget.name, 
    horarioA:     this.widget.horarioA, 
    horarioC:     this.widget.horarioC, 
    descripcion:  this.widget.descripcion, 
    ubicacion:    this.widget.ubicacion,
    dias:         this.widget.dias, 
    priceExt:     this.widget.priceExt,
    priceNac:     this.widget.priceNac,

  );
    return GestureDetector(
      onTap: () {
        print(this.widget.id);
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
            Stack(
              children: [
                FadeInImage(
                  width: 130,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/images/loading.gif"), 
                  image: NetworkImage(this.widget.url)
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(),
                    child: _likeButton(this.widget.id, lista.length>0),
                    // IconButton(
                    //   iconSize: 50,
                    //   splashColor: Colors.greenAccent,
                    //   icon: AnimatedIcon(
                    //     icon: AnimatedIcons.,
                    //     progress: _animationController,
                    //   ),
                    //   onPressed: () => _handleOnPressed(),
                    // ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Text(this.widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),overflow: TextOverflow.fade,textAlign: TextAlign.center,),
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
                                  color: (this.widget.dias["lun"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'MA, ',
                              style: TextStyle(
                                  color: (this.widget.dias["mar"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'MI, ',
                              style: TextStyle(
                                  color: (this.widget.dias["mie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'JU, ',
                              style: TextStyle(
                                  color: (this.widget.dias["jue"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'VI, ',
                              style: TextStyle(
                                  color: (this.widget.dias["vie"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'SA, ',
                              style: TextStyle(
                                  color: (this.widget.dias["sab"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                          TextSpan(text: 'DO. ',
                              style: TextStyle(
                                  color: (this.widget.dias["dom"])? Colors.green[600]:Colors.red.withOpacity(0.3)),
                          ),
                        ]
                    ),
                  )
                ],
              ),
                  Text("${this.widget.horarioA} - ${this.widget.horarioC}")
          ],
        ),
            ),
          ]
        )
      ),
    );
  }
}