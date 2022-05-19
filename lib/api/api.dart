import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_demo/api/http_manager.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/models/comapny_model.dart';
import 'package:web_demo/models/comment_model.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_business.dart';
import 'package:web_demo/models/reviewer_profile_model.dart';
import 'package:web_demo/models/subscriber_model.dart';
import 'package:web_demo/utils/utils.dart';

List<Subscribed> subscribedList = [];

class Api {
  ///URL API
  static const String domain = "https://www.thereviewclip.com";
  static const String categoryURL = "$domain/services/videosByCategory";
  static const String reviewersHomeURL = "$domain/services/reviewersHome";
  static const String topReviewsURL = "$domain/services/getTopReviews";
  static const String loginURL = "$domain/reviewer/login_check";
  static const String registerURL = "$domain/reviewer/registerReviewer";
  static const String countryList = "$domain/services/loadCountries";
  static const String getReviewerSettings =
      "$domain/reviewer/getReviewerSettings";
  static const String categotieList = "$domain/services/videosByCategory";
  static const String businessList = "$domain/reviewer/get_countries";
  static const String validateBusiness =
      "$domain//reviewer/validatenRecordreview";
  static const String validateReview =
      "$domain/app/submitVideoReview/new_business_388314";
  static const String sendComments = "$domain/reviewer/postComment";
  static const String reviewLike = "$domain/services/reviewLikeUn";
  static const String reviewerProfile =
      "$domain/reviewer_profile/ReviewerProfile";
  static const String changePassword = "$domain/reviewer/updatePass";
  static const String getTopReviewsByReviewer =
      "$domain/services/getTopReviewsByReviewer";
  static const String loadProfileLink =
      "$domain/reviewer_profile/loadProfileLink";
  static const String myvideos = "$domain/services/getTopReviewsByReviewer";
  static const String getCommentsLikes = "$domain/review/getCommentsLikes";
  static const String postReport = "$domain/reviewer/postReport";
  static const String companyProfile = "$domain/profile/companyProfile";
  static const String countIncrease = "$domain/review/viewCountIncrease";
  static const String relatedClips =
      "$domain/services/getTopReviews?limit=100&start=0&lgd=false&status=1";
  static const String subscribeVideo = "$domain/services/subscribe";
  static const String resetReviewerPassword =
      "$domain/services/resetReviewerPassword";
  static const String subscribedListUrl =
      "$domain/reviewer_profile/subscribed_list";
  static const String commonData =
      "$domain/common/commonData";

  ///Login api
  static Future<dynamic> login(params) async {
    var result = await httpManager.post(url: loginURL, data: params);
    Map<String, dynamic> map = jsonDecode(result);
    if (map['login'] == true) {
      result = await httpManager.post(
          url: getReviewerSettings, data: {'client_id': map['client_id']});
    }
    // final result = await UtilData.login();
    return ResultApiModel.fromJson(
        result is String ? jsonDecode(result) : result);
  }

  ///SignUp api
  static Future<dynamic> signUp(params) async {
    var result = await httpManager.post(url: registerURL, data: params);
    Map<String, dynamic> map = result;
    if (map['status'] == 200) {
      result = await httpManager
          .post(url: getReviewerSettings, data: {'client_id': map['userid']});
    }
    // final result = await UtilData.login();
    return ResultApiModel.fromJson(result);
  }

