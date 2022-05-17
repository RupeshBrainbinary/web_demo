import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/screen_models/screen_models.dart';
import 'package:web_demo/models/screen_models/search_history_real_estate_page_model.dart';
import 'package:web_demo/screens/product_detail_real_estate/product_detail_real_estate.dart';
import 'package:web_demo/screens/search_history_real_estate/search_result_real_estate_list.dart';
import 'package:web_demo/screens/search_history_real_estate/search_suggest_real_estate_list.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class SearchHistoryRealEstate extends StatefulWidget {
  const SearchHistoryRealEstate({Key? key}) : super(key: key);

  @override
  _SearchHistoryRealEstateState createState() {
    return _SearchHistoryRealEstateState();
  }
}

class _SearchHistoryRealEstateState extends State<SearchHistoryRealEstate> {
  RealEstateSearchDelegate? _delegate;
  SearchHistoryRealEstatePageModel? _historyPage;

  @override
  void initState() {
    super.initState();
    _delegate = RealEstateSearchDelegate(onProductDetail: _onProductDetail);
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Fetch API
  void _loadData() async {
    setState(() {
      _historyPage = null;
    });
    final result = await Api.getHistorySearch();
    if (result.success) {
      setState(() {
        _historyPage = SearchHistoryRealEstatePageModel.fromJson(result.data);
      });
    }
  }

  void _onSearch() {
    showSearch(
      context: context,
      delegate: _delegate!,
    );
  }

  ///On navigate list product
  void _onProductList(CategoryModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }

  ///On navigate product detail
  Future<void> _onProductDetail(ReviewModel item) async {
    await player.reset();
    Navigator.pushNamed(context, Routes.productDetail, arguments: item).whenComplete((){
      player.reset();
    });
  }

  ///Build list tag
  List<Widget> _listTag(BuildContext context) {
    if (_historyPage == null) {
      return List.generate(6, (index) => index).map(
        (item) {
          return AppPlaceholder(
            child: AppTag(
              Translate.of(context).translate('loading'),
            ),
          );
        },
      ).toList();
    }

    return _historyPage!.history.map((item) {
      return IntrinsicWidth(
        child: AppTag(
          item.clientName,
          type: TagType.chip,
          onPressed: () {
            _onProductDetail(item);
          },
        ),
      );
    }).toList();
  }

  ///Build list discover
  List<Widget> _listDiscover(BuildContext context) {
    if (_historyPage == null) {
      return List.generate(6, (index) => index).map(
        (item) {
          return AppPlaceholder(
            child: AppTag(
              Translate.of(context).translate('loading'),
            ),
          );
        },
      ).toList();
    }

    return _historyPage!.discover.map((item) {
      return IntrinsicWidth(
        child: AppTag(
          item.title,
          type: TagType.chip,
          onPressed: () {
            _onProductList(item);
          },
        ),
      );
    }).toList();
  }

  ///Build popular
  List<Widget> _listRecently() {
    if (_historyPage == null) {
      return List.generate(8, (index) => index).map(
        (item) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AppReviewItem(
              type: ProductViewType.cardSmall,
            ),
          );
        },
      ).toList();
    }

    return _historyPage!.recently.map(
      (item) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AppReviewItem(
            onPressed: () {
              _onProductDetail(item);
            },
            item: item,
            type: ProductViewType.cardSmall,
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            color:Theme.of(context).iconTheme.color,
            progress: _delegate!.transitionAnimation,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('search_title'),
          style: Theme.of(context)
              .textTheme
              .headline6!.copyWith(fontFamily: "ProximaNova"),
        ),
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.search,color: Theme.of(context).iconTheme.color,),
            onPressed: _onSearch,
          ),
          IconButton(
            icon:  Icon(Icons.refresh,color: Theme.of(context).iconTheme.color,),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('search_history'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          _historyPage!.history.clear();
                          setState(() {});
                        },
                        child: Text(
                          Translate.of(context).translate('clear'),
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _listTag(context),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: _listDiscover(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                Translate.of(context).translate('recently_viewed'),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 4,
                ),
                scrollDirection: Axis.horizontal,
                children: _listRecently(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RealEstateSearchDelegate extends SearchDelegate {
  final Function(ReviewModel) onProductDetail;

  Timer? timer;

  RealEstateSearchDelegate({
    required this.onProductDetail,
  });

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        ReviewModel? product;
        close(context, product);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    AppBloc.searchCubit.onSearch(query);
    return SuggestionList(
      query: query,
      onProductDetail: onProductDetail,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultList(
      query: query,
      onProductDetail: onProductDetail,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
    return null;
  }
}
