import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';


import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/zoom_info.dart';
import '../models/devices.dart';
import '../providers/devices_provider.dart';

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
  final _userEditTextController = TextEditingController();
  Set<String> categories = <String>{};
  Map<String, ITSDevice> recentSearches = {};
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DevicesProvider>(context, listen: false).fetchDevicesList(isDeviceConnected);
  }

  @override
  Widget build(BuildContext context) {

    final devicesList = Provider.of<DevicesProvider>(context);
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
            padding: const EdgeInsets.only(left:8.0, right:8, top: 12.0, bottom: 12.0),
            child: DropdownSearch<ITSDevice>(
              asyncItems: (String filter) => getSearchList(),
              itemAsString: (ITSDevice u) => u.deviceAsString(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: _userEditTextController.text.isEmpty ? "Search" : _userEditTextController.text ,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  
                    
                ),
              ),
              dropdownButtonProps: DropdownButtonProps(
                icon:
                GestureDetector(
                  onTap: () => barcodeScan(),
                  child: const Icon(Icons.qr_code_scanner)
                ),
              ),
              onChanged: (ITSDevice? d) => selectSearchDevice(d!),
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
                          if(recentSearches.keys.contains(item.deviceModel)) const Padding(
                            padding: EdgeInsets.only(right:10.0),
                            child: Icon(Icons.schedule, color: Colors.grey, size: 25.0),
                          ) else const SizedBox(width: 10.0),
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
                      onTap: () => {
                        _userEditTextController.clear(),
                        setState(() {})
                      },
                      child: const Icon(Icons.cancel, color: Colors.black12)
                    ),
                  ),
                ),
              ),
            ),
          ),
          devicesList.devices!.isNotEmpty && devicesList.devices != null ?
            Expanded(
                  child: ListView.builder(
                    itemCount: getCategories(devicesList.devices!),
                    itemBuilder: (context, index) {
                      return Category(label: categories.elementAt(index), devices: devicesList.devices!.where((device) => device.deviceType == categories.elementAt(index)).toList());
                    }
                  )
            ) : 
            const Center (child: CircularProgressIndicator()),
        ],
      ),
    );
  }
  
  Future<List<ITSDevice>> getSearchList() async {
    recentSearches.clear(); 
    String savedRecentSearches = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedRecentSearches = prefs.getString('recentSearchesList') ?? "";
    if (savedRecentSearches.isNotEmpty) {
      List<dynamic> recentSearchesList = jsonDecode(savedRecentSearches);
      for (dynamic d in recentSearchesList) {
        
        ITSDevice device = ITSDevice.fromJson(d);
        
        if(!recentSearches.values.contains(device)) {
          recentSearches[device.deviceModel] = device;
        }
      }
    }

    List<ITSDevice> searchList = List.from(recentSearches.values); 
    
    final String? decodedResponse = prefs.getString('apiData');
    final parsedJson = jsonDecode(decodedResponse!);
    final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
    final List<ITSDevice> apiList = apiData.map((json) => ITSDevice.fromJson(json)).toList();

    for (ITSDevice device in apiList) {
      if(!recentSearches.keys.contains(device.deviceModel)) {
        searchList.add(device);
      }
    }
    
    return searchList;
  }

  
  Future<void> barcodeScan() async {
    String barcodeScanRes;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
    
      final String? decodedResponse = prefs.getString('apiData');
      final parsedJson = jsonDecode(decodedResponse!);
      final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
      int deviceIndex = apiData.indexWhere((f) => f['DeviceModel'] == barcodeScanRes);
      ITSDevice device = ITSDevice.fromJson(apiData[deviceIndex]);
      context.goNamed('details', pathParameters: {'deviceJson': jsonEncode(device.toJson())});
     
      
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error: Invalid QR Code'),
          backgroundColor: Color(0xFFD50000),
          behavior: SnackBarBehavior.floating,));
    }
   

    
    // Platform messages may fail, so we use a try/catch PlatformException.
    

  }

  void updateRecentDevices(ITSDevice d) async {
    Map<String, ITSDevice> newList = {};
    newList[d.deviceModel] = d;
    int index = 1;
    for (String key in recentSearches.keys){
      if(index < 3 && key != d.deviceModel){
        newList[key] = recentSearches[key]!;
      }
      index++;
    }
    newList[d.deviceModel] = d;
    recentSearches = Map.from(newList);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('recentSearchesList', jsonEncode(recentSearches.values.toList()));
    setState(() {});
  }

  void selectSearchDevice(ITSDevice d){
    updateRecentDevices(d);
    context.goNamed('details', pathParameters: {'deviceJson': jsonEncode(d.toJson())});
  }
    

  int getCategories(List<ITSDevice> devices){
    for (ITSDevice device in devices){
      categories.add(device.deviceType);
    } 

    return categories.length;
  }
}



class Category extends StatelessWidget {
  /// Creates a HelpScreen
  const Category({required this.label, required this.devices, Key? key})
      : super(key: key);

  /// The label
  final String label;
  final List<ITSDevice> devices;

  
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
                  return DeviceCard(device: devices[index]);
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
  const DeviceCard({required this.device, Key? key})
      : super(key: key);

  /// The label
  final ITSDevice device;

    @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () => context.goNamed('details', pathParameters: {'deviceJson': jsonEncode(device.toJson())}),
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
              Expanded(
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: device.imageUrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
                child: Text(
                  device.deviceAsString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                child: Text(
                  device.description,
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

