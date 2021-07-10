import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:movies_and_more/home-screen/widgets/movie_thumbnail.dart';
import 'package:movies_and_more/intro-screen/intro_screen.dart';

class TvDetailsScreen extends StatefulWidget {
  static const routeName = "/tv-details";

  @override
  _TvDetailsScreenState createState() => _TvDetailsScreenState();
}

class _TvDetailsScreenState extends State<TvDetailsScreen> {
  int counter = 0;
  late String id;
  bool isLoading = true;
  String productionCompanies = "";
  String productionCountries = "";
  String genres = "";
  String castName = "";
  String availableOn = "";

  late Map movie;
  late Map cast;
  late Map recommendedMovies;
  late Map similarMovies;

  

  Future getData(String id) async {
    setState(() {
      isLoading = true;
    });

    String movieDataUrl = "https://api.themoviedb.org/3/tv/" + id + "?api_key={key}&language=en-US";
    String castDataUrl = "https://api.themoviedb.org/3/tv/" + id + "/credits?api_key={key}&language=en-US";
    String recommendedMoviesUrl = "https://api.themoviedb.org/3/tv/" + id + "/recommendations?api_key={key}&language=en-US&page=1";
    String similarMoviesUrl = "https://api.themoviedb.org/3/tv/" + id + "/similar?api_key={key}&language=en-US&page=1";

    http.Response response1 =
        await http.get(Uri.parse(movieDataUrl), headers: {"Accept": "application/json"});
    movie = json.decode(response1.body);

    http.Response response2 =
        await http.get(Uri.parse(castDataUrl), headers: {"Accept": "application/json"});
    cast = json.decode(response2.body);

    http.Response response3 =
        await http.get(Uri.parse(recommendedMoviesUrl), headers: {"Accept": "application/json"});
    recommendedMovies = json.decode(response3.body);

    http.Response response4 =
        await http.get(Uri.parse(similarMoviesUrl), headers: {"Accept": "application/json"});
    similarMovies = json.decode(response4.body);

    setState(() {
      isLoading = false;
    });

    getProductionCompanies(movie);
    getGenres(movie);
    getProductionCountries(movie);
    getCast(cast);
    getAvailableOn(movie);
    //print(movie);
  }

  void getAvailableOn(var mov) {
    for(int i = 0; i < mov["networks"].length; i++) {
      availableOn = availableOn + mov["networks"][i]["name"];
      if(i != mov["networks"].length - 1) {
        availableOn = availableOn + ", ";
      }
    }
  }

  void getCast(var mov) {
    for(int i = 0; i < mov["cast"].length; i++) {
      castName = castName + mov["cast"][i]["name"];
      if(i != mov["cast"].length - 1) {
        castName = castName + ", ";
      }
    }
  }

  void getProductionCompanies(var mov) {
    for(int i = 0; i < mov["production_companies"].length; i++) {
      productionCompanies = productionCompanies + mov["production_companies"][i]["name"];
      if(i != mov["production_companies"].length - 1) {
        productionCompanies = productionCompanies + ", ";
      }
    }
  }

  void getGenres(var mov) {
    for(int i = 0; i < mov["genres"].length; i++) {
      genres = genres + mov["genres"][i]["name"];
      if(i != mov["genres"].length - 1) {
        genres = genres + ", ";
      }
    }
  }

