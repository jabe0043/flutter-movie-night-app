//start session
class HostSession {
  late String message;
  late String sessionId;
  late String code;

  HostSession.fromJson(Map<String, dynamic> res) {
    message = res['data']['message'];
    sessionId = res['data']['session_id'];
    code = res['data']['code'];
  }
}

//join session
class GuestSession {
  late String message;
  late String? sessionId;

  GuestSession.fromJson(Map<String, dynamic> res) {
    message = res['data']['message'];
    sessionId = res['data']['session_id'];
  }
}

//vote
class VoteMatch {
  late String message;
  late int movieId;
  late bool match;

  VoteMatch.fromJson(Map<String, dynamic> res) {
    message = res['data']['message'];
    movieId = res['data']['movie_id'];
    match = res['data']['match'];
  }
}
