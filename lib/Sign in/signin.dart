import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:locumspherelimited_unit/Navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String selectedUnitValue = "Select Unit";
  String selectedUnitId = "";
  CollectionReference unitCollection =
      FirebaseFirestore.instance.collection('Units');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
                stream: unitCollection.snapshots(),
                builder: (context, snapshot) {
                  List<DropdownMenuItem> unitItems = [];
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final units = snapshot.data!.docs.reversed.toList();
                  unitItems.add(DropdownMenuItem(
                      value: 'Select Unit', child: Text("Select Unit")));

                  for (var unit in units) {
                    print("Unit name and id${unit['unitname']}_${unit.id}");
                    unitItems.add(DropdownMenuItem(
                        value: "${unit['unitname']}_${unit.id}",
                        child: Text(unit['unitname'])));
                  }
                  return DropdownButton(
                      value: selectedUnitValue,
                      items: unitItems,
                      onChanged: (unitValue) {
                        setState(() {
                          selectedUnitValue = unitValue;
                          //selectedUnitId = snapshot.data!.docs[unitItems.indexOf()];
                      });
                        //print(unitValue);
                      });
                }),
            FilledButton.tonal(
                onPressed: () {
                  setUnitNameInSharedPreference().then((value) {
                    if (value == true) {
                      Get.offAll(NavBar());
                    }
                  });
                },
                child: Text("Sign in"))
          ],
        ),
      ),
    );
  }

  Future<bool> setUnitNameInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(selectedUnitValue);
    if (selectedUnitValue == "" || selectedUnitValue == "Select Unit") {
      Get.snackbar("Error", "please select an unit");
      return false;
    } else {
      print("Selected unit val = " + selectedUnitValue);
      prefs.setString('unit', selectedUnitValue);
      return true;
    }
  }
}
