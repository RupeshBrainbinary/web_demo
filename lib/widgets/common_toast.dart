import 'package:flutter/material.dart';
import 'package:web_demo/utils/translate.dart';

class CommonToast extends StatelessWidget {
final String? text;
CommonToast({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:toats(context,text!) ,
    );
  }
  toats(BuildContext context,String text){
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(Translate.of(context).translate(text)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    ));
  }
}
