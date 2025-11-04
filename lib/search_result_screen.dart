import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_flutter/pokemon_details.dart';
import 'package:pokedex_flutter/search_screen.dart';


class SearchResultScreen extends StatefulWidget {
  final String? searchText;

  const SearchResultScreen({Key? key, required this.searchText}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState(){
    super.initState();
    _futureData = getSearchResult(widget.searchText);
  }

  Future<Map<String,dynamic>> getSearchResult(String? searchString) async {
    final url = "https://pokeapi.co/api/v2/$searchString";
    print(url);
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data;
    }else{
      throw Exception("Erro na requisição");
    }
  }
  String getSpriteImageURL(String? pokemonId){
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png";
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
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text("Erro na pesquisa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),));
            }
            final pokemons = snapshot.data!["pokemon"] ?? snapshot.data!["pokemon_species"];
            return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index){
                Map pokemon = pokemons[index];
                String nome = pokemon["name"] ?? pokemon["pokemon"]["name"];
                nome = '${nome[0].toUpperCase()}${nome.substring(1)}';
                String url = pokemon["url"] ?? pokemon["pokemon"]["url"];
                Match? m = RegExp(r'/(\d+)/?$').firstMatch(url);
                String id = m==null? "" : m.group(1)!;
                return pokemonListItem(nome, id);
              },
            );
          }
          return Center(child: CircularProgressIndicator(color: Colors.red),);
          
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
    );
  }

  Widget pokemonListItem(String nome, String id){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetails(pokemonId: id)));
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
                    Image.network(
                      getSpriteImageURL(id), 
                      height: 80,
                      errorBuilder: (context, error, stackTrace){
                        return const Icon(Icons.error, color: Colors.red, size: 80,);
                      },
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No. $id",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            nome,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
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