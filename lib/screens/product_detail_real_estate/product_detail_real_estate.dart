import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/app.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/comment_model.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/screen_models/product_detail_real_estate_page_model.dart';
import 'package:web_demo/models/video_model.dart';
import 'package:web_demo/screens/product_detail_real_estate/vlc_player_with_controls.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class ProductDetailRealEstate extends StatefulWidget {
  final ReviewModel? review;
  final String? slug;

  const ProductDetailRealEstate({Key? key, this.review, this.slug})
      : super(key: key);

  @override
  _ProductDetailRealEstateState createState() {
    return _ProductDetailRealEstateState();
  }
}

// FijkPlayer player = FijkPlayer();

class _ProductDetailRealEstateState extends State<ProductDetailRealEstate> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  /* late List<VideoData> listVideos;*/

  CameraPosition _initPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool _favorite = false;
  VideoModel? _detailPage;

  /*late VideoPlayerController _controller;
  ChewieController? _chewieController;*/
  VlcPlayerController? _controller;
  Timer? _timer;
  bool _onTouch = true;
  String clientId = '';
  bool like = false;
  final TextEditingController _reportController = TextEditingController();
  List<ReviewModel> relatedVideos = [];
  final FocusNode reportFocusNode = FocusNode();
  CommentRes? _commentRes;
  bool isDispose = false;
  bool showControls = false;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    //player = FijkPlayer();
    isDispose = false;
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    /*_controller.dispose();
    _chewieController?.dispose();*/
    isDispose = true;
    //player.reset();
    //player = FijkPlayer();
    _controller?.dispose();
    _timer?.cancel();
    //viewPlayerController!.dealloc();
    super.dispose();
  }

  ///Fetch API
  void _loadData() async {
    //final result = await Api.getProductDetail(id: widget.id);
    //if (result.success) {
    // print(result.data);
    //_detailPage = ProductDetailRealEstatePageModel.fromJson(result.data);
    clientId = UtilPreferences.getString(Preferences.clientId) ?? '';
    _detailPage = await getVideoDetailFromApi(widget.review != null ? widget.review!.videoSlug : widget.slug.toString());
    /*if (widget.review != null) {
      _detailPage = ProductDetailRealEstatePageModel(review: widget.review!);
    } else {
      _detailPage = await getVideoDetailFromApi(widget.slug.toString());
    }*/
    _controller = VlcPlayerController.network(
      _detailPage?.v?.videoUrl ?? '',
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    setState(() {});
    _favorite = widget.review == null ? false : widget.review!.favorite;
    /*_initPosition = CameraPosition(
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
    _markers[markerID] = marker;*/
    Api.getRelatedVideo().then((result) {
      if (result.success) {
        relatedVideos = result.data.map<ReviewModel>((item) {
          return ReviewModel.fromJson(item);
        }).toList();
        setState(() {});
      }
    });
    await getComments();

    /*   listVideos.add(VideoData(
          name: 'Network Video 1',
          path: _detailPage?.review.video ?? '',
          type: VideoType.network));*/

    //await setPlayerValue();
    await Api.getIncreaseCount(_detailPage!.v!.videoSlug!);
    _detailPage!.v!.views = (int.parse(_detailPage!.v!.views!)+1).toString();

    /*_controller =
          VideoPlayerController.network(_detailPage?.review.video ?? '', );
      await Future.wait([
        _controller.initialize(),
      ]);

      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
        hideControlsTimer: const Duration(seconds: 1),

      );*/

    setState(() {});
  }

  Future<VideoModel?> getVideoDetailFromApi(String videoSlug) async {
    VideoModel? videoModel = await Api.getVideoModel(videoSlug);
    ReviewModel? reviewModel;
    /*if (videoModel != null) {
      V v = videoModel.v ?? V();
      Channel c = videoModel.chanel ?? Channel();
      reviewModel = ReviewModel(
        id: int.parse(v.id.toString()),
        views: int.parse(v.views.toString()),
        likes: int.parse(v.likes.toString()),
        clientName: v.clientName.toString(),
        clientImage: v.logoImage.toString(),
        clientLocation: v.location.toString(),
        comment: v.comment.toString(),
        image: v.thumbUrl.toString(),
        video: v.videoUrl.toString(),
        rate: double.parse(v.rating.toString()),
        channelName: c.chanel.toString(),
        place: c.location.toString(),
        profileSlug: v.profileSlug.toString(),
        videoSlug: v.videoSlug.toString(),
        location:
            LocationModel(title: "Dindigul", lat: 10.365581, long: 77.970657),
        reviewDate: v.createdDate.toString(),
        favorite: false,
      );
    }*/
    // return ProductDetailRealEstatePageModel(review: reviewModel!);
    return videoModel;
  }

  /*Future<void> setPlayerValue() async {
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(_detailPage?.review.video ?? '', autoPlay: true);
  }*/

  Future<void> getComments() async {
    _commentRes = await Api.getCommentsLikesData(_detailPage!.v!.videoSlug!,
        UtilPreferences.getString(Preferences.clientId) ?? '');
    setState(() {});
  }

  ///Build RelatedVideos
  Widget _buildRelatedVideo() {
    Widget content = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [0, 1, 2, 3, 4, 5, 6, 7, 8]
              .map((e) => Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: AppReviewItem(
                      type: ProductViewType.gird,
                    ),
                  ))
              .toList(),
        ),
      ),
    );

    ///Empty
    if (relatedVideos.isEmpty) {
      content = Container(
        alignment: Alignment.center,
        child: Text(
          Translate.of(context).translate('data_not_found'),
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(fontFamily: "ProximaNova"),
        ),
      );
    } else {
      content = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        // itemCount: relatedVideos.length,
        itemCount: 5,
        itemBuilder: (context, index) {
          final item = relatedVideos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                if (_controller != null) {
                  _controller!.pause();
                }
                //player.stop();
                setState(() {});

                Future.delayed(Duration(seconds: 1), () {
                  _onProductDetail(item);
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(item.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.clientName,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "ProximaNova"),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.comment,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "ProximaNova"),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              AppTag(
                                "${item.rate}",
                                type: TagType.rate,
                                onPressed: null,
                              ),
                              const SizedBox(width: 4),
                              RatingBar.builder(
                                initialRating: item.rate,
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
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 15,
                                width: 1.5,
                                color:
                                    Theme.of(context).textTheme.caption!.color,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Text(
                                  item.channelName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "ProximaNova"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*child: AppReviewItem(
              onPressed: () {
                //player.stop();
                setState(() {});

                Future.delayed(Duration(seconds: 1), () {
                  _onProductDetail(item);
                });
              },
              item: item,
              type: ProductViewType.small,
            ),*/
          );
        },
      );
    }

    ///Build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [content],
    );
  }

  void _openReviewInfo(ReviewModel item) {
    /*Navigator.pushNamed(context, Routes.productDetail, arguments: item);*/
  }

  ///On navigate gallery
  void _onPhotoPreview() {
    /*Navigator.pushNamed(
      context,
      Routes.gallery,
      arguments: _detailPage!.review,
    );*/
  }

  ///On Share
  void _onShare() async {
    var imageId = await ImageDownloader.downloadImage(_detailPage!.v!.thumbUrl.toString());
    if (imageId == null) {
      return;
    }
    var path = await ImageDownloader.findPath(imageId);
    String content = _detailPage!.v!.comment.toString() + '\n\n' + _detailPage!.v!.shareLink().toString();
    await Share.shareFiles([path.toString()],text: content);
  }

  ///On navigate product detail
  Future<void> _onProductDetail(ReviewModel item) async {
    //await player.reset();
    Navigator.pushNamed(context, Routes.productDetail, arguments: item)
        .whenComplete(() async {
      /*await player.reset();
      await setPlayerValue();
      setState(() {});*/
    });
  }

  ///On navigate review
  void _onReview() {
    Navigator.pushNamed(
      context,
      Routes.review,
      arguments: {
        'videoSlug': _detailPage!.v!.videoSlug,
        'videoId': _detailPage!.v!.id,
      },
    ).whenComplete(() {
      getComments();
    });
  }

  ///On Company profile
  void _onCompanyProfile(String slug) {
    Navigator.pushNamed(
      context,
      Routes.profileCompany,
      arguments: slug, // 'Company Profile',
    );
  }

  ///On Company profile
  void _onReviewerProfile(String slug) {
    Navigator.pushNamed(
      context,
      Routes.profileReviewer,
      arguments: {
        'slug': slug,
      }, // 'Company Profile',
    );
  }

  ///On like product
  void _onFavorite() {
    /*setState(() {
      _favorite = !_favorite;
    });*/
    if (like == false) {
      Api.likeVideo(_detailPage!.v!.id.toString(), clientId);
      _detailPage!.v!.likes = (int.parse(_detailPage!.v!.likes ?? '0')+1).toString();
      like = true;
      setState(() {});
    }
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
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            /*constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),*/
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            maxLines: 3,
                            textInputAction: TextInputAction.newline,
                            controller: _reportController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          'Report',
                          onPressed: () async {
                            if (_reportController.text.isNotEmpty) {
                              final response = await Api.postReportData(
                                clientId: clientId,
                                comment: _reportController.text,
                                videoId: _detailPage!.v!.id.toString(),
                              );
                              if (response['status'] == 200) {
                                _reportController.clear();
                                Navigator.pop(context);
                              }
                            }
                            //_reportController.text
                          },
                        ),
                        /*AppListTitle(
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
                        )*/
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

    /*if (result != null) {
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
    }*/
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
           SizedBox(
             width: width,
             child: Text(
               _detailPage!.v!.comment.toString(),
               style: Theme.of(context).textTheme.subtitle1!.copyWith(
                   color: Theme.of(context).colorScheme.secondary,
                   fontFamily: "ProximaNova",
                   fontWeight: FontWeight.bold),
             ),
           ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 50,
                  maxWidth: width - 65,
                ),
                child: Text(
                  _detailPage!.v!.clientName.toString(),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
              ),
              InkWell(
                onTap: () =>
                    {_onCompanyProfile(_detailPage!.v!.profileSlug.toString())},
                // onTap: () {
                //   _phoneAction(_detailPage!.product.phone);
                // }
                child: Container(
                  width: 30,
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
                    "${_detailPage!.v!.rating}",
                    type: TagType.rate,
                    onPressed: _onReview,
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: _onReview,
                    child: RatingBar.builder(
                      initialRating: double.parse(_detailPage!.v!.rating ??'0'),
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
                          //'   |   ${_detailPage!.review.views} Views    |   ${_detailPage!.review.likes} Likes    |    ${_detailPage!.review.reviewDate}',
                          '   |   ${_detailPage!.v!.views} Views    |    ${_detailPage!.v!.createdDate}',
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
                  Column(
                    children: [
                      InkWell(
                        onTap: _onFavorite,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8),
                          ),
                          child: const Icon(
                            Icons.thumb_up_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        _detailPage!.v!.likes.toString() + ' Likes',
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontFamily: "ProximaNova"),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      InkWell(
                        onTap:
                            _onShare, // _phoneAction(_detailPage!.product.phone);
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8),
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text('Share',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(fontFamily: "ProximaNova")),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
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
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8),
                          ),
                          child: const Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                          "${_commentRes == null ? 0 : (_commentRes!.commentsCount ?? 0)}" +
                              ' Comments',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(fontFamily: "ProximaNova")),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          _phoneAction("+91");
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8),
                          ),
                          child: Icon(
                            Icons.report,
                            color: Theme.of(context).iconTheme.color,
                            size: 20,
                          ),
                        ),
                      ),
                      Text('Report',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(fontFamily: "ProximaNova")),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (_commentRes!.chanel!.slug != null) {
                      _onReviewerProfile(_commentRes!.chanel!.slug!);
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          /*image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                _detailPage!.review.image,
                              ),
                              fit: BoxFit.cover),*/
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl: _commentRes == null
                                  ? 'null'
                                  : "https://www.thereviewclip.com/uploads/client_logo/${_commentRes!.chanel!.avatar.toString()}",
                              fit: BoxFit.cover,
                              errorWidget: (con, str, dy) {
                                return Image.asset(
                                  "assets/images/default_image.jpeg",
                                  fit: BoxFit.cover,
                                );
                              },
                              progressIndicatorBuilder: (con, str, progress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                      value: progress.progress),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _detailPage!.chanel!.chanel.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(fontFamily: "ProximaNova"),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _detailPage!.chanel!.location.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontFamily: "ProximaNova"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: (_commentRes != null &&
                                subscribedList
                                    .where((element) =>
                                        element.slug ==
                                        _commentRes!.chanel!.slug)
                                    .isNotEmpty)
                            ? Colors.grey
                            : Colors.blue, // Background color
                      ),
                      onPressed: () async {
                        final result = await Api.subscribe({
                          "id": UtilPreferences.getString(Preferences.clientId),
                          // "reviewer":_detailPage!.review.id.toString(),
                          "reviewer": _commentRes!.chanel!.id.toString(),
                          "xhr": "1"
                        });
                        print(result);
                        print(jsonDecode(result));
                        var jsonResp = jsonDecode(result);

                        await Api.getSubscribedList();

                        setState(() {});
                        /*  Fluttertoast.showToast(
                            msg: "Subscribed successfully", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT, // location
                            timeInSecForIosWeb: 1 // duration
                            );*/
                      },
                      child: Text(
                          (_commentRes != null &&
                                  subscribedList
                                      .where((element) =>
                                          element.slug ==
                                          _commentRes!.chanel!.slug)
                                      .isNotEmpty)
                              ? 'Subscribed'
                              : 'Subscribe',
                          style: Theme.of(context).textTheme.button!.copyWith(
                              fontFamily: "ProximaNova", color: Colors.white))),
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
          _buildRelatedVideo(),
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

  void onViewPlayerCreated(viewPlayerController) {
    /*this.viewPlayerController = viewPlayerController;

    this.viewPlayerController!.loadUrl(_detailPage?.review.video ?? '');*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: width,
                  child: _controller == null
                      ? Center(child: CircularProgressIndicator())
                      : VisibilityDetector(
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (info.visibleFraction == 0) {
                        _controller?.pause();
                      }
                    },
                        key: Key("null"),
                        child: VlcPlayerWithControls(
                            controller: _controller!,
                            onStopRecording: (recordPath) {
                              // setState(() {});
                            },
                          ),
                      ), /*Stack(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if(showControls == false){
                                      _controller!.pause();
                                      showControls = true;
                                      setState(() {});
                                      Future.delayed(Duration(seconds: 3), () {
                                        showControls = false;
                                        setState(() {});
                                      });
                                    }
                                  },
                                  child: VlcPlayer(
                                    controller: _controller!,
                                    aspectRatio: 16 / 9,
                                    placeholder:
                                        Center(child: CircularProgressIndicator()),
                                  ),
                                ),
                                Center(
                                  */ /*child: IconButton(
                                    icon: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                    onPressed: ()async{
                                      _controller!.value.isPlaying
                                      ? await _controller!.pause()
                                      : await _controller!.play();
                                    },
                                  ),*/ /*
                                  child: FutureBuilder<bool?>(
                                    future: _controller!.isPlaying(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == null ||
                                          snapshot.data! == false) {
                                        return IconButton(
                                          onPressed: () {
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              _controller!.play();
                                            }
                                          },
                                          icon: Icon(Icons.play_arrow),
                                        );
                                      } else {
                                        return IconButton(
                                          onPressed: () {
                                            _controller!.pause();
                                            showControls = true;
                                            setState(() {});
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              showControls = false;
                                              setState(() {});
                                            });
                                          },
                                          icon: Icon(Icons.pause),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),*/
                ),
                /*_chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                        ? VisibilityDetector(
                      key: const Key("unique key"),
                      onVisibilityChanged: (VisibilityInfo info) {
                        debugPrint(
                            "${info.visibleFraction} of my widget is visible");
                        if (info.visibleFraction == 0) {
                          print("Pause Video");
                          _chewieController?.pause();
                        }
                      },
                      child: SizedBox(
                        //aspectRatio: _controller.value.aspectRatio,
                        height: 200,
                        child: Chewie(
                          controller: _chewieController!,
                        ),
                      ),
                    )
                        : const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),*/
                /*VisibilityDetector(
                      onVisibilityChanged: (VisibilityInfo info) {
                        if (info.visibleFraction == 0) {
                          player.pause();
                        }
                      },
                      key: Key(_detailPage?.review.video ?? ''),
                      child: FijkView(
                        player: player,
                        panelBuilder: fijkPanel2Builder(snapShot: true),
                        fsFit: FijkFit.cover,
                        color: Colors.black,
                        fit: FijkFit.fitHeight,
                        height: 200,
                      ),
                    ),*/
                Positioned(
                  top: 5,
                  left: 5,
                  child: InkWell(
                    onTap: Navigator.of(context).pop,
                    child: const SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildContent(),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _onTouch = false;
      });
    });
  }
}
