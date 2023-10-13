import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locumspherelimited_unit/Firebase%20Services/firebase_services.dart';
import 'package:locumspherelimited_unit/Home%20Screen/home_screen.dart';
import 'package:locumspherelimited_unit/Navbar/navbar.dart';
import 'package:locumspherelimited_unit/Request%20Screen/components/drop_down_menu.dart';
import 'package:locumspherelimited_unit/Request%20Screen/components/text_form_field.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController staffNoMale = TextEditingController();
  TextEditingController staffNoFemale = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String gender = 'Male';
  String shiftPreference = 'Shift1';
  bool isInit = true;
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Request"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset("assets/images/login.png"),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormFieldNumberWidget(
                            hintText: 'No. of MALE staff required',
                            controller: staffNoMale,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormFieldNumberWidget(
                            hintText: 'No. of FEMALE staff required',
                            controller: staffNoFemale,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          AppDropdownInput(
                            //hintText: "Gender",
                            options: ["Shift1", "Shift2", 'Shift3'],
                            value: shiftPreference,
                            onChanged: (String? value) {
                              setState(() {
                                shiftPreference = value.toString();
                                // state.didChange(newValue);
                              });
                            },
                            getLabel: (String value) => value,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select date'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          child: FilledButton.tonal(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              Services()
                                  .addRequestDetails(
                                      staffNoMale.text,
                                      staffNoFemale.text,
                                      shiftPreference,
                                      selectedDate.toString())
                                  .then((value) {
                                Get.off(NavBar());
                              });
                            },
                            child: isLoading == false
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Next"),
                                      Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                      )
                                    ],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
