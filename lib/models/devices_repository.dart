import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:cybersecurity_its_app/models/devices.dart';

class DevicesRepository { 
  Future<List<ITSDevice>> getDevices() async {
    try {
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
      final decodedResponse = response.decodeBody().toString();

      final parsedJson = jsonDecode(decodedResponse);
      final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
      
      print(apiData);
      return apiData.map((json) => ITSDevice.fromJson(json)).toList();

    } on ApiException catch (e) {
      throw Exception('Get call failed: $e');
    } 
  }
}