import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:museosapp/Pages/ListMuseos.dart';
class MuseoPage extends StatelessWidget {
  final MuseoItem museo;
  
  const MuseoPage({@required this.museo});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color textoColor = Colors.black;

    List<double> coord = [0,0];
    List<String> coord2 = ["",""];
    coord2 = this.museo.ubicacion.split(",");
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
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: null, 
          label: Text("COMPRAR ENTRADAS"),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  
                  FadeInImage(
                    placeholder: AssetImage("assets/images/loading.gif"), 
                    image: NetworkImage(this.museo.url),
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
                      child: Text(this.museo.name,style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),),
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
                            TextSpan(text: '     ${this.museo.horarioA}', style: TextStyle(fontWeight: FontWeight.normal,color: textoColor,fontSize: 18,)),
                          ],
                        ),
                      ),


                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: 'Cierran a las:\n', style: TextStyle(fontWeight: FontWeight.bold,color: textoColor,fontSize: 18)),
                            TextSpan(text: '      ${this.museo.horarioC}', style: TextStyle(fontWeight: FontWeight.normal,color: textoColor,fontSize: 18)),
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

              Container(
                padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                child: Text(this.museo.descripcion,style: TextStyle(),textAlign: TextAlign.justify,),
              ),

              Text("PRECIOS:",textAlign: TextAlign.center,style: TextStyle(fontSize: 20, ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _btnPrecio("${this.museo.priceNac}","Nacional"),
                  _btnPrecio("${this.museo.priceExt}","Extrangero"),
                ],
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
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