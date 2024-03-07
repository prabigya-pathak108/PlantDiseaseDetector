/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class ObjectDetection {
  static const String _modelPath = 'converted_model_quant.tflite';
  static const String _labelPath = 'assets/labels.txt';

  late tfl.Tensor inputTensor;
  late tfl.Tensor outputTensor;

  tfl.Interpreter? _interpreter;
  List<String>? _labels;

  ObjectDetection() {
    _loadModel();
    _loadLabels();
    log('Done.');
  }

  Future<void> _loadModel() async {
    try {
      log('Loading interpreter...');
      _interpreter = await tfl.Interpreter.fromAsset(_modelPath);
      if (_interpreter != null) {
        inputTensor = _interpreter!.getInputTensors().first;
        // Get tensor output shape [1, 1001]
        outputTensor = _interpreter!.getOutputTensors().first;
        log("${inputTensor}; ${outputTensor.shape}");
        //debugprint('Model loaded successfully');
      }
    } catch (e) {
      //print('Failed to load model: $e');
    }
  }

  Future<void> _loadLabels() async {
    log('Loading labels...');
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

  String analyseImage(String imagePath) {
    log('Analysing image...');
    // Reading image bytes from file
    final imageData = File(imagePath).readAsBytesSync();

    // Decoding image
    final image = img.decodeImage(imageData);

    // Resizing image fpr model, [300, 300]
    final imageInput = img.copyResize(
      image!,
      width: inputTensor.shape[1],
      height: inputTensor.shape[2],
    );

    // Creating matrix representation, [300, 300, 3]
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r.toDouble(), pixel.g.toDouble(), pixel.b.toDouble()];
        },
      ),
    );

    //final output = _runInference(imageMatrix);
    String disease_name = _runInference(imageMatrix, outputTensor.shape);
    return disease_name;
  }

  String _runInference(
      List<List<List<num>>> imageMatrix, List<int> outputTensor) {
    log('Running inference...');

    // Set input tensor [1, 300, 300, 3]
    final input = [imageMatrix];
    log("${input.shape}");

    // Set output tensor
    // Locations: [1, 10, 4]
    // Classes: [1, 10],
    // Scores: [1, 10],
    // Number of detections: [1]
    final output = [List<double>.filled(outputTensor[1], 0.0)];

    _interpreter!.run(input, output);
    //print("output is: ${output}");
    final result = output.first;
    double maxScore = result.reduce((a, b) => a + b);
    //print("maxScore is: ${maxScore}");
    final String disease_name = processTensorResult(result, 0.5, _labels!);
    return disease_name;
  }

  String processTensorResult(
      List<double> result, double threshold, List<String> labels) {
    // Find the index of the highest value in the result
    int maxIndex = 0;
    double maxValue = result[0];
    for (int i = 1; i < result.length; i++) {
      if (result[i] > maxValue) {
        maxValue = result[i];
        maxIndex = i;
      }
    }

    // Check if the highest value exceeds the threshold
    if (maxValue > threshold) {
      // Display the respective label
      //print('Label: ${labels[maxIndex]}');
      return labels[maxIndex];
    } else {
      //print('No label exceeds the threshold.');
      return "No_Disease_Detected";
    }
  }
}
