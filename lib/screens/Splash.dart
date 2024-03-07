import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some loading process
    Future.delayed(Duration(seconds: 3), () {
      // After the loading process, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(backgroundColor: Colors.white,
        body: Center(
          child: Container(height: height/2,width: width/1.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/farmer.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
    );
  }
}
