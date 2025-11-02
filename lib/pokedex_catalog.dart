import 'package:flutter/material.dart';

class PokeCatalog extends StatefulWidget {
  const PokeCatalog({super.key});

  @override
  State<PokeCatalog> createState() => _PokeCatalogState();
}

class _PokeCatalogState extends State<PokeCatalog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image(image: AssetImage("images/circle.png")),
          onPressed: (){Navigator.pushNamed(context, "/search_screen");},
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        actions: [
          Container(
            alignment: Alignment.topLeft,
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 42, 42), shape: BoxShape.circle),
          ),
          SizedBox(width: 5,),
          Container(
            alignment: Alignment.topLeft,
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
          ),
          SizedBox(width: 5,),
          Container(
            alignment: Alignment.topLeft,
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          SizedBox(width: 250,),
        ],
      ),
      body: BuildCatalog(),
      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          heroTag: 'fab_catalog', 
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () {Navigator.pop(context);},
          child: const Image(
            image: AssetImage("images/pokeball.png"),
            height: 100,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        height: 60,
      ),
    );
  }
}

class BuildCatalog extends StatefulWidget {
  const BuildCatalog({super.key});

  @override
  State<BuildCatalog> createState() => _BuildCatalogState();
}

class _BuildCatalogState extends State<BuildCatalog> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(width: 50,height: 50, decoration: BoxDecoration(color: Colors.black),),);
  }
}