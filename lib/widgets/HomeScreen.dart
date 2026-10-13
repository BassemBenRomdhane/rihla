import 'package:flutter/material.dart';
import 'package:rihla/widgets/hero_banner.dart';
import 'package:rihla/widgets/home_header.dart';
import 'package:rihla/widgets/search_box.dart';
import '../data/destinations.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
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
            HeroBanner(destination: destinations.first)
          ],
        ),
      ),
    );
  }
}
