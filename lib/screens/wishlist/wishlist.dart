import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/screen_models/screen_models.dart';
import 'package:web_demo/screens/product_detail_real_estate/product_detail_real_estate.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() {
    return _WishListState();
  }
}

class _WishListState extends State<WishList> {
  WishListPageModel? _listPage;

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
    final result = await Api.getWishList();
    if (result.success) {
      setState(() {
        _listPage = WishListPageModel.fromJson(result.data);
      });
    }
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  ///On navigate product detail
  Future<void> _onProductDetail(ProductModel item) async {
    // await player.reset();
    Navigator.pushNamed(context, Routes.productDetail, arguments: item).whenComplete((){
      // player.reset();
    });
  }

  ///Build list
  Widget _buildList() {
    if (_listPage == null) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: AppProductItem(
              type: ProductViewType.small,
            ),
          );
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _listPage!.list.length,
        itemBuilder: (context, index) {
          final item = _listPage!.list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppProductItem(
              onPressed: () {
                _onProductDetail(item);
              },
              item: item,
              type: ProductViewType.small,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('wish_list'),
        ),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }
}
