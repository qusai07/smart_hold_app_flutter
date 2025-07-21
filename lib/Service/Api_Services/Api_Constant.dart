class BaseUrl {
  static String? ipAddress;
  static const String port = "5300";

  // This method fetches the IP address asynchronously
  static Future<void> initialize() async {
    ipAddress = "http://192.168.1.115:5300/smart";
  }

  BaseUrl() {
    initialize();
  }

  static String get baseUrl => '$ipAddress:$port';
}

class ApiConstants {
  static String get baseUrl => '${BaseUrl.baseUrl}/';
  static String get baseUrlWithPort => '${BaseUrl.ipAddress}:${BaseUrl.port}';

  static const String getConfig =
      'https://daylife-96933-default-rtdb.firebaseio.com/config.json';

  static const String authVersion = 'v1';
  static const String groupVersion = 'v1';
}

class AuthEndpoints {
  static String get baseUrl =>
      '${ApiConstants.baseUrl}${ApiConstants.authVersion}/auth';

  static String get schoolLogin => '$baseUrl/login';
  static String get studentLogin => '$baseUrl/login';
  static String get userLogout => '$baseUrl/logout';
  static String get refreshToken => '$baseUrl/refreshToken';
  static String get guestLogin => '$baseUrl/guestLogin';
  static String get guestLogout => '$baseUrl/guestLogout';
}

class UserEndpoints {
  static String get baseUrl =>
      '${ApiConstants.baseUrl}${ApiConstants.authVersion}/user';

  static String get editPassword => '$baseUrl/changePassword';
}

class GroupeEndpoints {
  static String get baseUrl =>
      '${ApiConstants.baseUrl}${ApiConstants.groupVersion}/group';

  static String getAllPosts(int page, int size, String groupId) {
    return '$baseUrl/$groupId/post/getAllPosts?page=$page&size=$size';
  }

  static String getAllComments(int page, int size, String postId) {
    return '$baseUrl/post/$postId/comments?page=$page&size=$size';
  }

  static String createGroupPost(String groupId) {
    return '$baseUrl/$groupId/createPost';
  }

  static String deleteGroupPost(String groupId, String postId) {
    return '$baseUrl/$groupId/post/$postId/deletePost';
  }

  static String addComment(String postId, String comment) {
    return '$baseUrl/post/$postId/addComment';
  }

  static String deleteComment(String postId, String commentId) {
    return '$baseUrl/post/$postId/comment/$commentId';
  }

  static String addLike(String postId) {
    return '$baseUrl/post/$postId/toggleLike';
  }

  static String removeLike(String postId) {
    return '$baseUrl/post/$postId/toggleLike';
  }
}

// class SchoolEndpoints {
// //  static String get baseUrl =>
//  //     '${ApiConstants.baseUrl}${ApiConstants.schoolVersion}/school';

//   static String getAllSchools(int page, int size) {
//     return '$baseUrl/getAllSchools?page=$page&size=$size';
//   }

//   static String getSchoolById(String schoolId) {
//     return '$baseUrl/getSchoolById/$schoolId';
//   }

//   static String uploadCoverImage(String schoolId) {
//     return '$baseUrl/$schoolId/uploadCoverImage';
//   }

//   static String uploadSchoolImages(String schoolId) {
//     return '$baseUrl/$schoolId/uploadSchoolImages';
//   }

//   static String getAllFeedbacks(int page, int size, String schoolId) {
//     return '$baseUrl/$schoolId/getSchoolFeedBacks?page=$page&size=$size';
//   }
// }
