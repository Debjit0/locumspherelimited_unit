

class RequestModel {
  DateTime date;
  String unitName;
  String unitLocation;
  List members;
  bool isResponded;
  String requestedMale;
  String requestedFemale;
  String unitId;

  RequestModel({
    required this.date,
    required this.unitName,
    required this.unitLocation,
    required this.isResponded,
    required this.unitId,
    required this.members,
    required this.requestedFemale,
    required this.requestedMale,
  });
}
