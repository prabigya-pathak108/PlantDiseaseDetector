import 'package:flutter/material.dart';

class CropsDetail extends StatelessWidget {
  final dynamic plant;

  const CropsDetail({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant['name']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                plant['image'],
                width: 200,
              ),
            ),
            SizedBox(height: 30,),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              plant['description'],
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Optimal Growing Conditions:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Temperature: ${plant['optimalGrowingConditions']['temperature']}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Soil Type: ${plant['optimalGrowingConditions']['soilType']}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Sunlight: ${plant['optimalGrowingConditions']['sunlight']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Planting Tips:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            for (var tip in plant['plantingTips'])
              Text(
                '- $tip',
                style: TextStyle(fontSize: 16.0),
              ),
          ],
        ),
      ),
    );
  }
}
