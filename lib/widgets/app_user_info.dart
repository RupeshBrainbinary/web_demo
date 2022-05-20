import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/widgets/widget.dart';

enum AppUserType { basic, information }

class AppUserInfo extends StatelessWidget {
  final UserModel? user;
  final VoidCallback? onPressed;
  final AppUserType type;

  const AppUserInfo({
    Key? key,
    this.user,
    this.onPressed,
    this.type = AppUserType.basic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      switch (type) {
        case AppUserType.information:
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        default:
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          );
      }
    }

    switch (type) {
      case AppUserType.information:
        return InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      /*image: DecorationImage(
                        image: AssetImage(user!.avatar),
                        fit: BoxFit.cover,
                      ),*/
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: CachedNetworkImage(
                        imageUrl: "https://www.thereviewclip.com/uploads/client_logo/"+ user!.avatar.toString(),
                        errorWidget: (con, str, dy) {
                          return SizedBox();
                          /*return Image.asset(
                            "assets/images/default_image.jpeg",
                            fit: BoxFit.cover,
                          );*/
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),

                  )
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user!.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user!.chanel,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user!.location,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontFamily: "ProximaNova"),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // const SizedBox(
                  //   height: 4,
                  //   width: 12,
                  // ),

                  /*      ElevatedButton(
                      onPressed: ()  {
                        Fluttertoast.showToast(
                            msg: "Subscribed successfully", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT, // location
                            timeInSecForIosWeb: 1 // duration
                            );
                      },
                      child:  Text('Subscribe', style: Theme.of(context)
                          .textTheme
                          .button!.copyWith(fontFamily: "ProximaNova"))),*/
                ],
              ),
              // RotatedBox(
              //   quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //   child: const Icon(
              //     Icons.keyboard_arrow_right,
              //   ),
              // ),
            ],
          ),
        );
      default:
        return Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    user!.avatar,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user!.name,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                Text(
                  user!.chanel,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontFamily: "ProximaNova"),
                )
              ],
            )
          ],
        );
    }
  }
}
