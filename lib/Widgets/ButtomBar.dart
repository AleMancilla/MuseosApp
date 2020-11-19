import 'package:flutter/material.dart';
import 'package:museosapp/Providers/MuseoProvider.dart';
import 'package:provider/provider.dart';

class ButtomBar extends StatefulWidget {
  @override
  _ButtomBarState createState() => _ButtomBarState();
}

class _ButtomBarState extends State<ButtomBar> {
  MuseoProvider museo;
  @override
  void initState() {
    museo = Provider.of<MuseoProvider>(context,listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Container(
      // color: Colors.red,
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         BtnIconButtomBar(icono: Icons.museum,title: "Museos",st: status,ontap: (){
           status = true;
           museo.page = "home";
           setState(() {
             
           });
         },),
         BtnIconButtomBar(icono: Icons.add_a_photo_rounded,title: "Nuevo Museo",st: !status,ontap: (){
           status = false;
           museo.page = "addMuseo";
           setState(() {
             
           });
         },),
       ],
     ), 
    );
  }
}
bool status=true;
class BtnIconButtomBar extends StatefulWidget {
  final IconData icono;
  final String title;
  final bool st;
  final Function ontap;
  BtnIconButtomBar({@required this.icono,@required this.title, this.st, this.ontap}) ;
  @override
  _BtnIconButtomBarState createState() => _BtnIconButtomBarState();
}

class _BtnIconButtomBarState extends State<BtnIconButtomBar> {
  MuseoProvider museo;
  @override
  void initState() {
    museo = Provider.of<MuseoProvider>(context,listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.widget.ontap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(this.widget.icono,
              color: (this.widget.st)?Colors.orange:Colors.grey,
            ),
            Text(this.widget.title)
          ],
        ),
      ),
    );
  }
}