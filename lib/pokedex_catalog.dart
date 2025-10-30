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
        actions: [],
      ),
      body: BuildCatalog(),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 70,
                width: double.infinity,
                color: Colors.red,
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child:Container(
                    height: 95,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  )
                ),
                SizedBox(height: 7,)
              ]
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 110,
                width: 110,
                child: IconButton(
                  icon: Image(image: AssetImage("images/pokeball.png"),),
                  onPressed: (){Navigator.pop(context);},
                  )
              )
            )
          ],
        )
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
    return const Placeholder();
  }
}