import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  /**
   * Contenerdor PageView Horizontal donde seran
   * renderizadas las tarjetas
   */
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    /**
     * addListener se ejecuta cada vez que el scroll horizontal se active
     */
    _pageController.addListener(() {
      /**
       * Detectamos en que posision se encuentra del _pageController, si esta llegando al final
       * ejecutamos la funcion para cargar la siguiente página
       */
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        // print("Cargar siguientes peliculas");
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.30,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, int i) {
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    /**
    * Este uniqueHeroId se usa unicamente para generar un id que no se repita y sea usado
    * en la animacion HeroAnimation el tag "-footer" distingue el id de las peliculas en el footer
    */
    pelicula.uniqueHeroId = "${pelicula.id}-footer";

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueHeroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.obtenerPoster()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "detalle", arguments: pelicula);
        print("Nombre de la pelicula:  ${pelicula.title}");
      },
      child: tarjeta,
    );
  }

// /**
//  * Tarjetas individuales (Se usaban en el PageView dentro del children pero sin el builder)
//  */
//   List<Widget> _tarjetas(BuildContext context) {
//     return peliculas.map((pelicula) {
//       return Container(
//         margin: EdgeInsets.only(right: 15.0),
//         child: Column(
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20.0),
//               child: FadeInImage(
//                 image: NetworkImage(pelicula.obtenerPoster()),
//                 placeholder: AssetImage('assets/img/no-image.jpg'),
//                 fit: BoxFit.cover,
//                 height: 160.0,
//               ),
//             ),
//             SizedBox(height: 5.0),
//             Text(
//               pelicula.title,
//               overflow: TextOverflow.ellipsis,
//               style: Theme.of(context).textTheme.caption,
//             )
//           ],
//         ),
//       );
//     }).toList();
//   }
}
