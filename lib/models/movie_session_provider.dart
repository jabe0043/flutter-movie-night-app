import 'package:flutter/material.dart';
import 'dart:async';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:math'; //TODO: REMOVE

/*
get allows for formatting
set allows for validation
*/

class MovieSessionProvider extends ChangeNotifier {
  String? _deviceId;

  String? get deviceId => _deviceId;

//SET device id
  Future<void> userDeviceId() async {
    try {
      _deviceId = await PlatformDeviceId.getDeviceId;
    } on Exception catch (_) {
      _deviceId = "Device id Not Found";
    }
    notifyListeners(); //tell all the pages about the new value (trigger their build method/re-render)
  }
}
