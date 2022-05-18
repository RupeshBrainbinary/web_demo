import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/models/screen_models/aboutus_page_model.dart';
import 'package:web_demo/utils/translate.dart';
import 'package:web_demo/widgets/app_placeholder.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() {
    return _AboutUsState();
  }
}

class _AboutUsState extends State<AboutUs> {
  AboutUsPageModel? _aboutUsPage;

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
    final result = await Api.getAboutUs();
    if (result.success) {
      setState(() {
        _aboutUsPage = AboutUsPageModel.fromJson(result.data);
      });
    }
  }

  ///Build Banner
  Widget _buildBanner() {
    if (_aboutUsPage?.banner == null) {
      return AppPlaceholder(
        child: Container(
          color: Colors.white,
        ),
      );
    }

    return Image.asset(
      _aboutUsPage!.banner,
      fit: BoxFit.cover,
    );
  }

  ///Build WhoWeAre
  Widget _buildWhoWeAre() {
    if (_aboutUsPage?.whoWeAre == null) {
      return AppPlaceholder(
          child: Column(
            children: [1, 2, 3, 4, 5].map((item) {
              return Container(
                height: 10,
                margin: const EdgeInsets.only(bottom: 4),
                color: Colors.white,
              );
            }).toList(),
          ));
    }

    return Text(
      _aboutUsPage!.whoWeAre,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontFamily: "ProximaNova"),
    );
  }

  ///Build WhatWeD
  Widget _buildWhatWeDo() {
    if (_aboutUsPage?.whatWeDo == null) {
      return AppPlaceholder(
        child: Column(
          children: [1, 2, 3, 4, 5].map((item) {
            return Container(
              height: 15,
              margin: const EdgeInsets.only(bottom: 4),
              color: Colors.white,
            );
          }).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _aboutUsPage!.whatWeDo.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            item,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }).toList(),
    );
  }

  ///Build Team
  Widget _buildTeam() {
    if (_aboutUsPage?.team == null) {
      return AppPlaceholder(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 16,
          children: [1, 2, 3, 4].map((item) {
            return FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(8),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 16,
      children: _aboutUsPage!.team.map((item) {
        return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item.avatar),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.status,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.white,fontFamily: "ProximaNova"),
                    ),
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: Text(
                  Translate.of(context).translate('about_us'),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!.copyWith(fontFamily: "ProximaNova")
              ),
           /*     expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: _buildBanner(),
              ),*/
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/about_us_banner.jpeg",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Translate.of(context).translate('who_we_are'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            Translate.of(context).translate('who_we'),
                          ),
                          const SizedBox(height: 8),
                          // _buildWhoWeAre(),
                          const SizedBox(height: 16),
                          Text(
                            Translate.of(context).translate('what_we_do'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            Translate.of(context).translate('what_we'),
                          ),
                          const SizedBox(height: 4),
                          // _buildWhatWeDo(),
                        ],
                      ),
                    ),
                      /* Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Text(
                        Translate.of(context).translate('meet_our_team'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: _buildTeam(),
                    )*/
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