  ///Validate token valid
  static Future<dynamic> validateToken() async {
    final result = await UtilData.validateToken();
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  static Future<dynamic> getCategory(String countryId) async {
    //final result = await UtilData.getCategory();
    final result = await httpManager.post(url: categoryURL, data: {
      "country_id": countryId,
    });
    List list = List.from(result['data']);
    return list.map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList();
  }

  ///Get About Us
  static Future<dynamic> getAboutUs() async {
    final result = await UtilData.getAboutUs();
    return ResultApiModel.fromJson(result);
  }

  ///Get Home
  static Future<dynamic> getHome() async {
    Map<String, dynamic> result = await UtilData.getHomeRealEstate();

    final countryListData = await httpManager.post(url: countryList);
    result['data']['country'] = countryListData['data'];

    final topReviewsData = await httpManager.get(url: topReviewsURL);
    result['data']['popular'] = topReviewsData['data'];

    final reviewersHomeData = await httpManager.get(url: reviewersHomeURL);
    result['data']['channels'] = reviewersHomeData['data'];

    return ResultApiModel.fromJson(result);
  }

  ///Get Messages
  static Future<dynamic> getCountryList() async {
    final countryListData = await httpManager.post(url: countryList);
    List list = List.from(countryListData['data']);
    return list.map<CountryModel>((e) => CountryModel.fromJson(e)).toList();
  }

  ///Get Messages
  static Future<dynamic> getMessage() async {
    final result = await UtilData.getMessage();
    return ResultApiModel.fromJson(result);
  }

  ///Get Detail Messages
  static Future<dynamic> getDetailMessage({required int id}) async {
    final result = await UtilData.getDetailMessage(id);
    return ResultApiModel.fromJson(result);
  }

  ///Get Notification
  static Future<dynamic> getNotification() async {
    final result = await UtilData.getNotification();
    return ResultApiModel.fromJson(result);
  }

  ///Get ProductDetail and Product Detail Tab
  static Future<dynamic> getProductDetail({required int id}) async {
    //return ResultApiModel.fromJson(result);
    throw UnimplementedError("Please make api for review details by review Id");
  }

  ///Get History Search
  static Future<dynamic> getHistorySearch() async {
    throw UnimplementedError("Please make api for search");
    //return ResultApiModel.fromJson(result);
  }

  ///Get Reviewer channels
  static Future<dynamic> getReviewerChannels() async {
    Map<String, dynamic> result = await httpManager.get(url: reviewersHomeURL);
    return ResultApiModel.fromJson(result);
  }

  ///Send Comment
  static Future<dynamic> sendComment(
      {required String videoId,
      required String clientId,
      required String comment}) async {
    Map<String, dynamic> body = {
      'v': videoId,
      'c': comment,
      'xhr': 1,
      'client_id': clientId,
    };
    final result = await httpManager.post(url: sendComments, data: body);
    return result;
  }

  ///Get Wish List
  static Future<dynamic> getWishList() async {
    throw UnimplementedError("Please make api for wish list");
    //return ResultApiModel.fromJson(result);
  }

  ///On Search
  static Future<dynamic> onSearchData() async {
    final result = await httpManager.get(url: topReviewsURL);
    return ResultApiModel.fromJson(result);
  }

  ///Get Location List
  static Future<dynamic> getLocationList() async {
    final result = await UtilData.getLocationList();
    return ResultApiModel.fromJson(result);
  }

  ///Get Product List
  static Future<ResultApiModel> getProduct(int categoryId) async {
    final result = await httpManager.post(url: topReviewsURL, data: {
      "country_id": UtilPreferences.getInt(Preferences.countryId) ?? 1,
      "category_id": categoryId,
    });
    return ResultApiModel.fromJson(result);
  }

  ///Get Review
  static Future<dynamic> getReview() async {
    final result = await UtilData.getReview();
    return ResultApiModel.fromJson(result);
  }

  static Future<dynamic> getBusinessList(params) async {
    final countryListData =
        await httpManager.post(url: businessList, data: params);
    List list = List.from(countryListData['data']);
    return list.map<BusinessModel>((e) => BusinessModel.fromJson(e)).toList();
  }

  static Future<String?> validBusienss(params) async {
    var result = await httpManager.post(url: validateBusiness, data: params);
    print(result);
    return result['data']['slug'];
/*    Map<String, dynamic> map = jsonDecode(result);

    // final result = await UtilData.login();
    return ResultApiModel.fromJson(result);*/
  }

  static Future<dynamic> updatePassword(params) async {
    print(params);
    var result = await httpManager.post(url: changePassword, data: params);

    print(result);
    return result;
  }

  static Future<dynamic> validReview(params) async {
    var result = await httpManager.post(url: validateReview, data: params);
    if (result == null) {}
    print(result);
    print("Review Success");

/*    Map<String, dynamic> map = jsonDecode(result);

    // final result = await UtilData.login();
    return ResultApiModel.fromJson(result);*/
  }

  ///Add Like
  static Future<dynamic> likeVideo(String videoId, String clientId) async {
    Map<String, dynamic> body = {
      'vid': videoId,
      'st': 1,
      'client_id': clientId,
    };
    await httpManager.post(url: reviewLike, data: body);
  }

  ///Related video of video screen
  static Future<dynamic> getRelatedVideo() async {
    final result = await httpManager.post(
      url: topReviewsURL,
      data: {
        'limit': 0,
        'status': 1,
      },
    );
    return ResultApiModel.fromJson(result);
  }

  ///Reviewers Profile
  static Future<ReviewerProfileModel> reviewersProfile(String slug) async {
    Map<String, dynamic> map = {
      'slug': slug,
    };
    final result = await httpManager.post(
      url: reviewerProfile,
      data: map,
    );
    print(result);
    return ReviewerProfileModel.fromJson(json.decode(result));
  }

  ///Reviewers Profile
  static Future<List<ReviewModel>> getVideosByReviewer(int clientId) async {
    Map<String, dynamic> body = {
      'limit': 100,
      'start': 0,
      'lgd': 1,
      'client_id': clientId
    };
    final result =
        await httpManager.post(url: getTopReviewsByReviewer, data: body);
    return result['data']
        .map<ReviewModel>((e) => ReviewModel.fromJson(e))
        .toList();
  }

  ///Reviewers Profile
  static Future<UserModel> getReviewerDetail(int clientId) async {
    Map<String, dynamic> body = {
      'client_id': clientId,
    };
    final result = await httpManager.post(url: getReviewerSettings, data: body);
    return UserModel.fromJson(result['data']);
  }

  static Future<dynamic> getLoadProfileLink() async {
    Map<String, dynamic> body = {
      'client_id': UtilPreferences.getString(Preferences.clientId),
    };
    final result = await httpManager.post(url: loadProfileLink, data: body);
    print(result);
    return result;
  }

  static Future<List<ReviewModel>> getMyVideos() async {
    final result = await httpManager.post(url: myvideos, data: {
      "limit": "100",
      "start": "0",
      "lgd": "1",
      "client_id": UtilPreferences.getString(Preferences.clientId)
    });
    Map<String, dynamic> map = result as Map<String, dynamic>;

    return result['data']
        .map<ReviewModel>((e) => ReviewModel.fromJson(e))
        .toList();
  }

  static Future<CommentRes> getCommentsLikesData(
      String videoSlug, String clientId) async {
    Map<String, dynamic> body = {
      'viedo_slug': videoSlug,
      'client_id': clientId,
    };
    final result = await httpManager.post(url: getCommentsLikes, data: body);
    return commentResFromJson(result);
  }

  static Future<dynamic> postReportData({
    required String videoId,
    required String clientId,
    required String comment,
  }) async {
    Map<String, dynamic> body = {
      'v': videoId,
      'c': comment,
      'xhr': 1,
      'client_id': clientId,
    };
    final result = await httpManager.post(url: postReport, data: body);
    return result;
  }

  static Future<CompanyModel> getCompanyDetail({
    required String slug,
  }) async {
    Map<String, dynamic> body = {
      'slug': slug,
    };
    final result = await httpManager.post(url: companyProfile, data: body);
    return companyModelFromJson(result);
  }

  static Future<dynamic> getIncreaseCount(String slug) async {
    final result =
        await httpManager.post(url: countIncrease, data: {"viedo_slug": slug});
    return result;
  }

  static Future<List<ReviewModel>> getRelatedClips(params) async {
    String uid = UtilPreferences.getString(Preferences.clientId).toString();
    Map<String, dynamic> map = {"client_id": uid};
    print(map);

    final result = await httpManager.post(
        url: relatedClips, options: Options(headers: map));
    return result['data']
        .map<ReviewModel>((e) => ReviewModel.fromJson(e))
        .toList();
  }

  static Future<dynamic> subscribe(params) async {
    final result = await httpManager.post(url: subscribeVideo, data: params);
    print(result);
    return result;
  }

  static Future<dynamic> resetPassword(String email) async {
    final result = await httpManager.post(url: resetReviewerPassword, data: {
      'regemail': email,
    });
    print(result);
    return result;
  }

  static Future<void> getSubscribedList() async {
    final result = await httpManager.post(url: subscribedListUrl, data: {
      'client_id': UtilPreferences.getString(Preferences.clientId),
    });
    print(result);
    SubscriberModel model = SubscriberModel.fromJson(result);
    subscribedList = model.data!.subscribed ?? [];
  }

  static Future<void> getCommonData() async {
    final result = await httpManager.get(url: commonData);
    print(result);
  }

  ///Singleton factory
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();
}
