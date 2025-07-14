import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokepedia/screens/pokemon_detals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pokepedia = [];

  final String pokepediaAPI =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  void fetchData() async {
    try {
      final response = await http.get(Uri.parse(pokepediaAPI));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          pokepedia = data['pokemon'];
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              "assets/images/pokeball.png",
              width: 250,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 90,
            left: 15,
            child: Text(
              "Poke'pedia",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: pokepedia.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: pokepedia.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokepedia[index];
                      final type = pokemon['type'][0];
                      final id = pokemon['id'];

                      final bgColor = {
                            "Grass": Colors.green[200],
                            "Fire": Colors.red[200],
                            "Water": Colors.blue[200],
                            "Electric": Colors.yellow[200],
                            "Psychic": Colors.purple[200],
                            "Ice": Colors.cyan[200],
                            "Rock": Colors.brown[200],
                            "Ground": Colors.orange[200],
                            "Fairy": Colors.pink[200],
                            "Fighting": Colors.deepOrange[200],
                            "Poison": Colors.purple[100],
                            "Bug": Colors.lightGreen[200],
                            "Normal": Colors.grey[200],
                            "Ghost": Colors.indigo[200],
                            "Steel": Colors.blueGrey[200],
                            "Dark": Colors.black87,
                            "Dragon": Colors.deepPurple[200],
                          }[type] ?? Colors.grey;

                      return InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: bgColor,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: Image.asset(
                                  "assets/images/pokeball.png",
                                  width: 100,
                                  fit: BoxFit.fitHeight,
                                  opacity: const AlwaysStoppedAnimation(.8),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pokemon['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        type,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Expanded(
                                      child: Center(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
                                          height: 120,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error_outline,
                                                  size: 40),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PokeDetails(
                                tag: index,
                                color: bgColor,
                                pokedetails: pokepedia[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}