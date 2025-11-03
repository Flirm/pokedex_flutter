import 'package:flutter/material.dart';
import 'package:pokedex_flutter/search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchTextController = TextEditingController();


  void _resetSearch(){
    searchTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image(image: AssetImage("images/circleEmpty.png")),
          onPressed: (){_resetSearch();},
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
      body: SearchBody(searchTextController: searchTextController),
      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          heroTag: 'fab_search',
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

class SearchBody extends StatefulWidget {
  final TextEditingController searchTextController;

  const SearchBody({Key? key, required this.searchTextController}) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

enum SearchType {name, type, generation, habitat}

class _SearchBodyState extends State<SearchBody> {  
  SearchType? _currSearchType = SearchType.name;

  String getStringST(SearchType? searchType){
    if(searchType == SearchType.name){return "pokemon";}
    if(searchType == SearchType.type){return "type";}
    if(searchType == SearchType.generation){return "generation";}
    if(searchType == SearchType.habitat){return "pokemon-habitat";}
    return "pokemon";
  }

  void changeSearchType(SearchType? st){
    _currSearchType = st;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: widget.searchTextController,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                cursorErrorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: "Digite o nome ou ID do(a) ${getStringST(_currSearchType)}",
                  hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 3),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            FiltersButton(callback: changeSearchType,),
            SizedBox(height: 50,),
            IconButton(
              icon: Image(image: AssetImage("images/circle.png"),width: 60,),
              onPressed: (){
                setState(() {
                  String txt = "${getStringST(_currSearchType)}/${widget.searchTextController.text.toLowerCase()}";
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultScreen(searchText: txt, searchType: _currSearchType,)));
                });
              }, 
            ),
          ],
        ),
      ),
    );
  }
}

class FiltersButton extends StatefulWidget {
  final Function(SearchType?) callback;

  const FiltersButton({Key? key, required this.callback}) : super(key: key);

  @override
  State<FiltersButton> createState() => _FiltersButtonState();
}

class _FiltersButtonState extends State<FiltersButton> {
  SearchType? currSearch = SearchType.name;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: 150,
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: (){
        showModalBottomSheet(
          context: context, 
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context){
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterTile(SearchType.name, "Nome"),
                  _buildFilterTile(SearchType.type, "Tipo"),
                  _buildFilterTile(SearchType.generation, "Geração"),
                  _buildFilterTile(SearchType.habitat, "Habitat"),
                ],
              ),
            );
          }
        );
      },
      child: Text("FILTROS", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
    );
  }

  Widget _buildFilterTile(SearchType type, String label) {
    final bool isSelected = currSearch == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          currSearch = type;
        });
        widget.callback(type);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}