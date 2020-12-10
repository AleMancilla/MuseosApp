import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/AlertDialogCompra.dart';
import 'package:museosapp/Pages/ListMuseos.dart';
import 'package:shared_preferences/shared_preferences.dart';

/////////////////////////////////////////////////////
    ///[PANTALLA DE DESCRIPCION DEL MUSEO]
    /////////////////////////////////////////////////////

class MuseoPage extends StatefulWidget {
  final MuseoItem museo;
  
  const MuseoPage({@required this.museo});

  @override
  _MuseoPageState createState() => _MuseoPageState();
}

class _MuseoPageState extends State<MuseoPage> {

  SharedPreferences myPrefs;
  @override
  void initState() { 
    super.initState();
    _cargandoDatos();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    print(" ### BACKdispose ###");
    // limpiarGrapql();
    _controllerComentario.dispose();
    super.dispose();
  }
  List<ComentariosUser> listaComentarios ;
  List<ComentarioMuseo> comentariosMuseo ;
  String direccion = "";
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    listaComentarios = await readComentario(this.widget.museo.id);
    comentariosMuseo = listaComentarios.map((e) {
      return ComentarioMuseo(
        usuario: e.autor, 
        comentario: e.comentario, 
        fecha: e.fecha.toString()
      );
    }).toList();
    setState(() {
      
    });

    List<double> coord = [0,0];
    List<String> coord2 = ["",""];
    coord2 = this.widget.museo.ubicacion.split(",");
    coord[0] = double.parse(coord2[0]); 
    coord[1] = double.parse(coord2[1]); 

