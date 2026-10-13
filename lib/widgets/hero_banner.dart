import 'package:flutter/material.dart';
import '../models/destination.dart';
 
class HeroBanner extends StatelessWidget {
  final Destination destination;
 
  const HeroBanner({super.key, required this.destination});
 
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Couche 1 : l'image
            Image.asset(destination.image, fit: BoxFit.cover),
 
            // Couche 2 : dégradé pour la lisibilité du texte blanc
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            Positioned(
              top:16,
              right:16,
              child:Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration:BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize:MainAxisSize.min,
                  children:[
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(destination.note.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ])
              )
            ),
            Positioned(
              left:20,
              right:20,
              bottom:20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DESTINATION DU MOIS', style: const TextStyle(fontSize: 11, color:Colors.white70)),
                  Text(destination.nom, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.white)),
                  Text(destination.region, style: const TextStyle(fontSize: 14, color:Colors.white70)),
                ]
              )
            ),
            Positioned(
              right: 16,
              bottom:20,
              child:FilledButton(onPressed: () {}, child: const Text('Découvrir')),
            )
          ],
        ),
      ),
    );
  }
}
