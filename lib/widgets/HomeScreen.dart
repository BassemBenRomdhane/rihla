import 'package:flutter/material.dart';
import 'package:rihla/widgets/SectionTitle.dart';

import 'package:rihla/widgets/hero_banner.dart';
import 'package:rihla/widgets/home_header.dart';
import 'package:rihla/widgets/search_box.dart';
import 'package:rihla/widgets/destination_card.dart';

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

  List<Destination> get _filtrees {
    if (_categorie == 'Tout') {
      return destinations;
    } else {
      return destinations.where((d) => d.categorie == _categorie).toList();
    }
  }

  Widget _construireAccueil() {
    return ListView(
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
                    selected: _categorie == c,
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
            ? _construireAccueil()
            : const Center(child: Text('Bientôt disponible')),
      ),
    );
  }
}