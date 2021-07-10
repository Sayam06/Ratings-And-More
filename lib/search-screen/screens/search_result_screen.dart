import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movies_and_more/home-screen/widgets/movie_thumbnail.dart';
import 'package:movies_and_more/intro-screen/intro_screen.dart';
import 'package:movies_and_more/search-screen/screens/widgets/search_results_thumbnails.dart';

class SearchResultScreen extends StatefulWidget {
  static const routeName = "/search-results";

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  late String search;
  late Map movieResults;
  late Map showResults;
  bool isLoading = true;
  int counter = 0;
  int nullChecker = 0;

  Future getData(String search) async {
    setState(() {
      isLoading = true;
    });

    String finalSearch = search.replaceAll(" ", "%20");
    String searchMovieUrl = "https://api.themoviedb.org/3/search/movie?api_key=357b5ea89158dc578395d5e4ed78f3bf&language=en-US&query=" + finalSearch + "&page=1&include_adult=false";
    String searchShowUrl = "https://api.themoviedb.org/3/search/tv?api_key=357b5ea89158dc578395d5e4ed78f3bf&language=en-US&query=" + finalSearch + "&page=1&include_adult=false";

    http.Response response1 =
        await http.get(Uri.parse(searchMovieUrl), headers: {"Accept": "application/json"});
    movieResults = json.decode(response1.body);

    http.Response response2 =
        await http.get(Uri.parse(searchShowUrl), headers: {"Accept": "application/json"});
    showResults = json.decode(response2.body);

    check(movieResults, showResults);

    setState(() {
      isLoading = false;
    });
  }

  void check(var mov, var tv) {
    if(mov["results"].length == 0 && tv["results"].length == 0) {
      nullChecker = 1;
    }
  }

  @override
  Widget build(BuildContext context) {

    var c = MediaQuery.of(context).size.width;

    counter++;
    final route = ModalRoute.of(context);

    if(counter == 1){
    Future.delayed(const Duration(seconds: 20), () {
          if(isLoading == true) {
            Navigator.of(context).pushReplacementNamed(IntroScreen.routeName);
          }
        });}

    if(route == null)
      return SizedBox(height: 1);
    else {
      final routeArgs = route.settings.arguments as Map<String, dynamic>;
      search = routeArgs["search"];
      if(counter == 1) {
        getData(search);
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: isLoading ? Center(child: SpinKitWave(color: Color.fromRGBO(236, 214, 98, 1), size: 0.127 * c,),)
      : SafeArea(
        child: nullChecker == 0 ? Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      Container(
                        height: 0.12192 * c,
                        width: 0.8128 * c,
                        margin: EdgeInsets.only(top: 0.0381 * c, left: 0.0254 * c, right: 0.0254 * c),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Text("Showing results for \"" + search + "\":", 
                          style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04572 * c, color: Colors.white),
                          ),
                        )
                      ),
                  ],
                ),
                  SizedBox(
                    height: 0.0508 * c,
                  ),
                  movieResults["results"].length != 0 ? Container(
                    margin: EdgeInsets.only(left: 0.0254 * c),
                    child: Text("Movies:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, fontWeight: FontWeight.bold , color: Color.fromRGBO(236, 214, 98, 1),),)
                  ) : SizedBox(height: 1),
                  movieResults["results"].length != 0 ? Container(
                    margin: EdgeInsets.only(top: 0.0508 * c),
                    height: 0.81 * c,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext ctx, index) {
                        return movieResults["results"][index]["poster_path"] != null ? SearchResultsThumbnail(movieResults["results"][index], "movie", c) : SizedBox();
                      },
                      itemCount: movieResults["results"].length,
                    ),
                  ) : SizedBox(height: 1,),

                  showResults["results"].length != 0 ? Container(
                    margin: EdgeInsets.only(left: 0.0254 * c, top: 0.127 * c),
                    child: Text("TV Shows:", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, fontWeight: FontWeight.bold , color: Color.fromRGBO(236, 214, 98, 1),),)
                  ) : SizedBox(height: 1),
                  showResults["results"].length != 0 ? Container(
                    margin: EdgeInsets.only(top: 0.0508 * c),
                    height: 0.81 * c,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext ctx, index) {
                        return showResults["results"][index]["poster_path"] != null ? SearchResultsThumbnail(showResults["results"][index], "show", c) : SizedBox();
                      },
                      itemCount: showResults["results"].length,
                    ),
                  ) : SizedBox(height: 1,),
                  SizedBox(
                    height: 0.127 * c,
                  )
              ],
            )
          )
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.only(top: 0.0381 * c, left: 0.0254 * c),
                child: Icon(Icons.arrow_back_ios,
                 color: Colors.white,
                 ),
                ),
              ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 0.508 * c),
                child: Text("Sorry, no results found :(", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 214, 98, 1)))
              )
            ),
          ],
        ),
      )
    );
  }
}