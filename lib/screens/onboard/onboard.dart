import 'package:flutter/material.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() {
    return _IntroState();
  }
}

class _IntroState extends State<Intro> {
  @override
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'From ReVIEW to RePLAY',
      'image': Images.intro1,
      'content':
          'The first of its kind “Video Review Platform” that revolutionizes the conventional system of reviews.'
              ' With the world moving towards digitalization Video Reviews are most definitely the wave of the future.',
    },
    {
      'title': 'Become a Reviewer',
      'image': Images.intro2,
      'content':
          'We provide a platform to record your reviews & share your experience on different products, brands, '
              'business & even social issues through a video clip',
    },
    {
      'title': 'Broader Brand Visibility',
      'image': Images.intro3,
      'content':
          'With Companies and leading Brands looking for new ways to increase their digital presence we '
              'believe that our application offers a unique \'Video Review\' tool that provides a new platform to enhance their brand visibility.',
    },
  ];

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On complete preview intro
  void _onCompleted() {
    AppBloc.applicationCubit.onCompletedIntro();
  }

  Widget _bottomDots() {
    return SizedBox(
      height: 7,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            height: 7,
            width: _currentPage == index ? 20 : 7,
            duration: const Duration(microseconds: 800),
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _currentPage == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    ///List Intro view page model
    /*final List<PageViewModel> pages = [
      PageViewModel(
        // pageColor: const Color(0xff93b7b0),
        pageColor: Colors.transparent,
        pageBackground: Image.asset(
          Images.introBackground,
          fit: BoxFit.cover,
        ),
        bubble: const Icon(
          Icons.shop,
          color: Colors.blueAccent,
        ),
        body: Text(
          "The first of its kind “Video Review Platform” that revolutionizes the conventional system of reviews. With the world moving towards digitalization Video Reviews are most definitely the wave of the future.",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black
              ,fontFamily: "ProximaNova"
              ),
        ),
        title: Text(
          "From ReVIEW to RePLAY",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.blue,fontFamily: "ProximaNova"),
        ),

        mainImage: Image.asset(
          Images.intro1,
          fit: BoxFit.contain,
        ),
      ),
      PageViewModel(
        pageColor: Colors.transparent,
        pageBackground: Image.asset(
          Images.introBackground,
          fit: BoxFit.cover,
        ),
        bubble: const Icon(
          Icons.phonelink,
          color: Colors.blue,
        ),
        body: Text(
          "We provide a platform to record your reviews & share your experience on different products, brands, business & even social issues through a video clip",
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black,fontFamily: "ProximaNova"),
        ),
        title: Text(
          "Become a Reviewer",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.blue,fontFamily: "ProximaNova"),
        ),
        mainImage: Image.asset(
          Images.intro2,
          fit: BoxFit.contain,
        ),
      ),
      PageViewModel(
        pageColor: Colors.transparent,
        pageBackground: Image.asset(
          Images.introBackground,
          fit: BoxFit.cover,
        ),
        bubble: const Icon(
          Icons.phonelink,
          color: Colors.blue,
        ),
        body: Text(
          "With Companies and leading Brands looking for new ways to increase their digital presence we believe that our application offers a unique 'Video Review' tool that provides a new platform to enhance their brand visibility.",
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black,fontFamily: "ProximaNova"),
        ),
        title: Text(
          "Broader Brand Visibility",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.blue,fontFamily: "ProximaNova"),
        ),
        mainImage: Image.asset(
          Images.intro3,
          fit: BoxFit.contain,
        ),
      ),
    ];*/

    ///Build Page
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Images.introBackground), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    _currentPage = index;
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.18),
                        Image.asset(
                          _pages[index]['image'],
                          height: height * 0.4,
                        ),
                        SizedBox(height: height * 0.05),
                        Text(
                          _pages[index]['title'],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: height * 0.05),
                        Text(
                          _pages[index]['content'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomDots(),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < (_pages.length - 1)) {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: const Duration(microseconds: 800),
                          curve: Curves.linear,
                        );
                      } else {
                        _onCompleted();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _currentPage == (_pages.length - 1)
                              ? 'Get Started'
                              : 'Next',
                          style: Theme.of(context).textTheme.button!.copyWith(
                                fontFamily: "ProximaNova",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 15),
            ],
          ),
        ),
        /*child: IntroViewsFlutter(
          pages,
          onTapSkipButton: _onCompleted,
          onTapDoneButton: _onCompleted,
          doneText: Text(Translate.of(context).translate('done'), style: Theme.of(context)
              .textTheme
              .button!.copyWith(fontFamily: "ProximaNova")),
          nextText: Text(Translate.of(context).translate('next'), style: Theme.of(context)
              .textTheme
              .button!.copyWith(fontFamily: "ProximaNova")),
          skipText: Text(Translate.of(context).translate('skip'), style: Theme.of(context)
              .textTheme
              .button!.copyWith(fontFamily: "ProximaNova")),
          backText: Text(Translate.of(context).translate('back'), style: Theme.of(context)
              .textTheme
              .button!.copyWith(fontFamily: "ProximaNova")),
          pageButtonsColor: Colors.blue,
        ),*/
      ),
    );
  }
}
