
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
  List<Destination> get _filtrees {
    if (_categorie == 'Tout') {
      return destinations;
    } else {
      return destinations.where((d) => d.categorie == _categorie).toList();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SearchBox(),
            const SizedBox(height: 20),
            const HomeHeader(prenom: 'Bassem'),
            const SizedBox(height: 20),
            HeroBanner(destination: destinations.first),
            const SizedBox(height: 24),
            const SectionTitle(
              title: 'Catégories',
            ),
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
                      selected:_categorie == c, // TODO 2 : vrai seulement pour la catégorie choisie
                      onSelected: (_) {
                        setState(() {
                          _categorie = c;
                        });
                        // TODO 3 : mémoriser c dans _categorie avec setState
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
        ),
      ),
    );
  }
}