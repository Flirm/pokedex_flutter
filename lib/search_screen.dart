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
    print("here");  
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

class _SearchBodyState extends State<SearchBody> {  
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
                  hintText: "Digite o nome ou ID do pokemon",
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
            FiltersButton(),
            SizedBox(height: 50,),
            IconButton(
              icon: Image(image: AssetImage("images/circle.png"),width: 60,),
              onPressed: (){
                setState(() {
                  widget.searchTextController.text = widget.searchTextController.text.toLowerCase(); 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultScreen(searchText: widget.searchTextController.text)));
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
  const FiltersButton({super.key});

  @override
  State<FiltersButton> createState() => _FiltersButtonState();
}

class _FiltersButtonState extends State<FiltersButton> {
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
          builder: (context){
            return Container();
          }
        );
      },
      child: Text("FILTROS", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
    );
  }
}