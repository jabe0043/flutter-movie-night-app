import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:movie_night_app/data/models/session_api_model.dart';
import 'package:movie_night_app/data/http_helper.dart';

/*
get allows for formatting
set allows for validation
we need: deviceId, code, sessionId, vote
*/

enum SessionType { host, guest, vote }

class MovieSessionProvider extends ChangeNotifier {
  static String? movieNightUrl; //public
  String? _deviceId;
  HostSession? _hostSessionInfo;
  GuestSession? _guestSessionInfo;

//getters
  String? get deviceId => _deviceId;
  HostSession? get hostSessionInfo => _hostSessionInfo;
  GuestSession? get guestSessionInfo => _guestSessionInfo;

//set device id
  Future<void> userDeviceId() async {
    try {
      _deviceId = await PlatformDeviceId.getDeviceId;
    } on Exception catch (_) {
      _deviceId = "Device id Not Found";
    }
    notifyListeners();
  }

// Build url and fetch
  setMovieNightUrl(Enum sessionType, String? code) async {
    String baseUrl = 'https://movie-night-api.onrender.com/';
    switch (sessionType) {
      case SessionType.host:
        movieNightUrl = '${baseUrl}start-session?device_id=$deviceId';
        await setSessionInfo(SessionType.host);
      case SessionType.guest:
        movieNightUrl = '${baseUrl}join-session?device_id=$deviceId&code=$code';
        await setSessionInfo(SessionType.guest);
      // case SessionType.vote:
    }
    print("Provider -- TYPE:$sessionType. MovieNight url: $movieNightUrl");
    notifyListeners();
  }

  Future<void> setSessionInfo(Enum sessionType) async {
    try {
      //raw json from http helper
      Map<String, dynamic> data = await HttpHelper().fetch(movieNightUrl!);

      switch (sessionType) {
        case SessionType.host:
          HostSession modeledData = HostSession.fromJson(data);
          _hostSessionInfo = modeledData;
        case SessionType.guest:
          GuestSession modeledData = GuestSession.fromJson(data);
          _guestSessionInfo = modeledData;
      }
      print(
          "provider -- $sessionType. Code: ${_hostSessionInfo!.code}, id:${_hostSessionInfo!.sessionId}");
      notifyListeners();
    } catch (e) {
      print("Error setting SessionId: $e");
    }
  }
}
