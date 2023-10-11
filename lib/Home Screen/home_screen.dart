import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited_unit/Firebase%20Services/firebase_services.dart';
import 'package:locumspherelimited_unit/Request%20Screen/request_screen.dart';


// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String unit = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services().getUnitStatus().then((value) {
      setState(() {
        unit = value;
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Allocations")),
      body: Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(RequestScreen());
        },
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }
}
