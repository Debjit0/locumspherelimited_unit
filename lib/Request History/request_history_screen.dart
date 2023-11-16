import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locumspherelimited_unit/Firebase%20Services/firebase_services.dart';
import 'package:locumspherelimited_unit/Models/request_model.dart';
import 'package:locumspherelimited_unit/components/request_tile.dart';


class RequestHistory extends StatefulWidget {
  const RequestHistory({super.key});

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  CollectionReference RequestCollection =
      FirebaseFirestore.instance.collection('Requests');

  //List<DocumentSnapshot> documents = [];
  TextEditingController searchController = TextEditingController();
  String unit = "";
  String searchText = '';
  List allResults = [];
  List resultList = [];
  late Future resultsLoaded;
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
      appBar: AppBar(
        title: Text("Request History"),
      ),
      body: StreamBuilder(
          stream:
              RequestCollection.where("unitid", isEqualTo: unit).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: RequestTile(
                    request: RequestModel(
                        date:
                            DateTime.parse(snapshot.data!.docs[index]['date'].toString()),
                        unitName: snapshot.data!.docs[index]['unitname'],
                        unitLocation: snapshot.data!.docs[index]['date'],
                        isResponded: snapshot.data!.docs[index]['isresponded'],
                        requestedFemale: snapshot.data!.docs[index]['stafffemale'],
                        requestedMale: snapshot.data!.docs[index]['staffmale'],
                        unitId: snapshot.data!.docs[index]['unitid'],
                        members: List.from(snapshot.data!.docs[index]['assignedemployees'])
                        
                        ),
                  ),
                );
              },
            );
          }),
    );
  }

  getMembers()async{
  }
}
