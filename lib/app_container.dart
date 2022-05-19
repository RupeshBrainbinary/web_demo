import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/screens/screen.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  _AppContainerState createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> {
  String _selected = Routes.home;

  @override
  void initState() {
    super.initState();
  }

  ///check route need auth
  bool _requireAuth(String route) {
    switch (route) {
      case Routes.home:
      case Routes.discovery:
        return false;
      default:
        return true;
    }
  }

  ///Export index stack
  int _exportIndexed(String route) {
    switch (route) {
      case Routes.home:
        return 0;
      case Routes.categoryList:
        return 1;
      case Routes.category:
        return 2;
      case Routes.account:
        return 3;
      default:
        return 0;
    }
  }

  ///Force switch home when authentication state change
  void _listenAuthenticateChange(AuthenticationState authentication) async {
    if (authentication == AuthenticationState.fail && _requireAuth(_selected)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: _selected,
      );
      if (result != null) {
        setState(() {
          _selected = result as String;
        });
      } else {
        setState(() {
          _selected = Routes.home;
        });
      }
    }
  }

  ///On change tab bottom menu and handle when not yet authenticate
  void _onItemTapped({
    required String route,
    required bool authenticated,
  }) async {
    if (!authenticated && _requireAuth(route)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: route,
      );
      if (result == null) return;
    }
    setState(() {
      _selected = route;
    });
  }

  ///On handle submit post
  void _onSubmit(bool authenticated) async {
    if (!authenticated) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.submit,
      );
      if (result == null) return;
    }
    Navigator.pushNamed(context, Routes.submit);
  }

  ///Build Item Menu onCategoryList
  Widget _buildMenuItem({
    required String route,
    required bool authenticated,
  }) {
    Color? color;
    String title = 'home';
    IconData iconData = Icons.help_outline;
    switch (route) {
      case Routes.home:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
      case Routes.category:
        iconData = Icons.chat_outlined;
        title = 'Categories';
        break;
      case Routes.categoryList:
        iconData = Icons.bookmark_outline;
        title = 'Channels';
        break;
      case Routes.account:
        iconData = Icons.account_circle_outlined;
        title = 'account';
        break;
      default:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
    }
    if (route == _selected) {
      color = Theme.of(context).primaryColor;
    }
    return IconButton(
      onPressed: () {
        _onItemTapped(route: route, authenticated: authenticated);
      },
      padding: EdgeInsets.zero,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: color,
          ),
          const SizedBox(height: 2),
          Text(
            Translate.of(context).translate(title),
            style: Theme.of(context).textTheme.button!.copyWith(
                  fontSize: 10,
                  color: color,
              fontFamily: "ProximaNova"
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const centerDocked = FloatingActionButtonLocation.centerDocked;
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, authentication) async {
        _listenAuthenticateChange(authentication);
      },
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, authentication) {
          final authenticated = authentication != AuthenticationState.fail;
          return Scaffold(
            body: IndexedStack(
              index: _exportIndexed(_selected),
              children: const <Widget>[
                Home(),
                ChannelsView(),
                Category(),
                Profile()
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMenuItem(
                      route: Routes.home,
                      authenticated: authenticated,
                    ),
                    _buildMenuItem(
                      route: Routes.categoryList,
                      authenticated: authenticated,
                    ),
                    Container(
                      width: 56,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Text(
                          "Record",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.button!.copyWith(
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ),
                    _buildMenuItem(
                      route: Routes.category,
                      authenticated: authenticated,
                    ),
                    _buildMenuItem(
                      route: Routes.account,
                      authenticated: authenticated,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Showcase(
              key: Application.globalKey['submit']!,
              description: Translate.of(context).translate(
                'submit_listing',
              ),
              shapeBorder: const CircleBorder(),
              child: FloatingActionButton(
                heroTag: "submit",
                backgroundColor: Colors.red,
                onPressed: () {
                  _onSubmit(authenticated);
                },
                child: const Icon(
                  Icons.video_call_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            floatingActionButtonLocation: centerDocked,
          );
        },
      ),
    );
  }
}
