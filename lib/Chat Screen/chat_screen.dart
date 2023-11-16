import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locumspherelimited_unit/Chat%20Screen/components/message_tile.dart';
import 'package:locumspherelimited_unit/Firebase%20Services/firebase_services.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen(
      {super.key,
      required this.name,
      required this.uid,
      required this.unitName});
  String name;
  String uid;
  String unitName;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    // TODO: implement initState

    getChat();
    super.initState();
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.unitName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      Services().sendMessage(chatMessageMap, widget.uid, widget.name, widget.unitName);
      setState(() {
        messageController.clear();
      });
    }
  }

  getChat() {
    print("wooo ${widget.unitName}_${widget.uid}");
    chats = FirebaseFirestore.instance
        .collection("Chats")
        .doc("${widget.unitName}_${widget.uid}")
        .collection("Messages")
        .orderBy('time')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Stack(children: [
        chatMessages(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  //sendMessage() {}
  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.data.docs.length == 0) {
          return Text("Start a Chat");
        }

        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: widget.unitName,
                      sentByMe: snapshot.data.docs[index]['sender'] == widget.unitName);
                },
              )
            : Container(child: Text("No"));
      },
    );
  }
}
