
import 'dart:io';

class QcastItem {

  int qcastUserid;
  String name;
  String description;
  String coverPhoto;
  QcastItem({this.qcastUserid, this.name, this.description, this.coverPhoto});

  factory QcastItem.fromJson(Map<String, dynamic> json) => QcastItem(
    qcastUserid: json.containsKey("qcasId") ? json["qcasId"] : json["qcasId"],
    name: json["name"],
    description: json["description"],
    coverPhoto: json["coverPhoto"],
  );
}