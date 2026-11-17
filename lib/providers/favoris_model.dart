import 'package:flutter/foundation.dart';
import '../models/destination.dart';

///favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};
  // TODO estFavori(Destination d) -> bool
  bool estFavori(Destination d) {
    return _favoris.containsKey(d.id);
  }
  //TODO getter liste : List<Destination> liste exposée est en lecture seule(unmodifiable)
  List<Destination> get liste => List.unmodifiable(_favoris.values);
  // TODO getter nombre
  int get nombre => _favoris.length;
  // TODO basculer(Destination d) : ajoute ou retire,
  bool basculer(Destination d) {
    final bool ajoute;
    if (estFavori(d)) {
      _favoris.remove(d.id);
      ajoute = false;
    } else {
      _favoris[d.id] = d;
      ajoute = true;
    }
    notifyListeners();
    return ajoute;
  }
  //previent les écouteurs , renvoie true si ajouté

  



}