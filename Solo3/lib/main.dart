// Part A: Imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Part B: Model class for Pokémon
class Pokemon {
  final int id;
  final String name;
  final String? sprite;

  const Pokemon({required this.id, required this.name, this.sprite});

  factory Pokemon.fromJson(Map<String, dynamic> j) {
    return Pokemon(
      id: j['id'] as int,
      name: j['name'] as String,
      sprite: j['sprites']?['front_default'] as String?,
    );
  }
}

// Part C: Fetch function
Future<List<Pokemon>> fetchPokemon() async {
  final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151');
  final res = await http.get(uri).timeout(const Duration(seconds: 10));

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final List results = data['results'] as List;

    final detailFutures = results.map((r) async {
      final detailRes = await http.get(Uri.parse(r['url']));
      if (detailRes.statusCode == 200) {
        return Pokemon.fromJson(jsonDecode(detailRes.body));
      } else {
        throw Exception("Failed to load Pokémon details");
      }
    });

    return await Future.wait(detailFutures);
  } else {
    throw Exception('Failed to load Pokémon list (HTTP ${res.statusCode})');
  }
}

// Part D: Main entry point
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Pokemon>> _futurePokemon;

  @override
  void initState() {
    super.initState();
    _futurePokemon = fetchPokemon();
  }

  void _refresh() {
    setState(() {
      _futurePokemon = fetchPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Cards Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pokémon Cards'),
          actions: [
            IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: FutureBuilder<List<Pokemon>>(
          future: _futurePokemon,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Skeleton loader
              return ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => _buildSkeletonCard(),
              );
            } else if (snapshot.hasError) {
              // Error state with retry
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final pokemon = snapshot.data!;
              return ListView.builder(
                itemCount: pokemon.length,
                itemBuilder: (context, i) {
                  final p = pokemon[i];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: p.sprite != null
                          ? Image.network(p.sprite!, width: 56, height: 56)
                          : CircleAvatar(child: Text('${p.id}')),
                      title: Text(
                        p.name[0].toUpperCase() + p.name.substring(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID: ${p.id}'),
                    ),
                  );
                },
              );
            } else {
              // Empty state (edge case)
              return const Center(child: Text("No Pokémon found."));
            }
          },
        ),
      ),
    );
  }

  // Part E: Skeleton card
  Widget _buildSkeletonCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        title: Container(
          height: 16,
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        subtitle: Container(
          height: 12,
          color: Colors.grey.shade200,
          margin: const EdgeInsets.symmetric(vertical: 4),
        ),
      ),
    );
  }
}
