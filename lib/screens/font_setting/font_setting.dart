// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:web_demo/blocs/bloc.dart';
// import 'package:web_demo/configs/config.dart';
// import 'package:web_demo/utils/utils.dart';
// import 'package:web_demo/widgets/widget.dart';
//
// class FontSetting extends StatefulWidget {
//   const FontSetting({Key? key}) : super(key: key);
//
//   @override
//   _FontSettingState createState() {
//     return _FontSettingState();
//   }
// }
//
// class _FontSettingState extends State<FontSetting> {
//   String _currentFontFamily = AppBloc.themeCubit.state.fontFamily;
//   TextTheme _currentTextTheme = AppBloc.themeCubit.state.textTheme;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   ///On change Font
//   void _onChange() {
//     AppBloc.themeCubit.onChangeTheme(
//         textTheme: _currentTextTheme, fontFamily: _currentFontFamily);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     GoogleFonts.openSans;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           Translate.of(context).translate('font'),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//                 child: ListView(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     children:
//                         AppTheme.supportedTextThemes.keys.map((fontFamily) {
//                       Widget? trailing;
//                       final item = AppTheme.supportedTextThemes[fontFamily];
//                       if (fontFamily == _currentFontFamily) {
//                         trailing = Icon(
//                           Icons.check,
//                           color: Theme.of(context).primaryColor,
//                         );
//                       }
//                       return AppListTitle(
//                         title: fontFamily,
//                         trailing: trailing,
//                         onPressed: () {
//                           setState(() {
//                             _currentFontFamily = fontFamily;
//                             _currentTextTheme = item ?? AppTheme.defaultTextTheme;
//                           });
//                         },
//                         border: item !=
//                             AppTheme.supportedTextThemes.entries.last.value,
//                       );
//                     }).toList())),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: AppButton(
//                 Translate.of(context).translate('apply'),
//                 mainAxisSize: MainAxisSize.max,
//                 onPressed: _onChange,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
