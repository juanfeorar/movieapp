import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/movieModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

const baseUrl = 'https://api.themoviedb.org/3/movie/';
const baseImagesUrl = 'https://image.tmdb.org/t/p/';
const apiKey = 'ace5ac76878db79c329fc58b4ff0800f';
const nowPlayingUrl = '${baseUrl}now_playing?api_key=$apiKey';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Miovie App',
    theme: ThemeData.dark(),
    home: MovieApp()));

class MovieApp extends StatefulWidget {
  @override
  _MovieApp createState() => new _MovieApp();
}

class _MovieApp extends State<MovieApp> {
  Movie nowPlayingMovies;

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
  }

  void _fetchNowPlayingMovies() async {
    var response = await http.get(nowPlayingUrl);
    var decodeJson = jsonDecode(response.body);

    setState(() {
      var nowPlayingMovies = Movie.fromJson(decodeJson);
    });
  }

  Widget _buildCarouselSlider() => CarouselSlider(
        items: nowPlayingMovies.results
            .map((movieItem) =>
                Image.network("${baseImagesUrl}w342${movieItem.posterPath}"))
            .toList(),
        autoPlay: false,
        height: 240.0,
        viewportFraction: 0.5,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Movies App',
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "NOW PLAYING",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                expandedHeight: 290.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          "${baseImagesUrl}w500/5Kg76ldv7VxeX9YlcQXiowHgdX6.jpg",
                          fit: BoxFit.cover,
                          width: 1000.0,
                          colorBlendMode: BlendMode.dstATop,
                          color: Colors.blue.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Column(
                          children: nowPlayingMovies == null
                              ? <Widget>[
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                ]
                              : <Widget>[_buildCarouselSlider()],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ];
          },
          body: Text("scroll me!")),
    );
  }
}

//minutos 40 explica lo que se hizo
