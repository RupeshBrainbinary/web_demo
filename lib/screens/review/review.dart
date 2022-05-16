import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/comment_model.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class Review extends StatefulWidget {
  final String videoSlug;
  final int videoId;

  const Review({
    Key? key,
    required this.videoSlug,
    required this.videoId,
  }) : super(key: key);

  @override
  _ReviewState createState() {
    return _ReviewState();
  }
}

class _ReviewState extends State<Review> {
  //ReviewPageModel? _reviewPage;
  CommentRes? _reviewPage;

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
    _reviewPage = await Api.getCommentsLikesData(widget.videoSlug,
        UtilPreferences.getString(Preferences.clientId) ?? '');
    setState(() {});
    /*final result = await Api.getReview();
    if (result.success) {
      setState(() {
        _reviewPage = ReviewPageModel.fromJson(result.data);
      });
    }*/
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  ///On navigate write review
  void _onWriteReview() {
    Navigator.pushNamed(context, Routes.writeReview, arguments: widget.videoId)
        .whenComplete(() {
      _reviewPage = null;
      setState(() {});
      _loadData();
    });
  }

  ///Build list
  Widget _buildList() {
    if (_reviewPage == null) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: AppCommentItem(),
          );
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        itemCount:
            _reviewPage!.comments == null ? 0 : _reviewPage!.comments!.length,
        itemBuilder: (context, index) {
          final item = _reviewPage!.comments![index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCommentItem(item: item),
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
          // Translate.of(context).translate('review')
          Translate.of(context).translate('Comments'),
        ),
        actions: <Widget>[
          AppButton(
            Translate.of(context).translate('write'),
            onPressed: _onWriteReview,
            type: ButtonType.text,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: AppRating(
            //       // rate: _reviewPage?.rate,
            //       ),
            // ),
            Expanded(child: _buildList())
          ],
        ),
      ),
    );
  }
}
