import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Locations {
  String id;
  String name;
  String location;
  String photo;
  Locations(
      {required this.id,
      required this.location,
      required this.name,
      required this.photo});
  factory Locations.fromJson(QueryDocumentSnapshot query) {
    return Locations(
        id: query.id,
        location: query['location'],
        name: query['name'],
        photo: query['photo']);
  }
}
