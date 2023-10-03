import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Services {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future addRequestDetails(String staffNoMale, String staffNoFemale, String shiftPreference,
      String date) async {

    String unitFromSF = await getUnitStatus();
    if(unitFromSF!="null"||unitFromSF!=""){
      
    final data = {
      'staffmale' : staffNoMale,
      'stafffemale': staffNoFemale,
      'date': date,
      'shiftpreference': shiftPreference,
      'unitid': unitFromSF
    };
    CollectionReference userCollection = _firestore.collection("Requests");

    try {
      await userCollection.doc().set(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
      }


  Future<String> getUnitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("unit").toString();
  }
}