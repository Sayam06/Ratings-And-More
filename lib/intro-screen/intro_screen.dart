import 'package:flutter/material.dart';
import 'package:movies_and_more/home-screen/screens/home_screen.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = "/intro";
  const IntroScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var c = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 66, 87, 1),
      body: Center(child: Text("Please check your internet connection :(", style: TextStyle(fontFamily: "Montserrat", fontSize: 0.06096 * c, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 214, 98, 1)),
      textAlign: TextAlign.center,))
    );
  }
}