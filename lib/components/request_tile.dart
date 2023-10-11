import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locumspherelimited_unit/Models/request_model.dart';

// ignore: must_be_immutable
class RequestTile extends StatefulWidget {
  RequestTile({
    required this.request,
  });

  RequestModel request;

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMMMEd().format(widget.request.date),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.circle,
                size: 14,
                color: widget.request.isResponded ? Colors.green : Colors.red,
              )
            ],
          ),
          Text("Requested Males : ${widget.request.requestedMale}"),
          Text("Requested Females : ${widget.request.requestedFemale}"),
        ],
      ),
    );
  }
}
