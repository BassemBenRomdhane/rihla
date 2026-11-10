import 'package:flutter/material.dart';
import 'package:rihla/widgets/SectionTitle.dart';
import 'package:rihla/widgets/ErreurReseau.dart';
import 'package:rihla/widgets/hero_banner.dart';
import 'package:rihla/widgets/home_header.dart';
import 'package:rihla/widgets/search_box.dart';
import 'package:rihla/widgets/destination_card.dart';
import '../services/api_service.dart';
import '../data/destinations.dart';
import '../models/destination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;
  late Future<List<Destination>> _futurDestinations;// On utilise late parce que la variable sera initialisee plus tard,
  @override
  void initState(){
    super.initState();
    _futurDestinations = ApiService.getDestinations();
  }
  Future<void> _recharger() async {
  final futur = ApiService.getDestinations();
  setState(() {
    _futurDestinations = futur;   // FutureBuilder écoute le nouveau Future
  });
  try {
    await futur;                  // RefreshIndicator attend la fin
  } catch (_) {}                  // l'erreur est affichée par FutureBuilder
}
 


  List<Destination> _filtrer(List<Destination> toutes)=> _categorie == 'Tout'
      ? toutes
      : toutes.where((d) => d.categorie == _categorie).toList();
  Widget _construireExplorer(){
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError){//l'application ne gère pas correctement
          return ErreurReseau(
            message: 'Erreur : ${snapshot.error}',
            onReessayer: _recharger,
          );
        }
        final destinations = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _recharger,
          child: _construireAccueil(destinations),
        );
      },
    );
  }

  Widget _construireAccueil(List<Destination> destinations) {
    final _filtrees = _filtrer(destinations);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(), // pour que RefreshIndicator fonctionne même si la liste est courte
      padding: const EdgeInsets.all(20),
      children: [
        const HomeHeader(prenom: 'Bassem'),
        const SizedBox(height: 20),
        const SearchBox(),
        const SizedBox(height: 20),
        HeroBanner(destination: destinations.first),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Catégories'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: _categorie == c, // Le filtrage se fait localement sur la liste déjà récupérée.
                    onSelected: (_) {
                      setState(() {
                        _categorie = c;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          title: 'Populaires',
          action: 'Voir tout',
        ),
        const SizedBox(height: 12),
        for (final d in _filtrees)
          DestinationCard(destination: d),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      body: SafeArea(
        child: _onglet == 0
            ? _construireExplorer()
            : const Center(child: Text('Bientôt disponible')),
      ),
    );
  }
}