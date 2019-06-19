//Modulo decode y encoded JSON
import 'dart:convert';
//Modulo que contienes los Streams
import 'dart:async';
//Modulo htttp Dart
import 'package:http/http.dart' as http;

//Modelo/Clase de los actores
import 'package:peliculas/src/models/actores_model.dart';

//Modelo/Clase de las peliculas
import 'package:peliculas/src/models/pelicula_model.dart';

/**
 * Contiene la direccion de la api y la llave para obtener datos
 */
class PeliculasProvider {
  String _apikey = '960cd41c54b8a4be9470f56a78a8315e';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  /** 
   * Sream Controller de la lista de peliculas
   */
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  /**
   * Cerrar los streams
   */
  void disposeStreams() {
    _popularesStreamController?.close();
  }

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
    if (_cargando) {
      return [];
    }

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _lenguage,
      'page': _popularesPage.toString()
    });

    final res = await _procesarRespuesta(url);

    _populares.addAll(res);
    popularesSink(_populares);

    _cargando = false;
    return res;
  }

  /**
   * Obtiene el arreglo de actores de una pelicula por ID
   */
  Future<List<Actor>> obtenerActores(String id_pelicula) async {
    final url = Uri.https(_url, '3/movie/$id_pelicula/credits', {
      'api_key': _apikey,
      'language': _lenguage,
    });

    //Json raw string
    final res = await http.get(url);

    //Objeto/Mapa del json
    final decodedData = json.decode(res.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  /**
 * Obtiene las un arreglo de peliculas que concidan con el query que manda el 
 * usuario en el buscador
 */
  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'language': _lenguage,
      'query': query,
    });

    return await _procesarRespuesta(url);
  }
}
