import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/comapny_model.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/screens/product_detail_real_estate/product_detail_real_estate.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/app_comp_performance.dart';
import 'package:web_demo/widgets/widget.dart';

class ProfileCompany extends StatefulWidget {
  const ProfileCompany({Key? key, required this.slug}) : super(key: key);
  final String slug;

  @override
  State<ProfileCompany> createState() => _ProfileCompanyState();
}

class _ProfileCompanyState extends State<ProfileCompany> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CameraPosition _initPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  ResultApiModel? resultApiModel;
  List<ReviewModel> reviewModel=[];

  bool _favorite = false;

  //ProductDetailRealEstatePageModel? _detailPage;
  CompanyModel? _detailPage;
  bool _loader = false;

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
  Future<void> _onProductDetail(ReviewModel item) async {
    await player.reset();
    Navigator.pushNamed(context, Routes.productDetail, arguments: item).whenComplete((){
      player.reset();
    });
  }

  ///On navigate review
  void _onReview() {
    /*Navigator.pushNamed(
      context,
      Routes.review,
      arguments: _detailPage!.review,
    );*/
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

  void _launchURL() async {
    final url = _detailPage!.address!.websiteUrl ?? '';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
    _loader = true;
    setState(() {});
    _detailPage = await Api.getCompanyDetail(slug: widget.slug);
    reviewModel=  await Api.getRelatedClips({
      "client_id": UtilPreferences.getString(Preferences.clientId).toString()
    });
    print("data");
    print(reviewModel);
    print(reviewModel);

    _loader = false;
    setState(() {});
    /*if (result.success) {
      setState(() {
        // print(result.data);
        _detailPage = ProductDetailRealEstatePageModel.fromJson(result.data);
        _favorite = _detailPage!.review.favorite;
        // print(_favorite);
        _initPosition = CameraPosition(
          target: LatLng(
            _detailPage!.review.location!.lat,
            _detailPage!.review.location!.long,
          ),
          zoom: 15.4746,
        );
        final markerID = MarkerId(_detailPage!.review.id.toString());
        final marker = Marker(
          markerId: markerID,
          position: LatLng(
            _detailPage!.review.location!.lat,
            _detailPage!.review.location!.long,
          ),
          infoWindow: InfoWindow(title: _detailPage?.review.clientName),
        );
        _markers[markerID] = marker;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('Company profile'),
        ),
      ),
      body: _loader
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<UserCubit, UserModel?>(
              builder: (context, use1r) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Theme.of(context).dividerColor.withOpacity(
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
                          child: Image.network(
                              _detailPage!.profileStats!.bannerImg ?? ''),

                          // height: 180,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(8),
                          //   image: DecorationImage(
                          //     image: AssetImage('assets/images/about-us.jpg'),
                          //     fit: BoxFit.fitWidth,
                          //   ),
                          // ),
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
                                color:
                                    Theme.of(context).dividerColor.withOpacity(
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
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: <Widget>[
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(_detailPage!
                                                  .profileStats!.avatar ??
                                              ''),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    // padding: const EdgeInsets.all(4),
                                    // decoration: BoxDecoration(
                                    //   shape: BoxShape.circle,
                                    //   color: Theme.of(context).primaryColor,
                                    // ),
                                    // child: Text(
                                    //   "${user!.rate}",
                                    //   style: const TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 8,
                                    //   ),
                                    // ),
                                    // )
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _detailPage!.clientId ?? '',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _detailPage!.categoryName ?? '',
                                        maxLines: 1,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                // RotatedBox(
                                //   quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                                //   child: const Icon(
                                //     Icons.keyboard_arrow_right,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AppTag(
                                      "${_detailPage != null ? _detailPage!.profileStats!.rating : '0'}",
                                      type: TagType.rate,
                                      onPressed: _onReview,
                                    ),
                                    const SizedBox(width: 4),
                                    InkWell(
                                      onTap: _onReview,
                                      child: RatingBar.builder(
                                        initialRating: (_detailPage != null)
                                            ? _detailPage!.profileStats!.rating!
                                                .toDouble()
                                            : 0.0,
                                        minRating: 1,
                                        allowHalfRating: true,
                                        unratedColor:
                                            Colors.amber.withAlpha(100),
                                        itemCount: 5,
                                        itemSize: 14.0,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        ignoreGestures: true,
                                        onRatingUpdate: (double value) {},
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    //add rating
                                    // Expanded(
                                    //   child: Column(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: [
                                    //       const SizedBox(width: 4),
                                    //       Text(
                                    //         '(${_detailPage!.product.numRate} Views)',
                                    //         style:
                                    //             Theme.of(context).textTheme.caption,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  AppCompanyPerformance(model: _detailPage),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.map_outlined,
                                    size: 24,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "${_detailPage!.address!.address ?? ''}, ${_detailPage!.address!.city ?? ''}, ${_detailPage!.address!.state ?? ''}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [Row()],
                              ),
                              const SizedBox(width: 20),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: _launchURL,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8),
                                          ),
                                          child: const Icon(
                                            Icons.web_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Website",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              // InkWell(
                              //   onTap: () async {
                              //     String phonNumber = _detailPage != null
                              //         ? "+91"
                              //         : _detailPage!.address!.phone ?? '';
                              //
                              //     if (await canLaunch(phonNumber)) {
                              //       await launch(phonNumber);
                              //     } else {
                              //       throw 'Could not launch $phonNumber';
                              //     }
                              //   },
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         width: 40,
                              //         height: 40,
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color: Theme.of(context)
                              //               .primaryColor
                              //               .withOpacity(.8),
                              //         ),
                              //         child: const Icon(
                              //           Icons.phone,
                              //           color: Colors.white,
                              //           size: 20,
                              //         ),
                              //       ),
                              //       const SizedBox(height: 5),
                              //       Text(
                              //         "Phone",
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .bodySmall!
                              //             .copyWith(
                              //                 color: Theme.of(context)
                              //                     .primaryColor),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
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
                        const Divider(),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Translate.of(context)
                                      .translate('Related Review Clips'),
                                  // Translate.of(context).translate('nearly'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Translate.of(context)
                                      .translate('let_find_more_location'),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (reviewModel.isEmpty)
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
                );
              },
            ),
    );
  }
  Widget _buildRelatedVideos() {
    final deviceWidth = MediaQuery.of(context).size.width;
    const itemHeight = 230;
    final safeLeft = MediaQuery.of(context).padding.left;
    final safeRight = MediaQuery.of(context).padding.right;
    final itemWidth = (deviceWidth - 16 * 3 - safeLeft - safeRight) / 2;
    final ratio = itemWidth / itemHeight;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviewModel.length,
      itemBuilder: (context, index) {
        final item = reviewModel[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppReviewItem(
            onPressed: () {
              _onProductDetail(item);
            },
            item: item,
            type: ProductViewType.small,
          ),
        );
      },
    );
    /* GridView.count(
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
    );*/
  }
}
