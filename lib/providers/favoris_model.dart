import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:rihla/models/destination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavorisModel extends ChangeNotifier {
  static const _cle = 'favoris';
  final Map<String, Destination> _favoris = {};
  // estFavori, liste, nombre : inchangés (TP6)
  bool estFavori(Destination d) {
    return _favoris.containsKey(d.id);
  }
  List<Destination> get liste => List.unmodifiable(_favoris.values);
  int get nombre => _favoris.length;
  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO 1 : lire la liste de textes (liste vide si rien n'est stocké)
    final textes = prefs.getStringList(_cle) ?? [];
    // TODO 2 : pour chaque texte : jsonDecode puis Destination.fromJson,
    for (final texte in textes) {
      final d = Destination.fromJson(jsonDecode(texte));
      _favoris[d.id] = d;
    }
    // ranger la destination dans _favoris avec son id
    notifyListeners();
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_cle, _favoris.values.map((d) => jsonEncode(d.toJson())).toList());
    // TODO 3 : transformer chaque destination en texte
    // (toJson puis jsonEncode) et l'écrire avec setStringList
  }

  bool basculer(Destination d) {
    final ajoute = _favoris.remove(d.id) == null;
    if (ajoute) _favoris[d.id] = d;
    _sauvegarder(); // TP7 : recopie sur le disque
    notifyListeners();
    return ajoute;
  }
}
