import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_channel.dart';
import 'package:web_demo/models/screen_models/product_detail_real_estate_page_model.dart';
import 'package:web_demo/models/screen_models/screen_models.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelDetail extends StatefulWidget {
  final ChannelModel? channel;

  const ChannelDetail({Key? key, this.channel}) : super(key: key);

  @override
  _ChannelDetailState createState() {
    return _ChannelDetailState();
  }
}

class _ChannelDetailState extends State<ChannelDetail> {
  bool _favorite = false;
  ProductDetailRealEstatePageModel? _detailPage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Fetch API
  void _loadData() async {
    //final result = await Api.getProductDetail(id: widget.id);
    //if (result.success) {
    // print(result.data);
    //_detailPage = ProductDetailRealEstatePageModel.fromJson(result.data);
  }

  ///On navigate gallery
  void _onPhotoPreview() {
    Navigator.pushNamed(
      context,
      Routes.gallery,
      arguments: _detailPage!.review,
    );
  }

  ///On Share
  void _onShare() async {
    await Share.share(
      _detailPage!.review.shareLink(),
      subject: 'Review Clip',
    );
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

  ///On Company profile
  void _onCompanyProfile(id) {
    Navigator.pushNamed(
      context,
      Routes.profileCompany,
      arguments: id, // 'Company Profile',
    );
  }

  ///On Company profile
  void _onReviewerProfile(id, String name) {
    Navigator.pushNamed(
      context,
      Routes.profileReviewer,
      arguments: {'id': id, 'name': name}, // 'Company Profile',
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

  ///Build Content
  Widget _buildContent() {
    if (_detailPage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _detailPage!.review.comment,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: "ProximaNova",
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                _detailPage!.review.clientName,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () => {_onCompanyProfile(_detailPage!.review.id)},
                // onTap: () {
                //   _phoneAction(_detailPage!.product.phone);
                // }
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Theme.of(context).primaryColor.withOpacity(.8),
                  ),
                  child: const Icon(
                    Icons.launch_outlined,
                    color: Colors.blueGrey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Text(
          //   // '$_currency${_detailPage!.product.price}',
          //   '',//'Taste with Ibrahim',
          //   style: Theme.of(context).textTheme.headline6!.copyWith(
          //       color: Theme.of(context).primaryColor,
          //       fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   _detailPage!.product.address,
          //   style: Theme.of(context).textTheme.caption,
          // ),

          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  AppTag(
                    "${_detailPage!.review.rate}",
                    type: TagType.rate,
                    onPressed: _onReview,
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: _onReview,
                    child: RatingBar.builder(
                      initialRating: _detailPage!.review.rate,
                      minRating: 1,
                      allowHalfRating: true,
                      unratedColor: Colors.amber.withAlpha(100),
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
                  const SizedBox(width: 8),
                  //add rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          '   |   ${_detailPage!.review.views} Views    |   ${_detailPage!.review.likes} Likes    |    ${_detailPage!.review.reviewDate}',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontFamily: "ProximaNova"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: _onFavorite,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(.8),
                      ),
                      child: Icon(
                        Icons.thumb_up_alt,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap:
                        _onShare, // _phoneAction(_detailPage!.product.phone);
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(.8),
                      ),
                      child: Icon(
                        Icons.share,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _onReview,
                    // onTap: () {
                    //   _phoneAction(_detailPage!.product.phone);
                    // },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(.8),
                      ),
                      child: Icon(
                        Icons.message,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      _phoneAction("+91");
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(.8),
                      ),
                      child: Icon(
                        Icons.report,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              _detailPage!.review.image),
                        ),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _detailPage!.review.channelName,
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(fontFamily: "ProximaNova"),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _detailPage!.review.place,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontFamily: "ProximaNova"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => {
                        _onReviewerProfile(_detailPage!.review.id,
                            _detailPage!.review.clientName)
                      },
                      // onTap: () {
                      //   _phoneAction(_detailPage!.product.phone);
                      // }
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withOpacity(.8),
                        ),
                        child: Icon(
                          Icons.launch_outlined,
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: "Subscribed successfully", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT, // location
                            timeInSecForIosWeb: 1 // duration
                            );
                      },
                      child: Text('Subscribe',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(fontFamily: "ProximaNova"))),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          // const SizedBox(height: 16),
          // Text(
          //   Translate.of(context).translate('facilities'),
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline6!
          //       .copyWith(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 8),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: _detailPage!.product.service.map((item) {
          //     return IntrinsicWidth(
          //       child: Row(
          //         children: [
          //           Container(
          //             width: 28,
          //             height: 28,
          //             decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: Theme.of(context).cardColor,
          //             ),
          //             child: Icon(
          //               UtilIcon.getIconData(item.icon),
          //               size: 14,
          //               color: Theme.of(context).colorScheme.secondary,
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Text(
          //             item.title,
          //             style: Theme.of(context).textTheme.caption!.copyWith(
          //                 color: Theme.of(context).colorScheme.secondary),
          //           )
          //         ],
          //       ),
          //     );
          //   }).toList(),
          // ),
          // const SizedBox(height: 16),
          // Text(
          //   Translate.of(context).translate('description'),
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline6!
          //       .copyWith(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   _detailPage!.product.description,
          //   style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.3),
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
          const SizedBox(height: 16),
          Text(
            Translate.of(context).translate('Related Review Clips'),
            // Translate.of(context).translate('nearly'),
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
          ),
          Text(
            Translate.of(context).translate('let_find_more_location'),
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontFamily: "ProximaNova"),
          ),
          const SizedBox(height: 8),
          /*ListView.separated(
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
            itemCount: _detailPage!.product.nearly.length,
          ),
          const SizedBox(height: 8),
          ListView.separated(
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
            itemCount: _detailPage!.product.nearly.length,
          ),*/
        ],
      );
    }

    ///Loading
    return AppPlaceholder(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 16, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel?.channelName ?? "",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontFamily: "ProximaNova")),
      ),
      body: Column(
        children: [
          AppChannelItem(
            type: ProductViewType.small,
            item: widget.channel,
            onPressed: () {},
            onSubscribe: () {
              Fluttertoast.showToast(
                  msg: "Subscribed successfully", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.BOTTOM_LEFT, // location
                  timeInSecForIosWeb: 1 // duration
                  );
            },
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(),
            ),
          ))
        ],
      ),
    );
  }
}
