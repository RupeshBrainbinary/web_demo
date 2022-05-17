import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/configs/routes.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/screens/product_detail_real_estate/product_detail_real_estate.dart';
import 'package:web_demo/utils/translate.dart';
import 'package:web_demo/widgets/app_review_item.dart';

class MyVideos extends StatefulWidget {
  const MyVideos({Key? key}) : super(key: key);

  @override
  State<MyVideos> createState() => _MyVideosState();
}

class _MyVideosState extends State<MyVideos> {
  List<ReviewModel> _myVideos = [];
  bool _loader = false;

  @override
  void initState() {
    getVideos();
    super.initState();
  }

  getVideos() async {
    _loader = true;
    setState(() {});
    _myVideos = await Api.getMyVideos();
    _loader = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translate.of(context).translate('my_videos'),
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(fontFamily: "ProximaNova"),
        ),
      ),
      body: _loader ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: [_buildRelatedVideos()],
        ),
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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      crossAxisCount: 2,
      childAspectRatio: ratio,
      children: _myVideos.map((item) {
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

  Future<void> _onProductDetail(ReviewModel item) async {
    await player.reset();
    Navigator.pushNamed(context, Routes.productDetail, arguments: item)
        .whenComplete(() {
      player.reset();
    });
  }
}
