import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class drawer_code extends StatelessWidget {
  const drawer_code({super.key});
  final String privacyPolicyUrl =
      'https://plantdiseasedetector1.blogspot.com/p/privacy-policy.html';
  final String termsandcondition =
      'https://plantdiseasedetector1.blogspot.com/p/terms-conditions.html';

  final String about_app =
      "https://plantdiseasedetector1.blogspot.com/2024/07/tomato-disease-detector.html";

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  // void _shareApp() {
  //   Share.share('Check out this amazing app: $appUrl');
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.blue.shade100, // Nice background color
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.fromLTRB(16.0, 46.0, 16.0, 8.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 94, 220, 136),
                ),
                child: Text(
                  'Tomato Disease Detector',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy'),
                onTap: () {
                  Navigator.pop(context);
                  _launchURL(privacyPolicyUrl);
                },
              ),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text('Terms and Conditions'),
                onTap: () {
                  Navigator.pop(context);
                  _launchURL(termsandcondition);
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('About App'),
                onTap: () {
                  Navigator.pop(context);
                  _launchURL(about_app);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
