import 'dart:convert';
 
import 'package:http/http.dart' as http;
 
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
}

