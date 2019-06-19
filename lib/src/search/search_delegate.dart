import 'package:flutter/material.dart';
/**
 * Clase pelicula
 */
import 'package:peliculas/src/models/pelicula_model.dart';
/**
 * Servicio de peliculas
 */
import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Batman',
    'Titanic',
    'Spirit',
    'La bella y la bestia',
    'Dumbo',
    'Toy Story'
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America', 'Shazam'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Lo que aparece al inicio (Un icono a la izquierda del appbar en este caso)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que se mostraran
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  // Sugerencias que aparecen cuando la perosna escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final peliculas = snapshot.data;
            return ListView(
              children: peliculas.map((pelicula) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.obtenerPoster()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 60.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    close(context, null);
                    //Para prevenir que el uniqueHeroId no de error en la pagina
                    // detalle, lo seteamos vacio
                    pelicula.uniqueHeroId = '';
                    Navigator.pushNamed(context, 'detalle',
                        arguments: pelicula);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }

    // final listaSugerida = (query.isEmpty)
    //     ? peliculasRecientes
    //     : peliculas.where((p) {
    //         return p.toLowerCase().startsWith(query.toLowerCase());
    //       }).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: () {
    //         seleccion = listaSugerida[i];
    //         showResults(context);
    //       },
    //     );
    //   },
    // );
  }
}
