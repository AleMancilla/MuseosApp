

import 'dart:async';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Providers/MuseoProvider.dart';
import 'package:provider/provider.dart';

class AddMuseos extends StatefulWidget {
  @override
  _AddMuseosState createState() => _AddMuseosState();
}

class _AddMuseosState extends State<AddMuseos> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  bool lunes = false;
  bool martes = false;
  bool miercoles = false;
  bool jueves = false;
  bool viernes = false;
  bool sabado = false;
  bool domingo = false;
  String horaApertura ;
  String horaCierre ;
  MuseoProvider museo;
  @override
  void initState() {
    museo = Provider.of<MuseoProvider>(context,listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _botonObtenerGeo(),
          _cuerpoMapa(),
          Expanded(
            // height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                    _labelNombre(controller: nameController, descripcion: "Nombre del museo",minLines: 1),
                    _labelNombre(controller: descriptionController, descripcion: "Datos del Museo",minLines: 10),
                    _labelDias(),
                    _selectedHoraApertura(),
                    _selectedHoraCierre(),
                    _cargarImagen(),
                    _botonEnviar()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _cuerpoMapa(){
    return Container(
                    width: double.infinity,
                    height: 150,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: _markers,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        mapController = controller;
                        
                      },
                      
                    ),
                  );
  }

  _labelNombre({TextEditingController controller,String descripcion, int minLines}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      
      width: double.infinity,
      child: Column(
        children: [
          Text(descripcion),
          Container(
            width: double.infinity,
            child: TextField(
              minLines: minLines,
              maxLines: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              controller: controller,
            ),
          )
        ],
      ),
    );
  }

  _selectedHoraApertura(){
    return Container(
      margin: EdgeInsets.all(8),
      child: FloatingActionButton.extended(
                      onPressed: () {
                          DatePicker.showTime12hPicker(context,
                            showTitleActions: true,
                            
                            onChanged: (date) {
                              print('change $date');
                            }, 
                            onConfirm: (date) {
                              horaApertura = "${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}" ;
                              setState(() {
                                
                              });
                              print('${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}');
                            }, 
                          );
                        },
                      label: Text(
                          (horaApertura != null)?"Hora de apertura: $horaApertura":"Selecciona la hora de apertura",
                          style: TextStyle(color: Colors.white),
                      )
                    ),
    );
  }

  _selectedHoraCierre(){
    return Container(
      margin: EdgeInsets.all(8),
      child: FloatingActionButton.extended(
                      onPressed: () {
                          DatePicker.showTime12hPicker(context,
                            showTitleActions: true,
                            
                            onChanged: (date) {
                              print('change $date');
                            }, 
                            onConfirm: (date) {
                              horaCierre = "${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}" ;
                              setState(() {
                                
                              });
                              print('${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}');
                            }, 
                          );
                        },
                      label: Text(
                          (horaCierre != null)?"Hora de cierre: $horaCierre":"Selecciona la hora de cierre",
                          style: TextStyle(color: Colors.white),
                      )
                    ),
    );
  }

  _labelDias(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      width: double.infinity,
      child: Column(
        children: [
          Text("Indique Los dias que esta abierto:"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Lun"),
                    Checkbox(
                      value: lunes,
                      onChanged: (bool value) {
                        setState(() {
                          lunes = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Tuesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Mar"),
                    Checkbox(
                      value: martes,
                      onChanged: (bool value) {
                        setState(() {
                          martes = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Wednesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Mie"),
                    Checkbox(
                      value: miercoles,
                      onChanged: (bool value) {
                        setState(() {
                          miercoles = value;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Jue"),
                    Checkbox(
                      value: jueves,
                      onChanged: (bool value) {
                        setState(() {
                          jueves = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Tuesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Vie"),
                    Checkbox(
                      value: viernes,
                      onChanged: (bool value) {
                        setState(() {
                          viernes = value;
                        });
                      },
                    ),
                  ],
                ),
                // [Wednesday] checkbox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sab"),
                    Checkbox(
                      value: sabado,
                      onChanged: (bool value) {
                        setState(() {
                          sabado = value;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Dom"),
                    Checkbox(
                      value: domingo,
                      onChanged: (bool value) {
                        setState(() {
                          domingo = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///////////////////
  ///
  _cargarImagen(){
    return Column(
      children: [
        Text("Foto o logo del museo:"),
                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(Icons.add_a_photo),
                              color: Colors.orange,
                              iconSize: 50,
                            ),
                            IconButton(
                              onPressed: () {
                                getImageGalery();
                              },
                              icon: Icon(Icons.image_search),
                              color: Colors.orange,
                              iconSize: 50,
                            ),
                          ],
                        ),

                        _image == null
                        ? Container(
                          color: Colors.grey,
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            child: Text("No seleccionaste ninguna imagen",textAlign: TextAlign.center,)
                          )
                        : Container(
                          color: Colors.transparent,
                            width: 200,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_image,fit: BoxFit.cover,))
                          ),
                      ],
                    ),
      ],
    );
  }
  
  File _image;
  final picker = ImagePicker();
  String urlImage = "Sin Imagen";

  void cargarUrl()async{
    urlImage = await subirImagen(_image);
    print(urlImage);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        cargarUrl();
      } else {
        print('No image selected.');
      }
    });
  }
  Future getImageGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        cargarUrl();
      } else {
        print('No image selected.');
      }
    });
  }
  Future<String> subirImagen(File image)async{
    final url = Uri.parse("https://api.cloudinary.com/v1_1/alemancilla/image/upload?upload_preset=hhavzkgi");
    final mimeType = mime(image.path).split("/");
    final uploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      "file", 
      image.path,
      contentType: MediaType(mimeType[0],mimeType[1])
    );
    uploadRequest.files.add(file);

    final streamResponse = await uploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print("Algo salio mal ");
      print(resp.body);
      return null;
    }
    final respdata = json.decode(resp.body);
    print(" === $respdata");
    Flushbar(
              title:  "LISTO",
              message:  "Todo esta listo para enviar datos a backend",
              duration:  Duration(seconds: 3),              
              backgroundColor: Colors.purple,
            )..show(context);
    return respdata['secure_url'];
  }

  ////////
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(-16.4825542, -68.1213619),
    zoom: 14.4746,
  );

  GoogleMapController mapController;
  Set<Marker> _markers = {};
  Position position ;
  List<double> coord = [0,0];
  Future<void> _goToTheLake(_kLake,position) async {
    _markers={};
     final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    _markers.add(
            Marker(
              draggable: true,
               markerId: MarkerId('Terminal'),
               position: LatLng(position.latitude, position.longitude),
               onDragEnd: (newPosition) {
                  coord[0]=newPosition.latitude;
                  coord[1]=newPosition.longitude;
                  print(coord[0]);
                  print(coord[1]);
               },
            ));
    setState(() {
      
    });

    
  }

  _botonObtenerGeo(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      width: double.infinity,
      child: CupertinoButton(
        onPressed: () async {
          Flushbar(
              title:  "Procesando",
              message:  "Obteniendo el dato de la ubicacion..",
              duration:  Duration(seconds: 3),              
              backgroundColor: Colors.green,
            )..show(context);
          print("===== ");
          position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print(position.toString());
          coord[0] = position.latitude;
          coord[1] = position.longitude;
          CameraPosition kLake = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(position.latitude, position.longitude),
          
          // tilt: 59.440717697143555,
          zoom: 16);

          _goToTheLake(kLake,position);
           
        },
        child: Text("obtener ubicacion de museo"),
        color: Colors.green,
      ),
    );
  }

  /////
   _botonEnviar(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: CupertinoButton(
        onPressed: () async {
          Flushbar(
                  title:  "Enviando datos a backend",
                  message:  "Porfavor espera unos segundos mientras se completa la accion",
                  duration:  Duration(seconds: 2),
                  backgroundColor: Colors.orange,             
                )..show(context);
          print("===== ");
          // print(textController.text);
          // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          // print(position);
          bool state = await insertMuseo(
            name: nameController.text,
            description: descriptionController.text,
            diasHabiles: {
              "lun":lunes,
              "mar":martes,
              "mie":miercoles,
              "jue":jueves,
              "vie":viernes,
              "sab":sabado,
              "dom":domingo
            },
            horarioApertura: horaApertura,
            horarioCierre: horaCierre,
            imageURL: urlImage,
            ubicacion: "${coord[0]}, ${coord[1]}"
          );// textController.text, position.toString()

          if(state){
            Flushbar(
              title:  "Aceptado",
              message:  "El dato fue completado exitosamente",
              duration:  Duration(seconds: 3),              
              backgroundColor: Colors.green,
            )..show(context);
            new Future.delayed(Duration(milliseconds: 3001),() {
              nameController.clear();
              descriptionController.clear();
              lunes = false;
              martes = false;
              miercoles = false;
              jueves = false;
              viernes = false;
              sabado = false;
              domingo = false;
              horaApertura = null;
              horaCierre = null;
              coord = [0,0];
              urlImage = "";
              setState(() {
                
              });
            });
          }else{
            Flushbar(
              title:  "ERROR",
              message:  "Sucedio un error por favor verifica tu conexion y que tu GPS este activado",
              duration:  Duration(seconds: 3),              
              backgroundColor: Colors.red,
            )..show(context);
          }
          limpiarGrapql();
        },
        child: Text("Enviar"),
        color: Colors.orange,
      ),
    );
  }


}