import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List emptyList = [];
  Future addRequestDetails(String staffNoMale, String staffNoFemale,
      String shiftPreference, String date) async {
    String unitFromSF = await getUnitStatus();
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Units')
        .doc(unitFromSF)
        .get();

    String unitName = ds['unitname'];

    if (unitFromSF != "null" || unitFromSF != "") {
      print(DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day));
      final data = {
        'staffmale': staffNoMale,
        'stafffemale': staffNoFemale,
        'date': DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day).toString(),
        'shiftpreference': shiftPreference,
        'unitid': unitFromSF,
        'isresponded': false,
        'unitname': unitName,
        'assignedemployees': emptyList,
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
