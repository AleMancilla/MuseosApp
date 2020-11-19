import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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

}