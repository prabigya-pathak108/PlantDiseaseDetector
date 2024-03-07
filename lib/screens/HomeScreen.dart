import 'package:flutter/material.dart';
import 'package:plant_disease_detection/screens/Disease.dart';
import 'CropsInfo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Disease(),
    CropsInfo(),
    Text("Tools")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Homepage initiated");
  }

  @override
  void dispose() {
    debugPrint("Homepage disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/disease.png',
              width: 30, // Set width as per your requirement
              height: 30, // Set height as per your requirement
            ),
            label: 'Disease',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/crops.png',
              width: 30,
              height: 30,
            ),
            label: 'Crop',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 29, 27, 27),
        unselectedItemColor: const Color.fromARGB(255, 68, 67, 67),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
