// affiche les destinations favorites de l'utilisateur avec DestinationCard ou auncun favoris pour le moement
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:rihla/providers/favoris_model.dart';
import 'package:rihla/widgets/destination_card.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO : lire la liste des favoris avec context.watch<FavorisModel>()
    final favorisModel = context.watch<FavorisModel>();
    final favoris = favorisModel.liste;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: favoris.isEmpty
          ? const Center(
              child: Text('Aucun favori pour le moment.'),
            )
          : ListView.builder(
              itemCount: favoris.length,
              itemBuilder: (context, index) {
                final destination = favoris[index];
                return DestinationCard(destination: destination);
              },
            ),
    );
  }
}