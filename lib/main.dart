import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_and_more/home-screen/screens/home_screen.dart';
import 'package:movies_and_more/intro-screen/intro_screen.dart';
import 'package:movies_and_more/movie-details-screen/screens/movie_details_screen.dart';
import 'package:movies_and_more/search-screen/screens/search_result_screen.dart';
import 'package:movies_and_more/tv-details-screen/screens/tv_details_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratings and More',
      // theme: ThemeData(
      //     primarySwatch: Colors.red,
      //     fontFamily: 'Montserrat',
      //     highlightColor: Colors.red),
      home: HomeScreen(),
      routes: {
      HomeScreen.routeName: (ctx) => HomeScreen(),
      MovieDetailsScreen.routeName: (ctx) => MovieDetailsScreen(),
      TvDetailsScreen.routeName: (ctx) => TvDetailsScreen(),
      SearchResultScreen.routeName: (ctx) => SearchResultScreen(),
      IntroScreen.routeName: (ctx) => IntroScreen(),
      }
    );
  }
}
