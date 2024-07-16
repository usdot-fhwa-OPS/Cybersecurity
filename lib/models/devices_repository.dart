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

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
      print('here');
      throw Exception('Get call failed: $e');
    } 
  }
}