import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:movie_night_app/data/models/session_api_model.dart';
import 'package:movie_night_app/data/http_helper.dart';
import 'package:movie_night_app/data/models/device_info_model.dart';

enum SessionType { host, guest, vote }

class MovieSessionProvider extends ChangeNotifier {
  Map<String, dynamic>? _deviceInfo; //the device info object
  String? _deviceId; //extracted id value from ^
  HostSession? _hostSessionInfo; //holds host session resp obj
  GuestSession? _guestSessionInfo; //holds guest session resp obj
  VoteMatch? _voteResult; //holds vote response obj
  static String? movieNightUrl; //url for host || guest || vote

//getters
  Map<String, dynamic>? get deviceInfo => _deviceInfo;
  String? get deviceId => _deviceId;
  HostSession? get hostSessionInfo => _hostSessionInfo;
  GuestSession? get guestSessionInfo => _guestSessionInfo;
  VoteMatch? get voteResult => _voteResult;

//set device id
  Future<void> userDeviceId() async {
    try {
      DeviceInfo deviceInfo = DeviceInfo(); //initialize my DeviceInfo class
      await deviceInfo.initPlatformState(); //get device info from ^
      _deviceInfo = deviceInfo.deviceInfo; //set device info

      if (_deviceInfo?["model"] == "iPhone") {
        _deviceId = _deviceInfo?["identifierForVendor"];
      } else {
        _deviceId = _deviceInfo?["id"];
      }
    } catch (_) {
      throw Exception("Cannot get device data.");
    }
    notifyListeners();
  }

// Build url and fetch
  setMovieNightUrl(
      Enum sessionType, String? code, int? movieId, bool? vote) async {
    String baseUrl = 'https://movie-night-api.onrender.com';
    switch (sessionType) {
      case SessionType.host:
        _guestSessionInfo = null;
        movieNightUrl = '$baseUrl/start-session?device_id=$deviceId';
        await setSessionInfo(SessionType.host);
        break;
      case SessionType.guest:
        _hostSessionInfo = null;
        movieNightUrl = '$baseUrl/join-session?device_id=$deviceId&code=$code';
        await setSessionInfo(SessionType.guest);
        break;
      case SessionType.vote:
        movieNightUrl =
            '$baseUrl/vote-movie?session_id=${hostSessionInfo?.sessionId ?? guestSessionInfo?.sessionId}&movie_id=$movieId&vote=$vote';
        await setSessionInfo(SessionType.vote);
        break;
    }
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
          break;

        case SessionType.guest:
          GuestSession modeledData = GuestSession.fromJson(data);
          if (modeledData.sessionId == "") {
            throw Exception("Invalid code");
          } else {
            _guestSessionInfo = modeledData;
          }
          break;
        case SessionType.vote:
          VoteMatch modeledData = VoteMatch.fromJson(data);
          _voteResult = modeledData;
          break;
      }
      notifyListeners();
    } catch (e) {
      throw Exception("Error setting session info: $e");
    }
  }
}
