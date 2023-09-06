import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../utils/zoom_info.dart';

/// Widget for the Home/initial pages in the bottom navigation bar.
class HomeScreen extends StatelessWidget {
  /// Creates a HomeScreen
  HomeScreen({required this.label, required this.detailsPath, required this.settingsPath, Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  final String settingsPath;

  final List<String> categories = ["ITS Field Devices","Center to Field Communications","Centralized LAN Equipment", "Other Equipment"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: (26 * Provider
              .of<ZoomInfo>(context)
              .zoomLevel)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset('assets/splash.png',
            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: 50,

        title: Text(label),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(        
              decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius:
                  BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: 
              ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Category(label: categories[index]);
                }
              )
            ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  /// Creates a HelpScreen
  Category({required this.label, Key? key})
      : super(key: key);

  /// The label
  final String label;

  final List<String> devices = ["Device 1", "Device 2","Device 3","Device 4"];
  final List<String> descriptions = ["Description 1", "Description 2","Description 3","Description 4"];
  final List<String> images = ['assets/demo1.png', 'assets/demo2.png','assets/demo3.png', 'assets/demo4.png', 'assets/demo5.png', 'assets/demo6.png'];

    @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: 
                        Text(
                          label,
                          style: const TextStyle(fontSize: 17)
                        )
                      ), 
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 150 * MediaQuery.of(context).textScaleFactor,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  //TODO replace Random image with image at index once backend integrated
                  return Device(label: devices[index], description: descriptions[index], image: images[Random().nextInt(images.length)]);
                }
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}

class Device extends StatelessWidget {
  /// Creates a HelpScreen
  const Device({required this.label, required this.description, required this.image, Key? key})
      : super(key: key);

  /// The label
  final String label;

    /// The description
  final String description;
  
    /// The image
  final String image;

    @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () => context.go('/Home/details'),
      child: Card(
        elevation: 3,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: SizedBox(
          width: 120 * MediaQuery.of(context).textScaleFactor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: 
                Image.asset(image,
                    fit: BoxFit.cover,
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}