import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogCompra extends StatefulWidget {
  final double nacional;
  final double extrangero;

  const AlertDialogCompra({@required this.nacional,@required this.extrangero});

  @override
  _AlertDialogCompraState createState() => _AlertDialogCompraState();
}

class _AlertDialogCompraState extends State<AlertDialogCompra> {
  int nac = 0;
  int ext = 0;
  int selectedRadio = 0;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10)
          ),
          margin: EdgeInsets.symmetric(horizontal: 40,vertical: 150),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: Text("COMPRA DE BOLETOS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                _precioNacional(),
                _precioExtrangero(),
                _seleccionarDia(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Costo total: _______________"),
                    Text("${this.widget.nacional*this.nac + this.widget.extrangero*this.ext} Bs.",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),

                GestureDetector(
                  child: Image.asset("assets/images/boton-pagar-tigo-money.png",fit: BoxFit.cover,width: double.infinity,height: 50,),
                  onTap: (){
                    Flushbar(
                      title:  "En proceso",
                      message:  "Pendiente el tramite con TigoMoney",
                      duration:  Duration(seconds: 3),              
                      backgroundColor: Colors.purple,
                    )..show(context);
                  },
                ),
                
                SizedBox(height: 20,),
                CupertinoButton(
                  color: Colors.orange,
                  child: Text("Finalizar Reserva"), 
                  onPressed: (){
                    Navigator.pop(context);
                  }
                ),

                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _seleccionarDia(){
    return Column(
      children: [
        SizedBox(height: 20,),
        Text("Selecciona el dia de reserva",style: TextStyle(fontWeight: FontWeight.bold),),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Text("Lunes"),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Martes"),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Miercoles"),
                  Radio(
                    value: 3,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Jueves"),
                  Radio(
                    value: 4,
                    groupValue: selectedRadio,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Viernes"),
                  Radio(
                    value: 5,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Sabado"),
                  Radio(
                    value: 6,
                    groupValue: selectedRadio,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Domingo"),
                  Radio(
                    value: 7,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _precioNacional(){
    double size = 40;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Text("Boletos Nacionales")),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if(this.nac>0){
                    this.nac = this.nac -1;
                    setState(() {
                      
                    });
                  }
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                  ),
                  alignment: Alignment.center,
                  child: Text("-", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                ),
              ),
              Container(
                width: size,
                height: size+10,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)
                  ),
                alignment: Alignment.center,
                child: Text(this.nac.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
             
              ),
              GestureDetector(
                onTap: () {
                  this.nac = this.nac +1;
                  setState(() {
                    
                  });
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                  ),
                  alignment: Alignment.center,
                  child: Text("+", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  _precioExtrangero(){
    double size = 40;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text("Boletos Extrangero")),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if(this.ext>0){
                    this.ext = this.ext -1;
                    setState(() {
                      
                    });
                  }
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                  ),
                  alignment: Alignment.center,
                  child: Text("-", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                ),
              ),
              Container(
                width: size,
                height: size+10,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)
                  ),
                alignment: Alignment.center,
                child: Text(this.ext.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
             
              ),
              GestureDetector(
                onTap: () {
                  this.ext = this.ext +1;
                  setState(() {
                    
                  });
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                  ),
                  alignment: Alignment.center,
                  child: Text("+", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}