import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:cybersecurity_its_app/models/devices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicesRepository { 
  Future<void> getDevices() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //api results
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final idToken = session.userPoolTokensResult.value.idToken.raw;
      final restOperation = Amplify.API.get(
        'requestuserdevices',
        headers: {
          'authorization': idToken
        },
      );

      final response = await restOperation.response;
      
      //this is a string we can potentially store in sharedpreferences. to later decode
      final decodedResponse = response.decodeBody().toString();
      await prefs.setString('apiData', decodedResponse);
      
      // final parsedJson = jsonDecode(decodedResponse);
      // final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
      
      // return apiData.map((json) => ITSDevice.fromJson(json)).toList();
      
    } on ApiException catch (e) {
      throw Exception('Get call failed: $e');
    } 
  }
}