/*
 * Copyright (C) 2024 LEIDOS.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

import 'package:cybersecurity_its_app/models/devices.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


//TODO -- Refactor with Provider
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({required this.label, this.deviceJson, Key? key})
    : super(key: key);

    /// The label
  final String label;
  final String? deviceJson;

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {

  final TextEditingController recommendationController = TextEditingController();

  String? selectedRecommendation;  

  @override
  Widget build(BuildContext context) {

    final decodedDevice = jsonDecode(widget.deviceJson!);
    ITSDevice device = ITSDevice.fromJson(decodedDevice);
    
    final List<DropdownMenuEntry<String>> dropdownEntries = <DropdownMenuEntry<String>>[];
    for (final item in device.securityRecommendations!.keys.toList()) {
      dropdownEntries.add(DropdownMenuEntry<String>(value: item, label: item));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Recommendations"),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
                  child: Text(device.deviceAsString(),
                    style: Theme.of(context).textTheme.titleLarge),
                ),              
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                  child: DropdownMenu<String>(
                    width: 250.0,
                    menuHeight: 500.0,
                    initialSelection: device.securityRecommendations!.keys.toList()[0],
                    controller: recommendationController,
                    dropdownMenuEntries: dropdownEntries,
                    onSelected: (String? item) {
                      setState(() {
                        selectedRecommendation = item!;
                      });
                    }
                  ),
                )
              ],
            )
          ),
          updateSecurityRecommendations(device.securityRecommendations!)
        ],
      ),
    );
  }

  Widget updateSecurityRecommendations(Map<String, dynamic> securityRecommendations){
    if(selectedRecommendation == null && securityRecommendations.isNotEmpty){
      selectedRecommendation = securityRecommendations.keys.first;
    }
    if(securityRecommendations.containsKey(selectedRecommendation)){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (String recommendation in securityRecommendations[selectedRecommendation].keys)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36.0, top: 32.0, right: 36.0),
                  child: Text(recommendation),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 36.0, top: 8.0, right: 26.0),
                  child: Text(securityRecommendations[selectedRecommendation][recommendation].toString()),
                ),
              ],
            ),      
        ],
      );
    }
    return const Center(child: Padding(
      padding: EdgeInsets.all(28.0),
      child: Text("No Recommendations"),
    ));
  }
}
