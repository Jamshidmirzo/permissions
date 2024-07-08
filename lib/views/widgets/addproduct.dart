import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permissions/services/http_service.dart';
import 'package:permissions/services/location_service.dart';
import 'package:provider/provider.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final formkey = GlobalKey<FormState>();
  final textcontroller = TextEditingController();
  String? myLocation;
  File? imageFile;
  bool isFetchingLocation = false;

  void submit(BuildContext context) {
    final httpcontroller = context.read<HttpService>();
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      httpcontroller.addProduct(
        textcontroller.text,
        myLocation!,
        imageFile!,
      );
      Navigator.pop(context);
    }
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void getLocation() async {
    setState(() {
      isFetchingLocation = true;
    });

    await LocationService.getCurrentLocation();

    setState(() {
      myLocation = LocationService.currentLocation.toString();
      isFetchingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back"),
          ),
          ElevatedButton(
            onPressed: () {
              submit(context);
            },
            child: const Text("Done"),
          )
        ],
        content: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textcontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ma`lumto kirg`izng!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Input place',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: getLocation,
                child: isFetchingLocation
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Get locations"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: openCamera,
                    label: const Text("Kamera"),
                    icon: const Icon(Icons.camera),
                  ),
                  TextButton.icon(
                    onPressed: openGallery,
                    label: const Text("Galleriya"),
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
              if (imageFile != null)
                SizedBox(
                  height: 200,
                  child: Image.file(imageFile!),
                )
            ],
          ),
        ),
      ),
    );
  }
}
