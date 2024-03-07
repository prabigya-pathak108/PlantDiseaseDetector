import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:plant_disease_detection/screens/CropsDetail.dart';

class CropsInfo extends StatefulWidget {
  const CropsInfo({Key? key}) : super(key: key);

  @override
  State<CropsInfo> createState() => _CropsInfoState();
}

class _CropsInfoState extends State<CropsInfo> {
  List<dynamic> plants = [];

  @override
  void initState() {
    super.initState();
    loadJSON();
  }

  Future<void> loadJSON() async {
    String jsonString = await _loadJSONData();
    setState(() {
      plants = json.decode(jsonString)['plants'];
    });
    //print(plants);
  }

  Future<String> _loadJSONData() async {
    return await rootBundle.loadString('assets/crops_info.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("Crops"),
            Text(
              "INFORMATION",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 227, 211, 65)),
            )
          ],
        ),
      ),
      body: plants.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: plants.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 4, // Adjust elevation for shadow
                  margin: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16), // Adjust margin as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: SizedBox(
                    child: ListTile(
                      title: Text(
                        plants[index]['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      trailing: Image.asset(
                        plants[index]['image'],
                        width: 40,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CropsDetail(plant: plants[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
