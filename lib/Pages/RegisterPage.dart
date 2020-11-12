import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  TextEditingController _confirmpass = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  SharedPreferences myPrefs;

  @override
  void initState() {
    cargando();
    super.initState();
  }

  cargando()async{
    myPrefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 70,bottom: 20),
            padding: EdgeInsets.only(top: 20,bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 100.0,),
                _labelText(text: "Nombre completo",typekey: TextInputType.name,control: _name),
                _labelText(text: "Correo Electronico",typekey: TextInputType.emailAddress,control: _email),
                _labelText(text: "Contraseña",typekey: TextInputType.visiblePassword,control: _pass),
                _labelText(text: "Confirmar contraseña",typekey: TextInputType.visiblePassword,control: _confirmpass),
                _labelText(text: "Numero de celular",typekey: TextInputType.number,control: _number),
                _botonEviar(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _labelText({String text,TextInputType typekey,TextEditingController control}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: TextFormField(
              controller: control,
              obscureText: (typekey == TextInputType.visiblePassword)?true:false,
              decoration: new InputDecoration(
                labelText: "$text",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if(val.length==0) {
                  return "No puede ser un valor nulo";
                }else{
                  return null;
                }
              },
              keyboardType: typekey,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
    );
  }

  _botonEviar(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(100),
        color: Colors.orange,
        child: Text("REGISTRARSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), 
        onPressed: (){
          
          if(
            _email.text.length >0 &&
            _name.text.length >0 &&
            _pass.text.length >0 &&
            _confirmpass.text.length >0 &&
            _number.text.length >0 
          ){
            if(_pass.text == _confirmpass.text){
              _enviandousuario(context);
              
            }else{
              Flushbar(
                  title:  "ERROR CONTRASEÑA",
                  message:  "Las contraseñas no coinsiden por favor verifica la informacion",
                  backgroundColor: Colors.red,
                  duration:  Duration(seconds: 3),              
                )..show(context);
            }
          }else{
            Flushbar(
                  title:  "CAMPOS OBLIGATORIOS",
                  message:  "Por favor complete todos los campos",
                  backgroundColor: Colors.red,
                  duration:  Duration(seconds: 3),              
                )..show(context);
          }
        }
      ),
    );
  }

  _enviandousuario(BuildContext context)async{
     bool state = await insertUser(
          email: _email.text,
          name:  _name.text,
          pass:  _pass.text,
          phone: _number.text
          //  _confirmpass.text
        );

        if(state){
                Flushbar(
                  title:  "REGISTRO EXITOSO",
                  message:  "El usuario se registro exitosamente.",
                  backgroundColor: Colors.green,
                  duration:  Duration(seconds: 3),              
                )..show(context);

                myPrefs.setString("email", _email.text);
                myPrefs.setString("pass", _pass.text);
                
                _email.clear();
                _name.clear();
                _pass.clear();
                _number.clear();
                _confirmpass.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
              }else{
                Flushbar(
                  title:  "FALLO EL REGISTRO",
                  message:  "Tenemos problemas internos para registrar tu usuario",
                  backgroundColor: Colors.red,
                  duration:  Duration(seconds: 3),              
                )..show(context);
              }
        
  }
}