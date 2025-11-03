import 'package:flutter/material.dart';

class PokemonDetails extends StatefulWidget {
  final String pokemonId;

  const PokemonDetails({Key? key, required this.pokemonId}) : super(key: key);

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}