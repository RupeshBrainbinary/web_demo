import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/screens/my_video/my_videos.dart';
import 'package:web_demo/screens/privacy_policy/privacy_policy.dart';
import 'package:web_demo/screens/profile_link/profile_link.dart';
import 'package:web_demo/screens/termes_condition/terms_conditions.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On logout
  void _onLogout() async {
    AppBloc.loginCubit.onLogout();
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.notifications_active_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            _onNavigate(Routes.notification);
          },
        ),
        title: Text(
          Translate.of(context).translate('profile'),
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontFamily: "ProximaNova"),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('sign_out'),
            type: ButtonType.text,
            onPressed: _onLogout,
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserModel?>(
        builder: (context, user) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).dividerColor.withOpacity(
                              .05,
                            ),
                            spreadRadius: 4,
                            blurRadius: 4,
                            offset: const Offset(
                              0,
                              2,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: AppUserInfo(
                        user: user,
                        type: AppUserType.information,
                        onPressed: () {
                          },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: AppProfilePerformance(user: user),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: <Widget>[
                        AppListTitle(
                          title: Translate.of(context).translate(
                            'edit_profile',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            _onNavigate(Routes.editProfile);
                          },
                        ),
                        AppListTitle(
                          title: Translate.of(context).translate(
                            'change_password',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            _onNavigate(Routes.changePassword);
                          },
                        ),
                        /* AppListTitle(
                          title: Translate.of(context).translate(
                            'Review History',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            _onNavigate(Routes.changePassword);
                          },
                        ),*/
                        AppListTitle(
                          title: Translate.of(context).translate(
                            'Profile link',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileLink()));
                          },
                        ),
                        /* AppListTitle(
                          title: Translate.of(context)
                              .translate('Monetization plan'),
                          onPressed: () {
                            _onNavigate(Routes.contactUs);
                          },
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),*/
                        /*     AppListTitle(
                          title: Translate.of(context).translate('Subscribers'),
                          onPressed: () {
                            _onNavigate(Routes.contactUs);
                          },
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),*/
                        AppListTitle(
                          title:
                          Translate.of(context).translate('about'),
                          onPressed: () {
                            _onNavigate(Routes.aboutUs);
                          },
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),
                        AppListTitle(
                          title: Translate.of(context).translate('my_videos'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const MyVideos()));
                          },
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),

                        AppListTitle(
                          title: Translate.of(context).translate('setting'),
                          onPressed: () {
                            _onNavigate(Routes.setting);
                          },
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              textDirection: TextDirection.ltr,
                            ),
                          ),

                        ),
                        /*AppListTitle(
                          title: Translate.of(context).translate(
                            'Terms_condition',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TermsConditionsScreen();
                            },));

                          },
                        ),
                        AppListTitle(
                          title: Translate.of(context).translate(
                            'privacy_policy',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).iconTheme.color,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return PrivacyPolicyScreen();
                            },));

                          },
                          border: false,
                        ),*/

                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
