import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_channel.dart';
import 'package:web_demo/models/screen_models/screen_models.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class ChannelsView extends StatefulWidget {
  const ChannelsView({Key? key}) : super(key: key);

  @override
  _ChannelsViewState createState() {
    return _ChannelsViewState();
  }
}

class _ChannelsViewState extends State<ChannelsView> {
  ChannelPageModel? _listPage;
  bool isShow = false;

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
    final result = await Api.getReviewerChannels();
    if (result.success) {
      setState(() {
        _listPage = ChannelPageModel.fromJson(result.data);
      });
    }
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  ///On navigate channel detail
  void _onChannelDetail(ChannelModel item) {
    Navigator.pushNamed(context, Routes.profileReviewer, arguments: {'slug':item.slug});
    //Navigator.pushNamed(context, Routes.channelDetail, arguments: item);
  }

  ///Build list
  Widget _buildList() {
    if (_listPage == null) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppReviewItem(
              type: ProductViewType.small,
            ),
          );
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        itemCount: _listPage!.channels.length,
        itemBuilder: (context, index) {
          final item = _listPage!.channels[index];
          return AppChannelItem(
            type: ProductViewType.small,
            item: item,
            onPressed: () {
              _onChannelDetail(item);
            },

           /* onSubscribe: () async {
              final result = await Api.subscribe({
                "id":UtilPreferences.getString(Preferences.clientId),
                "reviewer":item.id.toString(),
                "xhr":"1"
              });
              print(result);
              print(jsonDecode(result));
              var jsonResp = jsonDecode(result);
              if (jsonResp['status'] == 1) {
                isShow = true;

              }else{
                isShow = false;
              }
              setState(() {

              });
              Fluttertoast.showToast(
                  msg: "Subscribed successfully", // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.BOTTOM_LEFT, // location
                  timeInSecForIosWeb: 1 // duration
                  );
            },*/
            subTitleIn2Line: true,
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 15.0,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('Explore Review Channels',),
          style: Theme.of(context)
              .textTheme
              .headline6!.copyWith(fontFamily: "ProximaNova"),//wish_list
        ),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }
}
