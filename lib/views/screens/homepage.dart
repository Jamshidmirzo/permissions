import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permissions/models/location.dart';
import 'package:permissions/services/http_service.dart';
import 'package:permissions/services/location_service.dart';
import 'package:permissions/views/widgets/addproduct.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  add(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Addproduct();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HttpService>();
    final LocationData? myLocation = LocationService.currentLocation;
    print(myLocation);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Locations"),
      ),
      body: StreamBuilder(
        stream: controller.getLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Location yoq, kelin qo`shamiz!'),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final products = snapshot.data!.docs[index];
              final product = Locations.fromJson(products);
              print(product.photo + '123456y7u8i9oiuytrew');
              return Card(
                child: Container(
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: NetworkImage(product.photo))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
