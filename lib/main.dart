import 'package:flutter/material.dart';
import 'package:museosapp/Pages/BienvenidaPage.dart';
import 'package:museosapp/Pages/SplashScreen.dart';
import 'package:museosapp/Providers/MuseoProvider.dart';
import 'package:provider/provider.dart';
///[INICIO DE PROYECTO]
void main() => runApp(MyApp());
 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MuseoProvider()),
      ],
      child: MaterialApp(
        title: 'Material App',
        ///[REDIRECCIONA A PANTALLA SPLASH SCREEN]
        home: SplashScreenPage(),
      ),
    );
  }
}