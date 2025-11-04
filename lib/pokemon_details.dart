import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetails extends StatefulWidget {
  final String pokemonId;

  const PokemonDetails({Key? key, required this.pokemonId}) : super(key: key);

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

String getShortStatName(String stat){
  if(stat == "hp") return "HP";
  if(stat == "attack") return "ATK";
  if(stat == "defense") return "DEF";
  if(stat == "special-attack") return "SPA";
  if(stat == "special-defense") return "SPD";
  if(stat == "speed") return "SP";
  return "unknown";
}

int getTypeIntFromString(String type){
  if(type == "normal") return 1;
  if(type == "fighting") return 2;
  if(type == "flying") return 3;
  if(type == "poison") return 4;
  if(type == "ground") return 5;
  if(type == "rock") return 6;
  if(type == "bug") return 7;
  if(type == "ghost") return 8;
  if(type == "steel") return 9;
  if(type == "fire") return 10;
  if(type == "water") return 11;
  if(type == "grass") return 12;
  if(type == "electric") return 13;
  if(type == "psychic") return 14;
  if(type == "ice") return 15;
  if(type == "dragon") return 16;
  if(type == "dark") return 17;
  if(type == "fairy") return 18;
  if(type == "stellar") return 19;
  return 20;

}

class _PokemonDetailsState extends State<PokemonDetails> {
  late Future<List<Map<String, dynamic>>> _futureData;

  @override
  void initState(){
    super.initState();
    _futureData = fetchData(widget.pokemonId);
  }
  Future<List<Map<String,dynamic>>> fetchData(String? pokemonId) async{
    final pokeDetails = await getPokemonDetails(pokemonId);

    final pokeSpecies = await getPokemonSpecies(pokeDetails["species"]["url"]);

    final evoLine = await getEvolutiveLine(pokeSpecies["evolution_chain"]["url"]);

    return [pokeSpecies, pokeDetails, evoLine];
  }
  Future<Map<String,dynamic>> getPokemonSpecies(String pokemonSpeciesURL) async {
    final url = pokemonSpeciesURL;
    print(url);
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data;
    }else{
      throw Exception("Erro na requisição");
    }
  }
  Future<Map<String,dynamic>> getPokemonDetails(String? pokemonId) async {
    final url = "https://pokeapi.co/api/v2/pokemon/$pokemonId";
    print(url);
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data;
    }else{
      throw Exception("Erro na requisição");
    }
  }
  Future<Map<String,dynamic>> getEvolutiveLine(String evilutiveLineURL) async {
    final url = evilutiveLineURL;
    print(url);
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data;
    }else{
      throw Exception("Erro na requisição");
    }
  }
  String getTypeImageURL(String? typeInt){
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-viii/legends-arceus/$typeInt.png";
  }
    String getSpriteImageURL(int? pokemonId){
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png";
  }
  List<Map<String, String>> parseEvolutionChain(Map<String, dynamic> chain) {
    List<Map<String, String>> evolutions = [];
    void traverse(Map<String, dynamic> node) {
      final species = node["species"] as Map<String, dynamic>;
      evolutions.add({
        "name": species["name"],
        "url": species["url"],
      });
      final evolvesTo = node["evolves_to"] as List<dynamic>? ?? [];
      for (var evo in evolvesTo) {
        traverse(evo as Map<String, dynamic>);
      }
    }
    traverse(chain["chain"] as Map<String, dynamic>);
    return evolutions;
  }
  Future<List<Map<String,dynamic>>> fetchEvoData(String? pokemonId) async {
    final pokeDetails = await getPokemonDetails(pokemonId);
    final pokeSpecies = await getPokemonSpecies(pokeDetails["species"]["url"]);
    return [pokeSpecies, pokeDetails];
  }

  void _showEvolutionDialog(BuildContext context, String pokemonName) async {
    try {
      final data = await fetchData(pokemonName);

      final pokemonDetail = data[1];
      final pokemonSpecies = data[0];

      int speciesId = pokemonSpecies["id"];
      String nome = pokemonSpecies["name"];
      nome = '${nome[0].toUpperCase()}${nome.substring(1)}';

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Evolução: $nome", style: TextStyle(fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    getSpriteImageURL(speciesId),
                    height: 150,
                  ),
                  SizedBox(height: 10),
                  Text("No. $speciesId", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (pokemonDetail["types"] as List? ?? []).map((tipo) {
                      final typeMap = tipo["type"] as Map<String, dynamic>;
                      final typeName = typeMap["name"] as String? ?? "unknown";
                      final typeInt = getTypeIntFromString(typeName);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.network(
                          getTypeImageURL(typeInt.toString()),
                          height: 25,
                          errorBuilder: (context, error, stack) => Icon(Icons.error),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 30,
                    children: (pokemonDetail["stats"] as List? ?? []).map((stat) {
                      final statMap = stat["stat"] as Map<String, dynamic>;
                      final statName = getShortStatName(statMap["name"] as String? ?? "unknown");
                      final baseStat = stat["base_stat"];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(statName, style: TextStyle(fontWeight: FontWeight.bold)),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red,
                            child: Text(
                              "$baseStat",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Fechar"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados do Pokémon: $e")),
      );
    }
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
      body: FutureBuilder<List<Map<String,dynamic>>>(
        future: _futureData, 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text("Erro na pesquisa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),));
            }
            final pokemonDetail = snapshot.data![1];
            final pokemonSpecies = snapshot.data![0];
            final linhaEvolutiva = parseEvolutionChain(snapshot.data![2]);
            int speciesId = pokemonSpecies["id"];
            String nome = pokemonSpecies["name"];
            String altura = pokemonDetail["height"].toString();
            String peso = pokemonDetail["weight"].toString();
            String habitat;
            if(pokemonSpecies["habitat"] != null) {habitat = pokemonSpecies["habitat"]["name"];}
            else {habitat = "Nenhum";}
            habitat = '${habitat[0].toUpperCase()}${habitat.substring(1)}';
            nome = '${nome[0].toUpperCase()}${nome.substring(1)}';
            return Container(
              child: Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:Colors.red,
                              width: 3,
                            ),
                          ),
                          child: Image.network(getSpriteImageURL(speciesId), height: 200,),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                              Text(
                                "No. ${speciesId.toString()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Nome: $nome",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                "Altura: $altura",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "Peso: $peso",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "Habitat: $habitat",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        for (var tipo in (pokemonDetail["types"] as List? ?? []))
                          if (tipo is Map && tipo["type"] != null)
                            Builder(
                              builder: (context) {
                                final typeMap = tipo["type"] as Map<String, dynamic>;
                                final typeName = typeMap["name"] as String? ?? "unknown";
                                final typeInt = getTypeIntFromString(typeName);
                                print(typeInt);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    getTypeImageURL(typeInt.toString()),
                                    height: 40,
                                    errorBuilder: (context, error, stack) => const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        for (var stat in (pokemonDetail["stats"] as List? ?? []))
                          if (stat is Map && stat["stat"] != null)
                            Builder(
                              builder: (context) {
                                final statMap = stat["stat"] as Map<String, dynamic>;
                                final statName = getShortStatName(statMap["name"] as String? ?? "unknown");
                                final baseStat = stat["base_stat"];
                                print(baseStat);
                                return Expanded(
                                  child: Padding(
                                  padding: const EdgeInsets.only(right: 7.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "$statName:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 4,
                                          )
                                        ),
                                        child:
                                        Text(
                                          "$baseStat",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ]
                                  ),
                                ));
                              },
                            ),
                      ],
                    ),
                    SizedBox(height: 25,),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Linha Evolutiva: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 10,
                        children: linhaEvolutiva.map((evo){
                          String? evoNome = evo["name"];
                          evoNome = evoNome![0].toUpperCase() + evoNome.substring(1);
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: (){
                                _showEvolutionDialog(context, evoNome!);
                              }, 
                              child: Text(evoNome, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                            )
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Baby: ",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Icon(pokemonSpecies["is_baby"] ? Icons.check : Icons.close)
                          ]
                        ),
                        Column(
                          children: [
                            Text(
                              "Lendário: ",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Icon(pokemonSpecies["is_legendary"] ? Icons.check : Icons.close)
                          ]
                        ),
                        Column(
                          children: [
                            Text(
                              "Mítico: ",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Icon(pokemonSpecies["is_mythical"] ? Icons.check : Icons.close)
                          ]
                        ),
                      ],
                    )
                  ]
                ),
              )
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
}