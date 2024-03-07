import 'dart:io';
import 'package:enhanced_http/interceptor.dart';
import 'package:flutter/material.dart';
import 'package:enhanced_http/enhanced_http.dart' as http;
import 'dart:convert';
import 'package:plant_disease_detection/widget/ImageSlider.dart';
import 'DiseasePredict.dart';
import "drawer_code.dart";

class Disease extends StatefulWidget {
  const Disease({super.key});

  @override
  State<Disease> createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("Plant"),
            Text(
              "CARE",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 0, 159, 5)),
            )
          ],
        ),
      ),
      drawer: drawer_code(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              HorizontalImageSlider(
                imageAssetPaths: [
                  'assets/images/slider1.jpg',
                  'assets/images/slider2.jpg',
                  'assets/images/slider3.jpg',
                  'assets/images/slider4.jpeg'
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: screenWidth,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Heal Your Crop",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Available Crops: Tomato, Potato, Ginger, Pepper, Mango. We will be soon expanding the datasets.",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 138, 124, 124),
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: screenWidth,
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 241, 237, 237), // Adjust color as needed
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 214, 213, 213)
                                  .withOpacity(0.5), // Shadow color
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ], // Half the width/height to get full circle
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/plant.png",
                                      ),
                                      Text(
                                        "Take a Picture",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  Image.asset(
                                    "assets/images/arrow.png",
                                    width: 20,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Image.asset("assets/images/mobile.png"),
                                      Text(
                                        "Get The Result",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  Image.asset(
                                    "assets/images/arrow.png",
                                    width: 20,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Image.asset(
                                          "assets/images/diagnosis.png"),
                                      Text(
                                        "Get Diagnosis",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: 300,
                                child: ElevatedButton(
                                  child: Text('Take a picture',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Montserrat')),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 64, 172, 255),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DiseasePredict()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: screenWidth,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Diseases Detected",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        children: [
                          Text(">Tomato Early Blight"),
                          Text(">Tomato Late Blight"),
                          Text(" >Tomato Bacterial Spot"),
                          Text(" >Tomato Septoria Spot")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
