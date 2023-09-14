import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';

import '../utils/zoom_info.dart';

/// Widget for the Home/initial pages in the bottom navigation bar.
class HomeScreen extends StatefulWidget {
  /// Creates a HomeScreen
  const HomeScreen({required this.label, required this.detailsPath, required this.settingsPath, Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  final String settingsPath;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> demoJsons = [
    "{\"id\": 1,\"device\": {\"vendor\": \"Apple\",\"category\": \"Mobile Device\",\"subType\": \"iOS\",\"model\": \"iPhone\",\"category\": \"Mobile Devices\",\"description\": \"Phone for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"wifi\": true}}", 
    "{\"id\": 4,\"device\": {\"vendor\": \"Netgear\",\"category\": \"Router\",\"subType\": \"None\",\"model\": \"Model A2\",\"category\": \"Home Routers\",\"description\": \"Router for home uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"wifi\": true}}",
    "{\"id\": 2,\"device\": {\"vendor\": \"Apple\",\"category\": \"Mobile Device\",\"subType\": \"iOS\",\"model\": \"iPhone 2\",\"category\": \"Mobile Devices\",\"description\": \"Phone for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"wifi\": true}}",
    "{\"id\": 5,\"device\": {\"vendor\": \"Linksys\",\"category\": \"Router\",\"subType\": \"None\",\"model\": \"Model 15\",\"category\": \"Home Routers\",\"description\": \"Router for home uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"wifi\": true}}", 
    "{\"id\": 3,\"device\": {\"vendor\": \"Samsung\",\"category\": \"Mobile Device\",\"subType\": \"Android\",\"model\": \"Pixel\",\"category\": \"Mobile Devices\",\"description\": \"Phone for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"wifi\": true}}", 
    "{\"id\": 6,\"device\": {\"vendor\": \"Samsung\",\"category\": \"Camera\",\"subType\": \"Mini\",\"model\": \"Mini 15\",\"category\": \"Cameras\",\"description\": \"Camera for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"wifi\": true}}"
   ];
  List<Device> devices = [];
  Set<String> categories = <String>{};
  final _userEditTextController = TextEditingController();

  @override
  void initState() {
    for (String json in demoJsons){
      Map<String, dynamic> decodedJSON = jsonDecode(json);
      Device device = Device.fromJson(decodedJSON["device"]);
      categories.add(device.category);
      devices.add(device);
    }
    super.initState();
  }


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

        title: Text(widget.label),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0, right:8.0, top: 12.0, bottom: 12.0),
            child: DropdownSearch<Device>(
              items: devices,
              itemAsString: (Device u) => u.deviceAsString(),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search)
                ),
              ),
              dropdownButtonProps: const DropdownButtonProps(
                icon: Icon(null),
              ),
              onChanged: (Device? d) => context.go('/Home/details'),
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: .5, color: Colors.grey),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right:15.0, top: 20.0, bottom: 20.0),
                      child: Row(
                        children: [
                          Text(item.deviceAsString()), 
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15.0),
                          
                        ],
                      ),
                    ),
                  );
                },
                showSearchBox: true,
                fit: FlexFit.loose,
                searchFieldProps: TextFieldProps(
                  controller: _userEditTextController,         
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: const Icon(Icons.arrow_back)
                    ),
                    suffixIcon:
                    GestureDetector(
                      onTap: () => _userEditTextController.clear(),
                      child: const Icon(Icons.cancel, color: Colors.black12)
                    ),
                    border: const OutlineInputBorder()
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: 
              ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Category(label: categories.elementAt(index), devices: devices.where((device) => device.category == categories.elementAt(index)).toList());
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
  const Category({required this.label, required this.devices, Key? key})
      : super(key: key);

  /// The label
  final String label;
  final List<Device> devices;

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
                    bottom: BorderSide(width: 1.0, color: Colors.black54),
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
                    const Icon(Icons.arrow_forward, color: Colors.black54),
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
                  return DeviceCard(label: devices[index].deviceAsString(), description: devices[index].description, image: devices[index].imageUrl);
                }
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}

class DeviceCard extends StatelessWidget {
  /// Creates a HelpScreen
  const DeviceCard({required this.label, required this.description, required this.image, Key? key})
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
                Image.network(
                  image,
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

class Device {
  final String vendor;
  final String category;
  final String model;
  final String imageUrl;
  final String description;

  Device({ required this.vendor, required this.category, required this.model, required this.imageUrl, required this.description});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      vendor: json["vendor"],
      category: json["category"],
      model: json["model"],
      imageUrl: json["imageUrl"],
      description: json["description"],
    );
  }

  String deviceAsString(){
    return '$vendor $model';
  }
}