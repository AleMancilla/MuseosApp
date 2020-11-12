import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museosapp/DB/GraphQl.dart';
import 'package:museosapp/Pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
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
                _labelText(text: "Correo Electronico",typekey: TextInputType.emailAddress,control: _email),
                _labelText(text: "Contraseña",typekey: TextInputType.visiblePassword,control: _pass),
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
        child: Text("INICIAR SESION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), 
        onPressed: (){
          print("""
          
          ${_email.text}
          ${_pass.text}
          
          """);
          if(_email.text.length>0 && _pass.text.length>0){
            iniciarSession(context);
          }else{
           Flushbar(
                  title:  "CAMPOS OBLIGATORIOS",
                  message:  "Por favor complete todos los campos",
                  backgroundColor: Colors.red,
                  duration:  Duration(seconds: 3),              
                )..show(context);
          }

          // iniciandoSesion(email: _email.text, pass: _pass.text);
        }
      ),
    );
  }

  iniciarSession(BuildContext context)async{
    List usuario = await iniciandoSesion(email: _email.text, pass: _pass.text);
    if(usuario.length==0)
      {
        Flushbar(
                  title:  "Fallo inicio de sesion",
                  message:  "El usuario no fue encontrado, por favor vuelva a intentarlo.",
                  backgroundColor: Colors.red,
                  duration:  Duration(seconds: 3),              
                )..show(context);
        return;
      }else{
        Flushbar(
                  title:  "Sesion iniciada",
                  message:  "El usuario se logueo exitosamente.",
                  backgroundColor: Colors.green,
                  duration:  Duration(seconds: 3),              
                )..show(context);
                myPrefs.setString("email", _email.text);
                myPrefs.setString("pass", _pass.text);
                _email.clear();
                _pass.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
    print(usuario[0]["name"]);
    print(usuario[0]["phone"]);
  }
}