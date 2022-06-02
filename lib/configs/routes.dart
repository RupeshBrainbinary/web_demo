import 'package:flutter/material.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_channel.dart';
import 'package:web_demo/screens/home/home_category_list.dart';
import 'package:web_demo/screens/list_product_real_estate/list_product_real_estate.dart';
import 'package:web_demo/screens/product_detail_real_estate/product_detail_real_estate.dart';
import 'package:web_demo/screens/screen.dart';
import 'package:web_demo/screens/search_history_real_estate/search_history_real_estate.dart';

class Routes {
  static const String appContainer = "/";
  static const String home = "/home";
  static const String discovery = "/discovery";
  static const String wishList = "/wishList";
  static const String account = "/account";
  static const String galleryUpload = "/galleryUpload";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/forgotPassword";
  static const String productDetail = "/productDetail";
  static const String channelDetail = "/channelDetail";
  static const String searchHistory = "/searchHistory";
  static const String category = "/category";
  static const String notification = "/notification";
  static const String editProfile = "/editProfile";
  static const String changePassword = "/changePassword";
  static const String changeLanguage = "/changeLanguage";
  static const String contactUs = "/contactUs";
  static const String message = "/message";
  static const String chat = "/chat";
  static const String aboutUs = "/aboutUs";
  static const String gallery = "/gallery";
  static const String themeSetting = "/themeSetting";
  static const String listProduct = "/listProduct";
  static const String filter = "/filter";
  static const String review = "/review";
  static const String writeReview = "/writeReview";
  static const String location = "/location";
  static const String setting = "/setting";
  static const String fontSetting = "/fontSetting";
  static const String picker = "/picker";
  static const String gpsPicker = "/gpsPicker";
  static const String submit = "/submit";
  static const String submitSuccess = "/submitSuccess";
  static const String categoryList = "/categoryList";
  static const String profileReviewer = "/profileReviewer";
  static const String profileCompany = "/profile";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appContainer:
        return MaterialPageRoute(
          builder: (context) {
            return AppContainer();
          },
        );
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn(from: settings.arguments as String);
          },
          fullscreenDialog: true,
        );

      case signUp:
        return MaterialPageRoute(
          builder: (context) {
            return const SignUp();
          },
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ForgotPassword();
          },
        );

      case productDetail:
        return MaterialPageRoute(
          builder: (context) {
            final review = settings.arguments as ReviewModel;
            return ProductDetailRealEstate(
              review: review,
            );
          },
        );
      case channelDetail:
        return MaterialPageRoute(
          builder: (context) {
            final channel = settings.arguments as ChannelModel;
            return ChannelDetail(
              channel: channel,
            );
          },
        );

      case searchHistory:
        return MaterialPageRoute(
          builder: (context) {
            return SearchHistoryRealEstate(
              videoCatagoryes: [],
            );
          },
          fullscreenDialog: true,
        );

      case category:
        return MaterialPageRoute(
          builder: (context) {
            return const Category();
          },
        );
      case categoryList:
        return MaterialPageRoute(builder: (context) {
          return HomeCategoryList(
            onCategoryList: () => Navigator.pushNamed(context, Routes.category),
          );
        });

      case profileReviewer:
        final map = settings.arguments as Map;
        final slug = map['slug'] as String;
        return MaterialPageRoute(builder: (context) {
          return ProfileReviewer(slug: slug);
        });

      case profileCompany:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (context) {
          return ProfileCompany(slug: id);
        });

      case notification:
        return MaterialPageRoute(
          builder: (context) => const NotificationList(),
          fullscreenDialog: true,
        );

      case message:
        return MaterialPageRoute(
          builder: (context) {
            return const MessageList();
          },
        );

      case chat:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) {
            return Chat(id: id);
          },
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfile();
          },
        );

      case changePassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ChangePassword();
          },
        );

      case changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return const LanguageSetting();
          },
        );

      case contactUs:
        return MaterialPageRoute(
          builder: (context) {
            return const ContactUs();
          },
        );

      case aboutUs:
        return MaterialPageRoute(
          builder: (context) {
            return const AboutUs();
          },
        );

      case themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const ThemeSetting();
          },
        );

      case filter:
        return MaterialPageRoute(
          builder: (context) => const Filter(),
          fullscreenDialog: true,
        );

      case review:
        final Map map = settings.arguments as Map;
        final String videoSlug = map['videoSlug'];
        final int videoId = map['videoId'];
        return MaterialPageRoute(
          builder: (context) {
            return Review(videoSlug: videoSlug, videoId: videoId);
          },
        );

      case setting:
        return MaterialPageRoute(
          builder: (context) {
            return const Setting();
          },
        );

/*      case fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const FontSetting();
          },
        );*/

      case writeReview:
        final int product = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => WriteReview(
            productId: product,
          ),
        );

      case location:
        final location = settings.arguments as LocationModel;
        return MaterialPageRoute(
          builder: (context) => Location(
            location: location,
          ),
        );

      case listProduct:
        final category = settings.arguments as CategoryModel?;
        return MaterialPageRoute(
          builder: (context) {
            return ListProductRealEstate(category: category);
          },
        );
      case gallery:
        final product = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => Gallery(product: product),
          fullscreenDialog: true,
        );

      case picker:
        return MaterialPageRoute(
          builder: (context) {
            return Picker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case galleryUpload:
        return MaterialPageRoute(
          builder: (context) {
            return GalleryUpload(
              images: settings.arguments as List<ImageModel>,
            );
          },
          fullscreenDialog: true,
        );

      case gpsPicker:
        return MaterialPageRoute(
          builder: (context) {
            LocationModel? item;
            if (settings.arguments != null) {
              item = settings.arguments as LocationModel;
            }
            return GPSPicker(
              picked: item,
            );
          },
          fullscreenDialog: true,
        );

      case submit:
        return MaterialPageRoute(
          builder: (context) {
            return Submit();
          },
          fullscreenDialog: true,
        );

      case submitSuccess:
        return MaterialPageRoute(
          builder: (context) {
            return const SubmitSuccess();
          },
          fullscreenDialog: true,
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
