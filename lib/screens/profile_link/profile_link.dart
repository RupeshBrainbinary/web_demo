import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/models/reviewer_profile_model.dart';
import 'package:web_demo/utils/translate.dart';

class ProfileLink extends StatefulWidget {
  final String slug;

  const ProfileLink({Key? key, required this.slug}) : super(key: key);

  @override
  State<ProfileLink> createState() => _ProfileLinkState();
}

class _ProfileLinkState extends State<ProfileLink> {
  var result;
  Map<String, dynamic> map = {};
  bool _loader = false;
  ReviewerProfileModel reviewerModel = ReviewerProfileModel();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    _loader = true;
    setState(() {});
    result = await Api.getLoadProfileLink();
    map = result as Map<String, dynamic>;
    await getReviewerData();

    setState(() {});
    _loader = false;
  }

  Future<void> getReviewerData() async {
    reviewerModel = await Api.reviewersProfile(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translate.of(context).translate(
            'profile_link',
          ),
          style: TextStyle(fontFamily: "ProximaNova"),
        ),
      ),
      body: _loader
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                          child: Text(
                            map.isEmpty ? "" : map['data']['url'].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontFamily: "ProximaNova"),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(),
                        child: InkWell(
                          onTap: () async {
                            /*await Share.share(
                          map.isEmpty ? "" : map['data']['url'].toString());*/

                            var imageId = await ImageDownloader.downloadImage(
                                reviewerModel.avatar.toString());
                            if (imageId == null) {
                              return;
                            }
                            var path = await ImageDownloader.findPath(imageId);
                            String content = "Reviewer: " +
                                reviewerModel.profileStats!.displayName.toString() +
                                '\n' +
                                "Location: " +
                                reviewerModel.profileStats!.location.toString() +
                                '\n\n' +
                                "Link: " +
                                map['data']['url'].toString();
                            await Share.shareFiles([path.toString()],
                                text: content);
                          },
                          child: Icon(
                            Icons.share,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
