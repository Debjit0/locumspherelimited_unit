import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited_unit/Chat%20Screen/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllChat extends StatefulWidget {
  const AllChat({super.key});

  @override
  State<AllChat> createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  CollectionReference ChatCollection =
      FirebaseFirestore.instance.collection('Chats');
  String unitName = "";
  String name = "";
  @override
  void initState() {
    // TODO: implement initState
    getUnitStatus().then((value) {
      setState(() {
        unitName = value.split("_")[0];
        print("value =" + value);
      });
    });
    print(unitName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Chats"),
      ),
      body: StreamBuilder(
        stream: ChatCollection.where("participants", arrayContains: unitName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if (snapshot.data!.docs.length == 0) {
            return Text("No Data");
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List participants = snapshot.data!.docs[index]["participants"];
              for (int i = 0; i < 2; i++) {
                print(participants[i]);
                if (participants[i] != unitName) {
                  name = participants[i];
                }
              }
              return GestureDetector(
                onTap: () async {
                  //String name = "";
                  List participants =
                      await snapshot.data!.docs[index]["participants"];
                  for (int i = 0; i < 2; i++) {
                    print(participants[i]);
                    if (participants[i] != unitName) {
                      name = participants[i];
                    }
                  }
                  final splitted = name.split("_");
                  Get.to(ChatScreen(
                    name: splitted[0],
                    uid: splitted[1],
                    unitName: unitName,
                  ));
                  print("${unitName}_${splitted[1]}");
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      name.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  title: Text(
                    name.split("_").first,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Chat with ${name.split("_").first} as $unitName",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Admin"),
                      onTap: () {
                        String name = "";

                        getUnitStatus().then((value) => name = value);
                        final splitted = name.split("_");
                        Get.to(ChatScreen(
                          unitName: unitName,
                          name: splitted[0],
                          uid: splitted[1],
                        ));
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }

  Future<String> getUnitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("unit").toString();
  }
}
