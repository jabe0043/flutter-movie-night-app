//start session
class HostSession {
  late String message;
  late String sessionId;
  late String code;

  HostSession.fromJson(Map<String, dynamic> res) {
    message = res['data']['message'];
    code = res['data']['code'];
    sessionId = res['data']['session_id'];
  }
}

//join session
class GuestSession {
  late String message;
  late String sessionId;

  GuestSession.fromJson(Map<String, dynamic> res) {
    message = res['data']['message'];
    sessionId = res['data']['session_id'];
  }
}

//vote
class VoteMovie {
  late String message;
  late int movieId;
  late bool match;

  VoteMovie.fromJson(Map<String, dynamic> res) {
    message = res['data']['message'];
    movieId = res['data']['movie_id'];
    match = res['data']['match'];
  }
}
