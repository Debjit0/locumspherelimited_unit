import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited_unit/Request%20Screen/request_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.title});
  String title;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
