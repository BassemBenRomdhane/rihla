import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:rihla/models/destination.dart';
import 'package:rihla/providers/favoris_model.dart';

class FavoriteButton extends StatelessWidget {
  final Destination destination;
  const FavoriteButton({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    // TODO : lire l'etat avec context.watch<FavorisModel>()
    final favorisModel = context.watch<FavorisModel>().estFavori(destination);
    // TODO : IconButton : coeur plein ou vide
    return IconButton(
      icon: Icon(
        favorisModel ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
    //todo OnPressed : context.read<FavorisModel>().basculer(destination)
    onPressed: () {
        context.read<FavorisModel>().basculer(destination);
      },
    );

    
    
  }
}
