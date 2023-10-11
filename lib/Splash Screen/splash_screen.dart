import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:locumspherelimited_unit/Navbar/navbar.dart';
import 'package:locumspherelimited_unit/Sign%20in/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  String unit = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUnitStatus().then((value) {
      unit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    //show screen for 2 secs
    Future.delayed(const Duration(seconds: 2), () {
      if (unit == "Select Unit" || unit == "" ||unit=="null" ) {
        Get.offAll(SignIn());
      } else {
        print(unit);
        Get.offAll(NavBar());
      }
    });
    return Scaffold(
      body: Center(
          child: FlutterLogo(
        size: 100,
      )),
    );
  }

  Future<String> getUnitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("unit").toString();
  }
}
