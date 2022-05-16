import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_reviewers_profile.dart';
import 'package:web_demo/models/screen_models/product_detail_real_estate_page_model.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/app_reviewer_info.dart';
import 'package:web_demo/widgets/widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileReviewer extends StatefulWidget {
  const ProfileReviewer({Key? key, required this.id, required this.name})
      : super(key: key);
  final int id;
  final String name;

  @override
  State<ProfileReviewer> createState() => _ProfileReviewerState();
}

class _ProfileReviewerState extends State<ProfileReviewer> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  final CameraPosition _initPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool _favorite = false;
  ProductDetailRealEstatePageModel? _detailPage;

  //ReviewersProfile? reviewersProfile;
  UserModel? _reviewersProfile;
  ReviewerProfile? _detail;
  List<ReviewModel> _reviewsList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Share
  void _onShare() async {
    await Share.share(
      'https://codecanyon.net/item/listar-flux-mobile-directory-listing-app-template-for-flutter/25559387',
      subject: 'Review Clip',
    );
  }

  ///On logout
  void _onLogout() async {
    AppBloc.loginCubit.onLogout();
  }

  ///On navigate product detail
  void _onProductDetail(ReviewModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  ///On navigate review
  void _onReview() {
    Navigator.pushNamed(
      context,
      Routes.review,
      arguments: _detailPage!.review,
    );
  }

  ///On like product
  void _onFavorite() {
    setState(() {
      _favorite = !_favorite;
    });
  }

  ///On navigate chat screen
  void _onChat() {
    Navigator.pushNamed(context, Routes.chat, arguments: 3);
  }

  ///Phone action
  void _phoneAction(String phone) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Column(
                      children: [
                        AppListTitle(
                          title: 'WhatsApp',
                          leading: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(Images.whatsapp),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "WhatsApp");
                          },
                        ),
                        AppListTitle(
                          title: 'Viber',
                          leading: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(Images.viber),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "Viber");
                          },
                        ),
                        AppListTitle(
                          title: 'Telegram',
                          leading: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(Images.telegram),
                          ),
                          onPressed: () {
                            Navigator.pop(context, "Telegram");
                          },
                          border: false,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      String url = '';

      switch (result) {
        case "WhatsApp":
          url = "whatsapp://api.whatsapp.com/send?phone=$phone";
          break;
        case "Viber":
          url = "viber://contact?number=$phone";
          break;
        case "Telegram":
          url = "tg://msg?to=$phone";
          break;
        default:
          break;
      }

      _makeAction(url);
    }
  }

  ///Make action
  Future<void> _makeAction(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  void _loadData() async {
    _reviewersProfile = await Api.getReviewerDetail(132);
    print(_reviewersProfile);
    _reviewsList =
        await Api.getVideosByReviewer(int.parse(_reviewersProfile!.id));
    setState(() {});
    // setState(() {
    //   // print(result.data);
    //   _detailPage = ProductDetailRealEstatePageModel.fromJson(result.data);
    //   _favorite = _detailPage!.review.favorite;
    //   // print(_favorite);
    //   _initPosition = CameraPosition(
    //     target: LatLng(
    //       _detailPage!.review.location!.lat,
    //       _detailPage!.review.location!.long,
    //     ),
    //     zoom: 15.4746,
    //   );
    //   final markerID = MarkerId(_detailPage!.review.id.toString());
    //   final marker = Marker(
    //     markerId: markerID,
    //     position: LatLng(
    //       _detailPage!.review.location!.lat,
    //       _detailPage!.review.location!.long,
    //     ),
    //     infoWindow: InfoWindow(title: _detailPage?.review.clientName),
    //   );
    //   _markers[markerID] = marker;
    // });
  }

  Widget _buildRelatedVideos() {
    final deviceWidth = MediaQuery.of(context).size.width;
    const itemHeight = 230;
    final safeLeft = MediaQuery.of(context).padding.left;
    final safeRight = MediaQuery.of(context).padding.right;
    final itemWidth = (deviceWidth - 16 * 3 - safeLeft - safeRight) / 2;
    final ratio = itemWidth / itemHeight;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      crossAxisCount: 2,
      childAspectRatio: ratio,
      children: _reviewsList.map((item) {
        return AppReviewItem(
          onPressed: () {
            _onProductDetail(item);
          },
          item: item,
          type: ProductViewType.gird,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('Reviewer profile'),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: "ProximaNova")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  // shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(Images.avatar),
                    fit: BoxFit.cover,
                  ),
                ),
                // padding: const EdgeInsets.all(8),
                // margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).dividerColor.withOpacity(
                        .05,
                      ),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(
                        0,
                        2,
                      ), // changes position of shadow
                    ),
                  ],
                ),
                child: AppReviewerInfo(
                  user: _reviewersProfile,
                  type: AppReviewerType.information,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: AppProfilePerformance(user: _reviewersProfile),
              ),
              const SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         child: Row(
              //           children: [
              //             AppTag(
              //               "${_detailPage!.product.rate}",
              //               type: TagType.rate,
              //               onPressed: _onReview,
              //             ),
              //             const SizedBox(width: 4),
              //             InkWell(
              //               onTap: _onReview,
              //               child: RatingBar.builder(
              //                 initialRating: _detailPage!.product.rate,
              //                 minRating: 1,
              //                 allowHalfRating: true,
              //                 unratedColor: Colors.amber.withAlpha(100),
              //                 itemCount: 5,
              //                 itemSize: 14.0,
              //                 itemBuilder: (context, _) => const Icon(
              //                   Icons.star,
              //                   color: Colors.amber,
              //                 ),
              //                 ignoreGestures: true,
              //                 onRatingUpdate: (double value) {},
              //               ),
              //             ),
              //             const SizedBox(width: 8),
              //             //add rating
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment:
              //                     CrossAxisAlignment.start,
              //                 children: [
              //                   const SizedBox(width: 4),
              //                   Text(
              //                     '(${_detailPage!.product.numRate} Views)',
              //                     style:
              //                         Theme.of(context).textTheme.caption,
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //       Row(
              //         children: [
              //           InkWell(
              //             onTap: _onFavorite,
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Theme.of(context)
              //                     .primaryColor
              //                     .withOpacity(.8),
              //               ),
              //               child: const Icon(
              //                 Icons.thumb_up_alt,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 8),
              //           InkWell(
              //             onTap:
              //                 _onShare, // _phoneAction(_detailPage!.product.phone);
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Theme.of(context)
              //                     .primaryColor
              //                     .withOpacity(.8),
              //               ),
              //               child: const Icon(
              //                 Icons.share,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 8),
              //           InkWell(
              //             onTap: _onReview,
              //             // onTap: () {
              //             //   _phoneAction(_detailPage!.product.phone);
              //             // },
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Theme.of(context)
              //                     .primaryColor
              //                     .withOpacity(.8),
              //               ),
              //               child: const Icon(
              //                 Icons.message,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 8),
              //           InkWell(
              //             onTap: () {
              //               _phoneAction(_detailPage!.product.phone);
              //             },
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Theme.of(context)
              //                     .primaryColor
              //                     .withOpacity(.8),
              //               ),
              //               child: const Icon(
              //                 Icons.report,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 8),
              // const Divider(),
              // Column(
              //   children: [
              //     const SizedBox(height: 8),
              //     Text(
              //       Translate.of(context).translate('facilities'),
              //       style: Theme.of(context)
              //           .textTheme
              //           .headline6!
              //           .copyWith(fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),

              // Builder(builder: (context) {
              //   return Wrap(
              //     spacing: 8,
              //     runSpacing: 8,
              //     children: _detailPage!.product.service.map((item) {
              //       return IntrinsicWidth(
              //         child: Row(
              //           children: [
              //             Container(
              //               width: 32,
              //               height: 16,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Theme.of(context).cardColor,
              //               ),
              //               child: Icon(
              //                 UtilIcon.getIconData(item.icon),
              //                 size: 14,
              //                 color:
              //                     Theme.of(context).colorScheme.secondary,
              //               ),
              //             ),
              //             const SizedBox(width: 8),
              //             Text(
              //               item.title,
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .caption!
              //                   .copyWith(
              //                       color: Theme.of(context)
              //                           .colorScheme
              //                           .secondary),
              //             )
              //           ],
              //         ),
              //       );
              //     }).toList(),
              //   );
              // }),
              // const Divider(),
              // const SizedBox(height: 8),
              // Text(
              //   Translate.of(context).translate('description'),
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline6!
              //       .copyWith(fontWeight: FontWeight.bold),
              // ),
              // // const SizedBox(height: 8),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     _detailPage!.product.description,
              //     style: Theme.of(context)
              //         .textTheme
              //         .bodyText1!
              //         .copyWith(height: 1.3),
              //   ),
              // ),
              // const SizedBox(height: 16),
              // SizedBox(
              //   height: 180,
              //   child: GoogleMap(
              //     initialCameraPosition: _initPosition,
              //     myLocationButtonEnabled: false,
              //     markers: Set<Marker>.of(_markers.values),
              //   ),
              // ),
              const Divider(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    Translate.of(context).translate('Related Review Clips'),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "ProximaNova"),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    Translate.of(context)
                        .translate('let_find_more_location'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontFamily: "ProximaNova"),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              if (_reviewsList.isEmpty)
                const SizedBox()
              else
                _buildRelatedVideos(),
              /*const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = _detailPage!.product.nearly[index];
                        return AppProductRealEstateItem(
                          item: item,
                          onPressed: () {
                            _onProductDetail(item);
                          },
                          type: ProductViewType.list,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Divider(),
                        );
                      },
                      itemCount: _detailPage != null
                          ? _detailPage!.product.nearly.length
                          : 0,
                    ),
                  ),*/

              // Column(
              //   children: <Widget>[
              //     AppListTitle(
              //       title: Translate.of(context).translate(
              //         'edit_profile',
              //       ),
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //       onPressed: () {
              //         _onNavigate(Routes.editProfile);
              //       },
              //     ),
              //     AppListTitle(
              //       title: Translate.of(context).translate(
              //         'change_password',
              //       ),
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //       onPressed: () {
              //         _onNavigate(Routes.changePassword);
              //       },
              //     ),
              //     AppListTitle(
              //       title: Translate.of(context).translate(
              //         'Review History',
              //       ),
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //       onPressed: () {
              //         _onNavigate(Routes.changePassword);
              //       },
              //     ),
              //     AppListTitle(
              //       title: Translate.of(context).translate(
              //         'Profile link',
              //       ),
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //       onPressed: () {
              //         _onNavigate(Routes.changePassword);
              //       },
              //     ),
              //     AppListTitle(
              //       title: Translate.of(context)
              //           .translate('Monetization plan'),
              //       onPressed: () {
              //         _onNavigate(Routes.contactUs);
              //       },
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //     ),
              //     AppListTitle(
              //       title: Translate.of(context).translate('Subscribers'),
              //       onPressed: () {
              //         _onNavigate(Routes.contactUs);
              //       },
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //     ),
              //     AppListTitle(
              //       title:
              //           Translate.of(context).translate('Submit ticket'),
              //       onPressed: () {
              //         _onNavigate(Routes.aboutUs);
              //       },
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //     ),
              //     AppListTitle(
              //       title: Translate.of(context).translate('setting'),
              //       onPressed: () {
              //         _onNavigate(Routes.setting);
              //       },
              //       trailing: RotatedBox(
              //         quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //         child: const Icon(
              //           Icons.keyboard_arrow_right,
              //           textDirection: TextDirection.ltr,
              //         ),
              //       ),
              //       border: false,
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
