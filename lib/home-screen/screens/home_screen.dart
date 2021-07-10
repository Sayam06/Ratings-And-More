import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:movies_and_more/home-screen/widgets/movie_thumbnail.dart';
import 'package:movies_and_more/intro-screen/intro_screen.dart';
import 'package:movies_and_more/search-screen/screens/search_result_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Map trendingAllToday;
  late Map trendingMoviesToday;
  late Map trendingShowsToday;
  late Map trendingAllWeek;
  late Map trendingMoviesWeek;
  late Map trendingShowsWeek;
  bool isLoading = true;
  late bool internet;
  int counter = 0;
  
  final searchController = TextEditingController();

  

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    String trendingAllTodayUrl = "https://api.themoviedb.org/3/trending/all/day?api_key=3{key}";
    String trendingMoviesTodayUrl = "https://api.themoviedb.org/3/trending/movie/day?api_key={key}";
    String trendingShowsTodayUrl = "https://api.themoviedb.org/3/trending/tv/day?api_key={key}";
    String trendingAllWeekUrl = "https://api.themoviedb.org/3/trending/all/week?api_key={key}";
    String trendingMoviesWeekUrl = "https://api.themoviedb.org/3/trending/movie/week?api_key={key}";
    String trendingShowsWeekUrl = "https://api.themoviedb.org/3/trending/tv/week?api_key={key}";

    http.Response response1 =
        await http.get(Uri.parse(trendingAllTodayUrl), headers: {"Accept": "application/json"});
    trendingAllToday = json.decode(response1.body);

    http.Response response2 =
        await http.get(Uri.parse(trendingMoviesTodayUrl), headers: {"Accept": "application/json"});
    trendingMoviesToday = json.decode(response2.body);

    http.Response response3 =
        await http.get(Uri.parse(trendingShowsTodayUrl), headers: {"Accept": "application/json"});
    trendingShowsToday = json.decode(response3.body);

    http.Response response4 =
        await http.get(Uri.parse(trendingAllWeekUrl), headers: {"Accept": "application/json"});
    trendingAllWeek = json.decode(response4.body);

    http.Response response5 =
        await http.get(Uri.parse(trendingMoviesWeekUrl), headers: {"Accept": "application/json"});
    trendingMoviesWeek = json.decode(response5.body);

    http.Response response6 =
        await http.get(Uri.parse(trendingShowsWeekUrl), headers: {"Accept": "application/json"});
    trendingShowsWeek = json.decode(response6.body);

    setState(() {
      isLoading = false;
    });
    //print(trendingAll["results"][0]["vote_average"]);
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  void refresh() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {

    counter++;

    Future.delayed(const Duration(seconds: 20), () {
          if(isLoading == true && counter == 1) {
            Navigator.of(context).pushReplacementNamed(IntroScreen.routeName);
          }
        });

    var c = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: isLoading ? Center(child: Container(
        height: 0.381 * c,
        child: Image.asset("assets/images/Logo.png"),
      ))
      : trendingAllWeek == null ? Center(child: Text("Please check your internet connection :(", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 214, 98, 1))))
      : SafeArea(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 0.0254 * c, left: 0.0254 * c), 
                child: Text("Hey!", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.127 * c, color: Colors.white))
              ),
              Container(
                margin: EdgeInsets.only(bottom: 0.0254 * c, left: 0.0254 * c),
                child: Text("What are you planning to watch today?", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.04572 * c, color: Color.fromRGBO(236, 214, 98, 1)))
              ),
              Row(
                children: [
                  Container(
                     padding: EdgeInsets.only(left: 0.0127 * c, right: 0.0127 * c),
                     height: 0.1016 * c,
                     margin: EdgeInsets.only(top: 0.0127 * c, left: 0.0354 * c),
                    width: 0.75 * c,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 0.65 * c,
                          child: Center(
                              child: TextField(
                                onChanged: (_) => refresh(),
                                onSubmitted: (_){
                                  if(searchController.text.isNotEmpty) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if(!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        Navigator.of(context).pushNamed(SearchResultScreen.routeName, arguments: {
                          "search": searchController.text,
                    });
                      }
                                },
                                style: TextStyle(fontFamily: "Montserrat", fontSize: 0.0494 * c,),
                                controller: searchController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 0.0127 * c, top: 0.0127 * c, bottom: 0.03048 * c),
                                    border: InputBorder.none, hintText: "Search Movies / Shows", hintStyle: TextStyle(fontFamily: "Montserrat", fontSize: 0.0494 * c),
                                    ),
                              ),
                          ),
                        ),
                        searchController.text.isNotEmpty ?  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchController.clear();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Icon(Icons.close, color: Colors.grey,)
                    ),
                  ) : SizedBox(),
                      ],
                    ),
                  ),
                  

                  GestureDetector(
                    onTap: (){
                      if(searchController.text.isNotEmpty) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if(!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        Navigator.of(context).pushNamed(SearchResultScreen.routeName, arguments: {
                          "search": searchController.text,
                    });
                      }
                    },
                       child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(236, 214, 98, 1),
                      ),
                      height: 0.1016 * c,
                      width: 0.1524 * c,
                      margin: EdgeInsets.only(top: 0.0127 * c, left: 0.0254 * c),
                      child: Center(child: Text("Go!", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.05588 * c),)),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0762 * c, left: 0.0254 * c),
                child: Text(
                  "Trending Today - All", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Colors.white)
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(trendingAllToday["results"][index], c);
                  },
                  itemCount: trendingAllToday["results"].length,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0762 * c, left: 0.0254 * c),
                child: Text(
                  "Trending Today - Movies", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Colors.white)
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(trendingMoviesToday["results"][index], c);
                  },
                  itemCount: trendingMoviesToday["results"].length,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0762 * c, left: 0.0254 * c),
                child: Text(
                  "Trending Today - TV", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Colors.white)
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(trendingShowsToday["results"][index], c);
                  },
                  itemCount: trendingShowsToday["results"].length,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0762 * c, left: 0.0254 * c),
                child: Text(
                  "Trending This Week - All", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Colors.white)
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(trendingAllWeek["results"][index], c);
                  },
                  itemCount: trendingAllWeek["results"].length,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0762 * c, left: 0.0254 * c),
                child: Text(
                  "Trending This Week - Movies", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Colors.white)
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(trendingMoviesWeek["results"][index], c);
                  },
                  itemCount: trendingMoviesWeek["results"].length,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0762 * c, left: 0.0254 * c),
                child: Text(
                  "Trending This Week - TV", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, color: Colors.white)
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0508 * c),
                height: 0.81 * c,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return MovieThumbnail(trendingShowsWeek["results"][index], c);
                  },
                  itemCount: trendingShowsWeek["results"].length,
                ),
              ),
              SizedBox(
                height: 0.0508 * c,
              )
            ]
          ),
        ),
      )),
    );
  }
}
