import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'https://image.tmdb.org/t/p/w500//zIYROrkHJPYB3VTiW1L9QVgaQO.jpg',
  'https://image.tmdb.org/t/p/w500//1X7vow16X7CnCoexXh4H4F2yDJv.jpg',
  'https://image.tmdb.org/t/p/w500//k1KrbaCMACQiq7EA0Yhw3bdzMv7.jpg',
  'https://image.tmdb.org/t/p/w500//oqbcmZJJ1EWkOPiGjqABaUN18rI.jpg',
  'https://image.tmdb.org/t/p/w500//feSiISwgEpVzR1v3zv2n2AU4ANJ.jpg',
  'https://image.tmdb.org/t/p/w500//z6OkT7XjzSrgstiTlld0jUvME9y.jpg',
];

class HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(seconds: 3),
        ),
        items: imageSliders,
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map(
      (item) => Container(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.30), BlendMode.dstATop),
                      image: NetworkImage(item)),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF121212),
                      Color(0x11121212),
                      Color(0x11121212),
                      Color(0xFF121212)
                      // Color(0xFF201B17),
                      // Color(0x11201B17),
                      // Color(0x11201B17),
                      // Color(0xFF201B17),
                    ],
                    stops: [0, 0.4, 0.6, 1],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    .toList();
