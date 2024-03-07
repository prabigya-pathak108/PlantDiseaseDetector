import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import '../helper/image_classification_helper.dart';

class DiseasePredict extends StatefulWidget {
  const DiseasePredict({super.key});

  @override
  State<DiseasePredict> createState() => _DiseasePredictState();
}

class _DiseasePredictState extends State<DiseasePredict> {
  File? _pickedImage;
  ImagePicker picker = ImagePicker();
  late Future<Map<String, double>> classification;
  var plants_solution;

  String? imagePath;
  ObjectDetection? _interpreter;
  late tfl.Tensor inputTensor;
  late tfl.Tensor outputTensor;
  static const labelsPath = 'assets/labels.txt';
  late final List<String> labels;

  @override
  void initState() {
    super.initState();
    _interpreter = ObjectDetection();
    loadJSON();
    //debugPrint("Json Loaded");
  }

  Future<Map<String, double>> inferenceImageAll(
      img.Image image,
      tfl.Interpreter interpreter,
      List<String> labels,
      List<int> inputTensor,
      List<int> outputTensor) async {
    img.Image imageInput = img.copyResize(
      image,
      width: inputTensor[1],
      height: inputTensor[2],
    );

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );
    final input = [imageMatrix];
    final output = [List<int>.filled(outputTensor[1], 0)];
    interpreter.run(input, output);
    //print("output is: ${output}");
    final result = output.first;
    int maxScore = result.reduce((a, b) => a + b);
    // Set classification map {label: points}
    var classification = <String, double>{};
    for (var i = 0; i < result.length; i++) {
      if (result[i] != 0) {
        // Set label: points
        classification[labels[i]] = result[i].toDouble() / maxScore.toDouble();
      }
    }
    return classification;
  }

  Future<void> loadJSON() async {
    String jsonString = await _loadJSONData();
    setState(() {
      plants_solution = json.decode(jsonString);
      //debugPrint("${plants_solution}");
    });
  }

  Future<String> _loadJSONData() async {
    return await rootBundle.loadString('assets/disease_solutions.json');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<String>> processImage() async {
    // Await the result of the async operation to get the disease name.
    final String diseaseName = await _interpreter!.analyseImage(imagePath!);

    // Assuming plants_solution is a Map<String, String> or similar.
    final String solution = plants_solution[diseaseName];

    // Return a list containing both the disease name and its solution.
    return [diseaseName, solution];
  }

  void call_future_builder(BuildContext context) {
    FutureBuilder<List<String>>(
        future: processImage(),
        builder: (context, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Error Occurred"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              return AlertDialog(
                title: Text(snapshot.data![0]),
                content: Text(snapshot.data![1]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            }
          }

          // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: Center(
                child: Container(
              width: 200,
              color: Colors.red,
              height: 200,
              child: Text("hello"),
            )),
          );
        });
  }

  void showAlert(BuildContext context) async {
    List<String> values = await processImage();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(values[0]),
          content: Text(values[1]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pick(ImageSource source) async {
    final pickedImageFile = await ImagePicker().pickImage(source: source);

    if (pickedImageFile != null) {
      imagePath = pickedImageFile.path;
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Disease Prediction"),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: 165,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 172, 0),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        // Shadow color
                        spreadRadius: 0.01,
                        // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        // Shadow color
                        spreadRadius: 0.01,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('Open Gallery',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Montserrat')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 172, 0),
                        ),
                        onPressed: () {
                          _pick(ImageSource.gallery);
                        },
                      ),
                      ElevatedButton(
                        child: Text('Start Camera',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Montserrat')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 57, 191, 0),
                        ),
                        onPressed: () {
                          _pick(ImageSource.camera);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.orangeAccent.withOpacity(0.3),
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: _pickedImage != null
                      ? Image(
                          image: FileImage(_pickedImage!),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text("Please Add Image"),
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _pickedImage != null ? showAlert(context) : null;
                },
                child: Text('DETECT',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Montserrat')),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 57, 191, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            )
          ]),
        ));
  }
}