  void getProductionCountries(var mov) {
    for(int i = 0; i < mov["production_countries"].length; i++) {
      productionCountries = productionCountries + mov["production_countries"][i]["name"];
      if(i != mov["production_countries"].length - 1) {
        productionCountries = productionCountries + ", ";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    counter++;

    if(counter == 1){
    Future.delayed(const Duration(seconds: 20), () {
          if(isLoading == true) {
            Navigator.of(context).pushReplacementNamed(IntroScreen.routeName);
          }
        });}

    var c = MediaQuery.of(context).size.width;
    final route = ModalRoute.of(context);

    if(route == null)
      return SizedBox(height: 1);
    else {
      final routeArgs = route.settings.arguments as Map<String, dynamic>;
      id = routeArgs["id"]!.toString();
      if(counter == 1) {
        getData(id);
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: isLoading ? Center(child: SpinKitWave(color: Color.fromRGBO(236, 214, 98, 1), size: 0.127 * c,),)
      : movie.isEmpty ? Center(child: Text("Please check your internet!", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 214, 98, 1))))
      : SafeArea(
          child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0381 * c, left: 0.0254 * c),
                    child: Icon(Icons.arrow_back_ios ,
                    color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.0508 * c,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 0.0508 * c),
                      height: 0.635 * c,
                      child: Image(
                        image: NetworkImage("https://image.tmdb.org/t/p/w342" + movie["poster_path"]),
                        fit: BoxFit.fill,
                      )
                    ),
                    Container(
                      width: 0.4572 * c,
                      padding: EdgeInsets.only(left: 0.0508 * c),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(child: Text("Name:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                          Container(
                            child: Text(movie["name"], style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0.0127 * c),
                            child: Text("First Air:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                          Container(
                            child: Text(movie["first_air_date"], style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                          ),
                          
                          Container(
                            margin: EdgeInsets.only(top: 0.0127 * c),
                            child: Text("Rating:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                          Container(
                            child: Text(movie["vote_average"].toString() + " ⭐", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                          ),
                          

                          Container(
                            margin: EdgeInsets.only(top: 0.0127 * c),
                            child: Text("Type:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                          Container(
                            child: Text(movie["type"].toString(), style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                          ),
                        ]
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Overview:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(movie["overview"], style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),

                Container(
                  margin: EdgeInsets.only(top: 0.0508 * c, left: 0.0254 * c),
                  child: Text("Status:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c),
                  child: Text(movie["status"].toString(), style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                  ),
                    
                Container(
                  margin: EdgeInsets.only(top: 0.0508 * c, left: 0.0254 * c),
                  child: Text("Available On:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c),
                  child: Text(availableOn, style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                  ),
                    
                Container(
                  margin: EdgeInsets.only(top: 0.0508 * c, left: 0.0254 * c),
                  child: Text("Number of Seasons:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c),
                  child: Text(movie["number_of_seasons"].toString(), style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                  ),
                  
                Container(
                  margin: EdgeInsets.only(top: 0.0508 * c, left: 0.0254 * c),
                  child: Text("Number of Episodes:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c),
                  child: Text(movie["number_of_episodes"].toString(), style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                  ),

                movie["last_air_date"] != "" ? Container(
                  margin: EdgeInsets.only(top: 0.0508 * c, left: 0.0254 * c),
                  child: Text("Last Aired:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold)))
                  : SizedBox(height: 1,),
                  movie["last_air_date"] != "" ? Container(
                    margin: EdgeInsets.only(left: 0.0254 * c),
                    child: Text(movie["last_air_date"].toString(), style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                    ) : SizedBox(height: 1,),
                
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Genres:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(genres, style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),

                

                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Original Language:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(movie["original_language"], style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),
                
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Original Name:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(movie["original_name"], style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),

                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Cast:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(castName, style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),

                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Production Companies:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(productionCompanies, style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.0508 * c),
                  child: Text("Production Countries:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold))),
                Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, right: 0.0254 * c),
                  child: Text(productionCountries, style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04064 * c, color: Colors.white, fontWeight: FontWeight.w300))
                ),
                recommendedMovies["results"].length != 0 ? Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.127 * c),
                  child: Text("Recommended Shows:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold)))
                  : SizedBox(height: 1),
                recommendedMovies["results"].length != 0 ? Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(recommendedMovies["results"][index], c);
                  },
                  itemCount: recommendedMovies["results"].length,
                ),
              ) : SizedBox(height: 1,),
              similarMovies["results"].length !=0 ? Container(
                  margin: EdgeInsets.only(left: 0.0254 * c, top: 0.127 * c),
                  child: Text("Similar Shows:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Color.fromRGBO(236, 214, 98, 1), fontWeight: FontWeight.bold)))
                  : SizedBox(height: 1,),
                similarMovies["results"].length !=0 ? Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(similarMovies["results"][index], c);
                  },
                  itemCount: similarMovies["results"].length,
                ),
              ) : SizedBox(height: 1,),
              SizedBox(
                height: 0.254 * c,
              )
              ],
            )
          ),
        ),
      )
    );
  }
}
