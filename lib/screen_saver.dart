import 'package:flutter/material.dart';

class ScreenSaver extends StatefulWidget {
  const ScreenSaver({super.key});

  @override
  State<ScreenSaver> createState() => _ScreenSaverState();
}

class _ScreenSaverState extends State<ScreenSaver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Stack(
            children: [
              Center(child:Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              )),
              Center(child:Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(color: Colors.black, shape: BoxShape.rectangle),
              )),
              Center(child:Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
              )),
              Center(child:Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              )),
              Center(child: SizedBox(
                height: 150,
                width: 150,
                child: IconButton(
                  //onPressed: (){Navigator.pushNamed(context, "/catalog");}, 
                  onPressed: (){Navigator.pushNamed(context, "/search_screen");},
                  icon: Image(image: AssetImage('images/pokeball.png')),
                  iconSize: 5,
                ),
              )),
              
            ],
          ),
        ),
        backgroundColor: Colors.red,
      );
  }
}