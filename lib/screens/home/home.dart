import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/app.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/banner_model.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_channel.dart';
import 'package:web_demo/models/screen_models/category_page_model.dart';
import 'package:web_demo/models/screen_models/home_real_estate_page_model.dart';
import 'package:web_demo/repository/category_repository.dart';
import 'package:web_demo/screens/search_history_real_estate/search_history_real_estate.dart';
import 'package:web_demo/screens/submit/submit.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

import 'appbar_home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  HomeRealEstatePageModel? _homePage;
  CountryModel? _countrySelected;
  TextEditingController country = TextEditingController();
  Map<String, List<ReviewModel>> _videoByCategory = {};
  List<CategoryModel> categoryList = [];
  List<BannerData> bannerList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On navigate list product
  void _openCategory(CategoryModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }

  ///Fetch API
  void _loadData() async {
    Api.getSubscribedList();
    final result = await Api.getHome();
    if (result.success) {
      _homePage = HomeRealEstatePageModel.fromJson(result.data);
      if (UtilPreferences.getInt(Preferences.countryId) == null) {
        _countrySelected = _homePage!.country.first;
      } else {
        _countrySelected = _homePage!.country
            .where((element) =>
                element.id == UtilPreferences.getInt(Preferences.countryId))
            .first;
      }
    }
    BannerModel? bannerModel = await Api.getBannerList();
    if (bannerModel != null) {
      bannerList = bannerModel.bannerData ?? [];
    }
    CategoryPageModel? categoryPageModel =
        await CategoryRepository.loadCategories();
    if (categoryPageModel != null) {
      categoryList = categoryPageModel.categories;
    }
    _getVideoByCategory(categoryList);
    setState(() {});
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadData();
  }

  ///On navigate product detail
  Future<void> _openReviewInfo(ReviewModel item) async {
    // await player.reset();
    Navigator.pushNamed(context, Routes.productDetail, arguments: item)
        .whenComplete(() {
      // player.reset();
    });
  }

  ///On navigate channel detail
  void _onChannelDetail(ChannelModel item) {
    Navigator.pushNamed(context, Routes.profileReviewer, arguments: {
      'slug': item.slug,
    });
  }

  ///On search
  void _onSearch() {
    if (_videoByCategory.isEmpty) {
      return;
    }
    List<ReviewModel> list = [];
    for (var element in _videoByCategory.values) {
      list.addAll(element);
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SearchHistoryRealEstate(videoCatagoryes: list);
      },
    ));
    // Navigator.pushNamed(context, Routes.searchHistory);
  }

  ///On select country
  Future<void> _onSelectCountry() async {
    final item = await showModalBottomSheet<CountryModel?>(
      context: context,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
              data: _homePage!.country,
              selected: [_countrySelected],
              controller: country),
        );
      },
    );
    if (item != null) {
      UtilPreferences.setInt(Preferences.countryId, item.id);
      _getVideoByCategory(categoryList);
      //await AppBloc.categoryCubit.loadCategories();
      _countrySelected = item;

      setState(() {});
    }
  }

  ///Build list category
  Widget _buildCategory() {
    if (categoryList.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(left: 8, right: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return AppPlaceholder(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: 8,
      );
    }

    if (categoryList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          Translate.of(context).translate('data_not_found'),
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(fontFamily: "ProximaNova"),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 8, right: 8),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        List<ReviewModel> list = [];

        for (int i = 0; i < 15; i++) {
          if (_homePage!.popular.length > i) {
            list.add(_homePage!.popular[i]);
          }
        }
        final item = categoryList[index];
        // print(item);
        return Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: InkWell(
            onTap: () {
              _openCategory(item);
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.3),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: SvgPicture.network(
                      item.icon,
                      color: item.color,
                      placeholderBuilder: (BuildContext context) =>
                          const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontFamily: "ProximaNova"))
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 8);
      },
      itemCount: categoryList.length,
    );
  }

  ///Build Channels
  Widget _buildChannels() {
    Widget content = ListView.separated(
      padding: const EdgeInsets.only(left: 8, right: 8),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return AppPlaceholder(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Translate.of(context).translate('loading'),
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(fontFamily: "ProximaNova"),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 4);
      },
      itemCount: 8,
    );

    if (_homePage != null) {
      content = ListView.separated(
        padding: const EdgeInsets.only(left: 8, right: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = _homePage!.channels[index];
          return AppChannelItem(
            type: ProductViewType.gird,
            item: item,
            onPressed: () {
              _onChannelDetail(item);
            },
            /*onSubscribe: () {
              Fluttertoast.showToast(
                  msg: "Subscribed successfully", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.BOTTOM_LEFT, // location
                  timeInSecForIosWeb: 1 // duration
                  );
            },*/
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 4);
        },
        itemCount: _homePage!.channels.length,
      );

      ///Empty
      if (_homePage!.channels.isEmpty) {
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
      }
    }

    ///Build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 4,
                height: 1.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                Translate.of(context).translate('review_channels'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: content,
        )
      ],
    );
  }

  ///Build Popular
  Widget _buildPopular() {
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

    if (_homePage != null) {
      ///Empty
      if (_homePage!.popular.isEmpty) {
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
        List<ReviewModel> list = [];
        for (int i = 0; i < 15; i++) {
          if (_homePage!.popular.length > i) {
            list.add(_homePage!.popular[i]);
          }
        }
        content = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list
                  .map((item) => Container(
                        width: 200,
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: AppReviewItem(
                          item: item,
                          onPressed: () {
                            _openReviewInfo(item);
                          },
                          type: ProductViewType.gird,
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      }
    }

    ///Build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                thickness: 4,
                height: 1.0,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                Translate.of(context).translate('trending_reviews'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
              ),
              Text(
                Translate.of(context).translate('let_find_best_price'),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontFamily: "ProximaNova"),
              ),
            ],
          ),
        ),
        content
      ],
    );
  }

  ///Build Popular
  Widget _buildBanners() {
    if (bannerList.isEmpty) {
      return SizedBox();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(
            thickness: 4,
            height: 1.0,
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          height: width * 0.5,
          width: width,
          child: CarouselSlider.builder(
            itemCount: bannerList.length,
            itemBuilder: (BuildContext context, int index, int pageIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Submit(bannerId: bannerList[index].banner!.clentId)));
                  },
                  child: CachedNetworkImage(
                    imageUrl: bannerList[index].banner!.clentBanner.toString(),
                    progressIndicatorBuilder: (con, str, progress) {
                      return Container(
                        height: width * 0.55,
                        width: width,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              );
            },
            options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 2.5,
              autoPlay: true,
              enableInfiniteScroll: false,
            ),
          ),
        ),
      ],
    );
  }

  ///Build category videos
  Widget _buildCategoryVideos(CategoryModel category) {
    bool showZero = false;
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

    if (_homePage != null) {
      ///Empty
      if (_homePage!.popular.isEmpty ||
          _videoByCategory[category.id.toString()] == null) {
        showZero = true;
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
        /*      List<ReviewModel> productPage =
            _videoByCategory[category.id.toString()]!;*/
        List<ReviewModel> productPage = [];
        for (int i = 0; i < 15; i++) {
          if (_videoByCategory[category.id.toString()]!.length > i) {
            productPage.add(_videoByCategory[category.id.toString()]![i]);
          }
        }
        showZero = productPage.isEmpty;
        content = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productPage
                  .map((item) => Container(
                        width: 200,
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: AppReviewItem(
                          item: item,
                          onPressed: () {
                            _openReviewInfo(item);
                          },
                          type: ProductViewType.gird,
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      }
    }

    ///Build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 4,
          height: 1.0,
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: "ProximaNova"),
                    ),
                    showZero
                        ? Text("0 Videos")
                        : Text(
                            "${category.count} Videos",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontFamily: "ProximaNova"),
                          ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  _openCategory(category);
                },
                child: Text(
                  "View All",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontFamily: "ProximaNova"),
                ),
              ),
            ],
          ),
        ),
        content,
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _getVideoByCategory(List<CategoryModel> categoryList) async {
    Map<String, List<ReviewModel>> tempList = {};
    for (var cat in categoryList) {
      ResultApiModel res = await Api.getProduct(cat.id);
      print(res);
      if (res.data != null) {
        List<ReviewModel> list =
            res.data!.map<ReviewModel>((e) => ReviewModel.fromJson(e)).toList();
        tempList[cat.id.toString()] = list;
      }
    }
    _videoByCategory = tempList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: AppBarHome(
              maxHeight: 112 + MediaQuery.of(context).padding.top,
              minHeight: 60 + MediaQuery.of(context).padding.top,
              country: _homePage?.country,
              countrySelected: _countrySelected,
              onLocation: _onSelectCountry,
              onSearch: _onSearch,
            ),
            pinned: true,
            floating: true,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _onRefresh,
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 80,
                    child: _buildCategory(),
                  ),
                  const SizedBox(height: 8),
                  _buildPopular(),
                  const SizedBox(height: 8),
                  _buildBanners(),
                  const SizedBox(height: 8),
                  _buildChannels(),
                  const SizedBox(height: 8),
                  categoryList.isEmpty
                      ? const SizedBox()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: categoryList.map((category) {
                            return _buildCategoryVideos(category);
                          }).toList()),
                  //additional height for record button
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
