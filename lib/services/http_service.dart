import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HttpService extends ChangeNotifier {
  final _firebase = FirebaseFirestore.instance.collection('location');
  final _carsImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getLocation() async* {
    yield* _firebase.snapshots();
  }

  Future<void> addProduct(String newName, String location, File photo) async {
    try {
      final imageReference = _carsImageStorage
          .ref()
          .child("locations")
          .child("images")
          .child("${DateTime.now().microsecondsSinceEpoch}.jpg");
      final uploadTask = imageReference.putFile(photo);

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        await _firebase.add({
          'name': newName,
          'location': location,
          'photo': imageUrl,
        });
      });
    } catch (e) {
      print('Error adding product: $e');
    }
  }
}
