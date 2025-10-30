import 'package:flutter/material.dart';
import 'package:pokedex_flutter/pokedex_catalog.dart';
import 'package:pokedex_flutter/screen_saver.dart';
import 'package:pokedex_flutter/search_screen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokedex",
      debugShowCheckedModeBanner: false,
      home: ScreenSaver(),
      initialRoute: "/",
      routes: {
        "/catalog":(context) => PokeCatalog(),
        "/search_screen":(context) => SearchScreen(),
      },
    );
  }
}