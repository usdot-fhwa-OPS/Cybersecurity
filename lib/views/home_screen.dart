
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import '../utils/device.dart';
import '../utils/zoom_info.dart';
import '../models/device_model.dart';
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
  // final List<String> demoJsons = [
  //   "{\"id\": 1,\"device\": {\"vendor\": \"Apple\",\"category\": \"Mobile Device\",\"subType\": \"iOS\",\"model\": \"iPhone\",\"category\": \"Mobile Devices\",\"description\": \"Phone for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"Wifi\": true}, \"passwordSettings\": {\"rotate\": 90, \"complexity\": true, \"length\": 10, \"expiryPeriod\": 90}, \"serverPortSettings\": {\"http\": 1, \"https\": 2, \"tcpPort\": 10}}", 
  //   "{\"id\": 4,\"device\": {\"vendor\": \"Netgear\",\"category\": \"Router\",\"subType\": \"None\",\"model\": \"Model A2\",\"category\": \"Home Routers\",\"description\": \"Router for home uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"Wifi\": true}, \"passwordSettings\": {\"rotate\": 90, \"complexity\": true, \"length\": 10, \"expiryPeriod\": 90}, \"serverPortSettings\": {\"http\": 1, \"https\": 2, \"tcpPort\": 10}}", 
  //   "{\"id\": 2,\"device\": {\"vendor\": \"Apple\",\"category\": \"Mobile Device\",\"subType\": \"iOS\",\"model\": \"iPhone 2\",\"category\": \"Mobile Devices\",\"description\": \"Phone for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"Wifi\": true}, \"passwordSettings\": {\"rotate\": 90, \"complexity\": true, \"length\": 10, \"expiryPeriod\": 90}, \"serverPortSettings\": {\"http\": 1, \"https\": 2, \"tcpPort\": 10}}", 
  //   "{\"id\": 5,\"device\": {\"vendor\": \"Linksys\",\"category\": \"Router\",\"subType\": \"None\",\"model\": \"Model 15\",\"category\": \"Home Routers\",\"description\": \"Router for home uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"Wifi\": true}, \"passwordSettings\": {\"rotate\": 90, \"complexity\": true, \"length\": 10, \"expiryPeriod\": 90}, \"serverPortSettings\": {\"http\": 1, \"https\": 2, \"tcpPort\": 10}}",  
  //   "{\"id\": 3,\"device\": {\"vendor\": \"Samsung\",\"category\": \"Mobile Device\",\"subType\": \"Android\",\"model\": \"Pixel\",\"category\": \"Mobile Devices\",\"description\": \"Phone for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"Wifi\": true}, \"passwordSettings\": {\"rotate\": 90, \"complexity\": true, \"length\": 10, \"expiryPeriod\": 90}, \"serverPortSettings\": {\"http\": 1, \"https\": 2, \"tcpPort\": 10}}", 
  //   "{\"id\": 6,\"device\": {\"vendor\": \"Samsung\",\"category\": \"Camera\",\"subType\": \"Mini\",\"model\": \"Mini 15\",\"category\": \"Cameras\",\"description\": \"Camera for basic uses\",\"imageUrl\":\"http://4.bp.blogspot.com/-15Zqijz3gus/T9_sVY_m-TI/AAAAAAAAEzY/nNZZ33CQnGI/s400/Apple_iPhone_4.jpg\"},\"connectionType\": {\"Wifi\": true},\"\": {\"Wifi\": true}, \"passwordSettings\": {\"rotate\": 90, \"complexity\": true, \"length\": 10, \"expiryPeriod\": 90}, \"serverPortSettings\": {\"http\": 1, \"https\": 2, \"tcpPort\": 10}}", 
  //  ];

  final _userEditTextController = TextEditingController();
  Set<String> categories = <String>{};
  Map<int, Device> recentSearches = {};

  late final Map<String, dynamic> _parsedJson;

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
      body: FutureBuilder(
        future: getDevicesFromApi(),
        builder: (context, AsyncSnapshot<List<ITSDevice>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                // Search
                // Padding(
                //   padding: const EdgeInsets.only(left:8.0, right:8.0, top: 12.0, bottom: 12.0),
                //   child: DropdownSearch<ITSDevice>(
                //     items: snapshot.data ?? List.empty(),
                //     itemAsString: (ITSDevice u) => u.deviceAsString(),
                //     dropdownDecoratorProps: const DropDownDecoratorProps(
                //       dropdownSearchDecoration: InputDecoration(
                //         hintText: "Search",
                //         border: OutlineInputBorder(),
                //         prefixIcon: Icon(Icons.search)
                //       ),
                //     ),
                //     dropdownButtonProps: const DropdownButtonProps(
                //       icon: Icon(Icons.search),
                //     ),
                //     onChanged: (ITSDevice? d) => selectSearchDevice(d!), 
                //     popupProps: PopupProps.dialog(
                //       itemBuilder: (context, item, isSelected) {
                //         return Container(
                //           decoration: const BoxDecoration(
                //             border: Border(
                //               bottom: BorderSide(width: .5, color: Colors.grey),
                //             ),
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.only(left: 15.0, right:15.0, top: 20.0, bottom: 20.0),
                //             child: Row(
                //               children: [
                //                 if(recentSearches.keys.contains(item.id)) const Padding(
                //                   padding: EdgeInsets.only(right:10.0),
                //                   child: Icon(Icons.schedule, color: Colors.grey, size: 25.0),
                //                 ) else const SizedBox(width: 10.0),
                //                 Text(item.deviceAsString()), 
                //                 const Spacer(),
                //                 const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15.0),
                                
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //       showSearchBox: true,
                //       fit: FlexFit.loose,
                //       searchFieldProps: TextFieldProps(
                //         controller: _userEditTextController,         
                //         autofocus: true,
                //         decoration: InputDecoration(
                //           hintText: "Search",
                //           prefixIcon: GestureDetector(
                //             onTap: () => Navigator.pop(context, true),
                //             child: const Icon(Icons.arrow_back)
                //           ),
                //           suffixIcon:
                //           GestureDetector(
                //             onTap: () => _userEditTextController.clear(),
                //             child: const Icon(Icons.cancel, color: Colors.black12)
                //           ),
                //           border: const OutlineInputBorder()
                //         ),
                //       ),
                //     ),
                //   ),
                //  ),
                
                // List View
                Expanded(
                  child: 
                    ListView.builder(
                      itemCount: getCategories(snapshot.data!),
                      itemBuilder: (context, index) {
                        return Category(label: categories.elementAt(index), devices: snapshot.data!.where((device) => device.deviceType == categories.elementAt(index)).toList());
                      }
                    )
                  ),
              ],
            );
          } 
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<ITSDevice>> getDevicesFromApi() async {
    try {
     
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final idToken = session.userPoolTokensResult.value.idToken.raw;
      final restOperation = Amplify.API.get(
        'requestuserdevices',
        headers: {
          'authorization': idToken
        },
      );
      final response = await restOperation.response;
      final decodedResponse = response.decodeBody().toString();

      _parsedJson = jsonDecode(decodedResponse);
      final List<dynamic> apiData = _parsedJson['Items'] as List<dynamic>;
      return apiData.map((json) => ITSDevice.fromJson(json)).toList();
    } on ApiException catch (e) {
      throw Exception('Get call failed: $e');
    }

    
  }
  // Future<List<ITSDevice>> getDevices(List<dynamic> demoJsons) async {

  //   recentSearches.clear();

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String savedRecentSearches = "";

  //   savedRecentSearches = prefs.getString('recentSearchesList') ?? "";

  //   if (savedRecentSearches != ""){
      
     
  //     // List<dynamic> recentSearchesDynamic = jsonDecode(savedRecentSearches);
  
       
  //     // for(dynamic d in recentSearchesDynamic){

          
  //     //   Device device = Device.fromJson(d["device"], d["id"], d["connectionType"], securityRecommendations);

  //     //   if(!recentSearches.keys.contains(device.id)){
  //     //     recentSearches[device.id] = device;
  //     //   }
  //     // }
  //   }

  //   List<ITSDevice> devices = List.from(recentSearches.values);
  //   // for (String json in demoJsons){
  //   //   Map<String, dynamic> decodedJSON = jsonDecode(json);
  //   // Map<String, dynamic> securityRecommendations = {...decodedJSON};
  //   // securityRecommendations.remove("device");
  //   // securityRecommendations.remove("id");
  //   // securityRecommendations.remove("connectionType");
  //   // Device device = Device.fromJson(decodedJSON["device"], decodedJSON["id"], decodedJSON["connectionType"], securityRecommendations);

  //   //   if (!recentSearches.keys.contains(device.id)){
  //   //     devices.add(device);
  //   //   }
  //   // }
  //   return devices;
  // }
  

  void updateRecentDevices(Device d) async {
    // Map<int, Device> newList = {};
    // newList[d.id] = d;
    // int index = 1;
    // for (int key in recentSearches.keys){
    //   if(index < 3 && key != d.id){
    //     newList[key] = recentSearches[key]!;
    //   }
    //   index++;
    // }
    // newList[d.id] = d;
    // recentSearches = Map.from(newList);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('recentSearchesList', jsonEncode(recentSearches.values.toList()));
    setState(() {});
  }

  void selectSearchDevice(ITSDevice d){
    //updateRecentDevices(d);
    //context.goNamed('details', pathParameters: {'deviceJson': d.toJson().toString()});
  }

  int getCategories(List<ITSDevice> devices){
    //print(devices);
    for (ITSDevice device in devices){
      categories.add(device.deviceType);
    } 
    //print(categories);
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
              Expanded(child: 
                Image.network(
                  device.imageUrl,
                  fit: BoxFit.cover,
                )
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