    List<Placemark> placemarks = await placemarkFromCoordinates(coord[0], coord[1]);
    direccion = placemarks[0].locality +", "+ placemarks[0].street ;
    print("""
    ----------------

    $placemarks

    ----------------
    """);

  }

  //-------------------------Function That Triggers when you hit the back key
  // bool isBackButtonActivated = false;
  // @override
  // didPopRoute(){

  //   print(" ### BACK ###");
  //   bool override;
  //   if(isBackButtonActivated)
  //     override = false;
  //   else
  //     override = true;
  //   return new Future<bool>.value(override);
  // }

  
  List lista = [];
  _cargandoDatos()async{
    myPrefs = await SharedPreferences.getInstance();
    lista = await consultarLike(
      idUser: myPrefs.getString("idUser"),
      idMuseo: this.widget.museo.id
    );

    if(lista.length>0){
      setState(() {
        
      });
    }

    print("""
    lista => $lista ==> ${this.widget.museo.id} ==> ${myPrefs.getString("idUser")}
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
        idMuseo: this.widget.museo.id
      );
    }else{
      deleteLike(
        idUser: myPrefs.getString("idUser"),
        idMuseo: this.widget.museo.id
      );
    }

    print(" ###### line ${!isLiked} ad $idMuseo");

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color textoColor = Colors.black;

    List<double> coord = [0,0];
    List<String> coord2 = ["",""];
    coord2 = this.widget.museo.ubicacion.split(",");
    coord[0] = double.parse(coord2[0]); 
    coord[1] = double.parse(coord2[1]); 
     Completer<GoogleMapController> _controller = Completer();
    final CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(coord[0], coord[1]),
      zoom: 14.4746,
    );

    GoogleMapController mapController;
    Set<Marker> _markers = {};
    _markers.add(
            Marker(
               markerId: MarkerId('Terminal'),
               position: LatLng(coord[0], coord[1]),
            ));


    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: (){
          //     print("object");
          //     showAlertDialog(context,this.widget.museo.priceNac,this.widget.museo.priceExt);
          //   }, 
          //   label: Text("COMPRAR ENTRADAS"),
          //   backgroundColor: Colors.orange,
          // ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    
                    FadeInImage(
                      placeholder: AssetImage("assets/images/loading.gif"), 
                      image: NetworkImage(this.widget.museo.url),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: size.height*0.3,
                      
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   height: size.height*0.3,
                    //   color: Colors.blueGrey[900].withOpacity(0.5),
                    // ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        color: Colors.blueGrey[900].withOpacity(0.6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(this.widget.museo.name,style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            _likeButton(this.widget.museo.id, lista.length>0)
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Abren a las:\n', style: TextStyle(fontWeight: FontWeight.bold,color: textoColor,fontSize: 18)),
                              TextSpan(text: '     ${this.widget.museo.horarioA}', style: TextStyle(fontWeight: FontWeight.normal,color: textoColor,fontSize: 18,)),
                            ],
                          ),
                        ),


                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Cierran a las:\n', style: TextStyle(fontWeight: FontWeight.bold,color: textoColor,fontSize: 18)),
                              TextSpan(text: '      ${this.widget.museo.horarioC}', style: TextStyle(fontWeight: FontWeight.normal,color: textoColor,fontSize: 18)),
                            ],
                          ),
                        ),

                      ],
                    ),

                    Container(
                        width: size.width*0.5,
                        height: size.width*0.5,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: _markers,
                          initialCameraPosition: kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            mapController = controller;
                            
                          },
                          
                        ),
                      )
                  ],
                ),

                //direccion
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Direccion: $direccion",style: TextStyle(),textAlign: TextAlign.justify,),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  child: Text(this.widget.museo.descripcion,style: TextStyle(),textAlign: TextAlign.justify,),
                ),

                Text("PRECIOS:",textAlign: TextAlign.center,style: TextStyle(fontSize: 20, ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _btnPrecio("${this.widget.museo.priceNac}","Nacional"),
                    _btnPrecio("${this.widget.museo.priceExt}","Extrangero"),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                FloatingActionButton.extended(
                  onPressed: (){
                    print("object");
                    showAlertDialog(context,this.widget.museo.priceNac,this.widget.museo.priceExt);
                  }, 
                  label: Text("COMPRAR ENTRADAS"),
                  backgroundColor: Colors.orange,
                ),
                SizedBox(
                  height: 15,
                ),
                
                _listaComentarios(context)
              ],
            ),
          ),
        ),
      ),
    );
  }


  TextEditingController _controllerComentario = new TextEditingController();
  
  _listaComentarios(BuildContext context){
    String email ="";
    List aux;

    if(myPrefs!=null){
      email  = myPrefs.getString("email");
      aux = email.split("@");
      email = aux[0];
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Colors.orange.withOpacity(0.1),
      child: Column(
        children: [
          Text("COMENTARIOS:",textAlign: TextAlign.center,style: TextStyle(fontSize: 20, ),),
          if(comentariosMuseo!=null) ...comentariosMuseo,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35,vertical: 15),
            child: TextFormField(
              controller: _controllerComentario,
              decoration: InputDecoration(
                labelText: "Comentario",
                border: OutlineInputBorder(),
                
              ),
              maxLines: 5,
              minLines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Usuario: $email@******** ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14, ),),
              GestureDetector(
                onTap: () async {
                  bool stado = await  insertComentario(
                    idUser: myPrefs.getString("idUser"),
                    idMuseo: this.widget.museo.id,
                    autor: email,
                    comentario: _controllerComentario.text
                  );

                  if(stado){
                    Flushbar(
                        title:  "Aceptado",
                        message:  "Su comentario fue aceptado correctamente",
                        backgroundColor: Colors.green,
                        duration:  Duration(seconds: 3),              
                      )..show(context);
                      ComentarioMuseo item = new ComentarioMuseo(
                        usuario: email,
                        comentario: _controllerComentario.text,
                        fecha: DateTime.now().toString(),
                      );
                      comentariosMuseo.add(item);
                      Future.delayed(Duration(microseconds: 3001),(){
                        setState(() {
                          
                        });
                      });
                  }else{
                    Flushbar(
                        title:  "Error",
                        message:  "Hubo un error en su publicacion de comentario.",
                        backgroundColor: Colors.red,
                        duration:  Duration(seconds: 3),              
                      )..show(context);
                  }
                  _controllerComentario.clear();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Text("Comentar", style: TextStyle(color: Colors.white,)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context,double nacional, double extrangero) {
    // // set up the button
    // Widget okButton = FlatButton(
    //   child: Text("OK"),
    //   onPressed: () { },
    // );
    // set up the AlertDialog
    Widget alert = AlertDialogCompra(nacional: nacional,extrangero: extrangero,);
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _btnPrecio(String data,String tipo){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(tipo, style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
          Text("$data Bs", style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}


class ComentarioMuseo extends StatelessWidget {
  final String usuario;
  final String comentario;
  final String fecha;

  const ComentarioMuseo({@required this.usuario,@required this.comentario,@required this.fecha}) ;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${this.usuario}****",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
          Text(this.comentario),
          Row(
            children: [
              Expanded(child: Container()),
              Text(this.fecha.substring(0,10),style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.w300),),
            ],
          ),
        ],
      ),
    );
  }
}