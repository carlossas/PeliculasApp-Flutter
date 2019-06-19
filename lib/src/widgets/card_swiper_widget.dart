import 'package:flutter/material.dart';
//Plugin swiper
import 'package:flutter_swiper/flutter_swiper.dart';
//Clase o modelo pelicula
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: new Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          /**
         * Este uniqueHeroId se usa unicamente para generar un id que no se repita y sea usado
         * en la animacion HeroAnimation el tag "-tarjeta" distingue el id de las peliculas en el footer
         */
          peliculas[index].uniqueHeroId = "${peliculas[index].id}-tarjeta";
          return Hero(
            tag: peliculas[index].uniqueHeroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]);
                },
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].obtenerPoster()),
                  placeholder: AssetImage('assets/img/jar-loading.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
