//Modulo decode y encoded JSON
import 'dart:convert';
//Modulo htttp Dart
import 'package:http/http.dart' as http;

//Modelo/Clase de las peliculas
import 'package:peliculas/src/models/pelicula_model.dart';

/**
 * Contiene la direccion de la api y la llave para obtener datos
 */
class PeliculasProvider {
  String _apikey = '960cd41c54b8a4be9470f56a78a8315e';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  /**
   * Transofmra la respuesta en un arreglo
   */
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
//Obtiene la respuesta del servidor
    final res = await http.get(url);
    //Transforma la data a JSON Plano
    final jsonData = json.decode(res.body);

    final peliculas = new Peliculas.fromJsonList(jsonData['results']);

    return peliculas.items;
  }

  /**
 * Obtiene las un arreglo de peliculas que se encuentran en cartelera
 */
  Future<List<Pelicula>> obtenerCartelera() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _lenguage,
    });

    return await _procesarRespuesta(url);
  }

  /**
 * Obtiene las un arreglo de peliculas más populares
 */
  Future<List<Pelicula>> obtenerPopulares() async {
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _lenguage,
    });

    return await _procesarRespuesta(url);
  }
}
