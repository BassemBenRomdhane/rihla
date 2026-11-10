import 'dart:convert';
 
import 'package:http/http.dart' as http;
import '../models/reservation.dart';
import '../config/api_config.dart';
import '../models/destination.dart';
class ApiService {
  static Uri _url(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');
 
  static Future<List<Destination>> getDestinations() async { // on utilise future car le programme doit attendre la réponse du serveur avant de continuer
    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);
    if (reponse.statusCode !=200){
      throw Exception('Erreur HTTP ${reponse.statusCode}');
    }
    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));
    return liste.map((e) => Destination.fromJson(e)).toList();
  }
  static Future<String> creerReservation(Reservation reservation) async {
  final reponse = await http
      .post(
        _url('/reservations'),
        headers: {'Content-Type': 'application/json'},// sans Content-Type, le serveur ne comprend pas que c'est du JSON donc la réservation est vide.
        body: jsonEncode(reservation.toJson()),
      )
      .timeout(ApiConfig.timeout);
 
  if (reponse.statusCode != 201) {
    throw Exception('Erreur HTTP ${reponse.statusCode}');
  }
  final Map<String, dynamic> creee = jsonDecode(utf8.decode(reponse.bodyBytes));
  return creee['id'].toString();   // l'id attribué par le serveur
}

}

