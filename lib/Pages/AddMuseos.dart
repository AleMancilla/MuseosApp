

import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _labelNombre(controller: nameController, descripcion: "Nombre del museo",minLines: 1),
            _labelNombre(controller: descriptionController, descripcion: "Datos del Museo",minLines: 10),
            _labelDias(),
            _selectedHoraApertura(),
            _selectedHoraCierre(),
            _cargarImagen()
          ],
        ),
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
                              horaCierre = "${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}" ;
                              setState(() {
                                
                              });
                              print('${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}');
                            }, 
                          );
                        },
                      label: Text(
                          (horaCierre != null)?"Hora de apertura: $horaCierre":"Selecciona la hora de apertura",
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
                              horaApertura = "${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}" ;
                              setState(() {
                                
                              });
                              print('${date.hour.remainder(24).toString().padLeft(2, '0')}:${date.minute.remainder(60).toString().padLeft(2, '0')}');
                            }, 
                          );
                        },
                      label: Text(
                          (horaApertura != null)?"Hora de cierre: $horaApertura":"Selecciona la hora de cierre",
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

}