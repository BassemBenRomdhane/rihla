import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/reservation.dart';
import '../config/api_config.dart';
import '../models/destination.dart';

class ApiService {
  static Uri _url(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');

  static const _cleCache = 'cache_destinations';
  static bool depuisCache = false;
  static List<Destination> _decoder(String corps) =>
      (jsonDecode(corps) as List).map((e) => Destination.fromJson(e)).toList();
  static Future<List<Destination>> getDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final reponse = await http
          .get(_url('/destinations'))
          .timeout(ApiConfig.timeout);
      if (reponse.statusCode != 200) {
        throw Exception('Erreur ${reponse.statusCode}');
      }
      final corps = utf8.decode(reponse.bodyBytes);
      // TODO 4 : mémoriser corps sous la clé _cleCache
      await prefs.setString('cache_destinations', corps);
      depuisCache = false;
      return _decoder(corps);
    } catch (e) {
      final cache = prefs.getString('cache_destinations');
      // TODO 5 : lire le cache ; s'il est null, relancer l'erreur (rethrow)
      if (cache==null) rethrow;
      // TODO 6 : sinon, signaler depuisCache = true et décoder le cache
      depuisCache = true;
      return _decoder(cache);
      
      
    }
  }

  static Future<String> creerReservation(Reservation reservation) async {
    final reponse = await http
        .post(
          _url('/reservations'),
          headers: {'Content-Type': 'application/json'}, // sans Content-Type, le serveur ne comprend pas que c'est du JSON donc la réservation est vide.
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 201) {
      throw Exception('Erreur HTTP ${reponse.statusCode}');
    }
    final Map<String, dynamic> creee = jsonDecode(
      utf8.decode(reponse.bodyBytes),
    );
    return creee['id'].toString(); // l'id attribué par le serveur
  }
  
}
