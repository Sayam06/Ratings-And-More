import 'package:flutter/material.dart';
import 'package:movies_and_more/movie-details-screen/screens/movie_details_screen.dart';
import 'package:movies_and_more/tv-details-screen/screens/tv_details_screen.dart';

class MovieThumbnail extends StatelessWidget {
  final Map movie;
  var c;

  MovieThumbnail(
    this.movie,
    this.c,
  );

  late String name;
  late String imageUrl;
  late String date;

  @override
  Widget build(BuildContext context) {

    if(movie["title"] == null){
    name = movie["name"];
    } else {
    name = movie["title"];
    }

    if(movie["first_air_date"] == null) {
      date = movie["release_date"].substring(0,4);
    } else {
      date = movie["first_air_date"].substring(0,4);
    }

    imageUrl = "https://image.tmdb.org/t/p/w342" + movie["poster_path"];

    return GestureDetector(
      onTap: () {
        if(movie["media_type"] == "movie") {
        Navigator.of(context).pushNamed(MovieDetailsScreen.routeName, arguments: {
          "id": movie["id"]
          });
          } else {
            Navigator.of(context).pushNamed(TvDetailsScreen.routeName, arguments: {
              "id": movie["id"]
            });
          }
        }, 
        child: Container(
        width: 0.47752 * c,
        margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 0.55 * c,//0.7112 * c,
              width: 0.47752 * c,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fitWidth,
                ),
              )
            ),
            Container(
              width: 0.47752 * c,
              height: 0.254 * c,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              ),
              padding: EdgeInsets.only(top: 0.0508 * c, left: 0.0254 * c, right: 0.0254 * c, bottom: 0.0254 * c),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Text(name + " (" + date + ")", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04572 * c, color: Colors.white),)),
            ),
          ]
        )
      ),
    );
  }
}