import 'dart:async';

import 'package:flutter/services.dart';

class Gsbridge {
  static const MethodChannel _channel =
      const MethodChannel('gsbridge');

  static const String STATUS_SUCCESS = "success";
  static const String STATUS_FAILURE = "failure";
  static const String STATUS_FAILURE_REGISTRATION_USER_TAKEN = "failure - username taken";
  static String authToken;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map<String, dynamic>> authenticate (String username, String password) async {
    final Map<String, dynamic> result = await _channel.invokeMapMethod('authenticate', <String, dynamic>{
      'username': username,
      'password': password,
    });
    authToken = result["authToken"];
    return result;
  }

  static Future<Map<String, dynamic>> registration (String displayName, String language, String username, String password) async {
    final Map<String, dynamic> result = await _channel.invokeMapMethod('registration', <String, dynamic>{
      'displayName': displayName,
      'language': language,
      'username': username,
      'password': password,
    });
    authToken = result["authToken"];
    return result;
  }
}
