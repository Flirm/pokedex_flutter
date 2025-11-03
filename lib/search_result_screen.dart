import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_flutter/pokemon_details.dart';
import 'package:pokedex_flutter/search_screen.dart';


Future<Map<String, dynamic>> getSearchURL(String? searchString) async {
    final url = "https://pokeapi.co/api/v2/$searchString";
    final response;
    print(url);
    try{
      response = await http.get(Uri.parse(url));
    }catch(e){
      throw e;
    }
    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar dados da API");
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data;
}
String getTypeImageURL(String? typeInt){
  return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-viii/legends-arceus/$typeInt.png";
}
String getSpriteImageURL(String? pokemonId){
  return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png";
}


class SearchResultScreen extends StatefulWidget {
  final String? searchText;
  final SearchType? searchType;

  const SearchResultScreen({Key? key, required this.searchText, required this.searchType}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState(){
    super.initState();
    _futureData = getSearchURL(widget.searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image(image: AssetImage("images/circleEmpty.png")),
          onPressed: (){},
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
          SizedBox(width: 5,height: 1,),
          Container(
            alignment: Alignment.topLeft,
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
          ),
          SizedBox(width: 5,height: 1,),
          Container(
            alignment: Alignment.topLeft,
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          SizedBox(width: 250,height: 1,),
        ],
      ),
      body: FutureBuilder<Map>(
        future: _futureData,
        builder: (context, snapshot){
          return ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index){
              return pokemonListItem();
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          heroTag: 'fab_search_result',
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

  Widget pokemonListItem(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetails(pokemonId: "1")));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:Colors.red,
              width: 3,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.network(getSpriteImageURL("1"), height: 80,), //TODO: colocar id correspondente
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No. 0", //TODO: colocar id correspondente
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Bulbasaur", //TODO: colocar nome correspondente
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Image.network(getTypeImageURL("6"), height: 15,) //TODO: colocar id correspondente
                    ],),
                    
                  ]
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}