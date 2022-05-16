import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/utils/translate.dart';
import 'package:share_plus/share_plus.dart';

class ProfileLink extends StatefulWidget {
  const ProfileLink({Key? key}) : super(key: key);

  @override
  State<ProfileLink> createState() => _ProfileLinkState();
}

class _ProfileLinkState extends State<ProfileLink> {
  var result;
  Map<String,dynamic> map = {};


  @override
  void initState() {
    getData();
    super.initState();
  }
  getData()async{
    result = await Api.getLoadProfileLink();
    map= result as Map<String,dynamic>;
    setState(() {});
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Row(

                children: [
                  Text(map.isEmpty?"": map['data']['url'].toString(),style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontFamily: "ProximaNova"),),
                  SizedBox(width: 20,),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(

                    ),
                    child: InkWell(
                      onTap: ()async{
                        await Share.share(map.isEmpty?"":map['data']['url'].toString());
                      },
                      child: Icon(Icons.share),
                    ),
                  )




                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
