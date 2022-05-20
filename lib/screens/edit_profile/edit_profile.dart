import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/blocs/app_bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model_user.dart';
import 'package:web_demo/repository/user.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';
import 'package:http/http.dart' as http;
String? profile;
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _picker = ImagePicker();
  final _textNameController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textMobileController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textWebsiteController = TextEditingController();
  final _textInfoController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusMobile = FocusNode();
  final _focusAddress = FocusNode();
  final _focusWebsite = FocusNode();
  final _focusInfo = FocusNode();

  XFile? _image;
  String? _validName;
  String? _validEmail;
  String? _validMobile;
  String? _validAddress;
  String? _validWebsite;
  String? _validInfo;
  bool channelEnable = false;
  UserModel? userModel;


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Map<String, dynamic> map = jsonDecode(
      UtilPreferences.getString(Preferences.user) ?? '',
    );

    _textNameController.text = map['name'] ?? '';
    _textEmailController.text = map['email'] ?? '';
    _textMobileController.text = map['mobile'] ?? '';
    _textAddressController.text = map['location'] ?? '';
    _textWebsiteController.text = map['chanel'] ?? '';
    profile = map['avatar'];
    channelEnable = _textWebsiteController.text.isEmpty;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Image file
  void _onGetImage() async {
    print("image");
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      var request = new http.MultipartRequest("POST",
          Uri.parse("https://www.thereviewclip.com/reviewer/uploadImage"));
      request.fields['type'] = '1';
      request.fields['client_id'] =
          "${UtilPreferences.getString(Preferences.clientId)}";
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('logo', image.path);
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        var jsonResp = json.decode(value);
        print(jsonResp);
        profile = jsonResp['data'];
        if (value.isNotEmpty) {

          userModel = await Api.getReviewerDetail(int.parse(
              UtilPreferences.getString(Preferences.clientId.toString())!));
          setState(() {});
          UserRepository.saveUser(user: userModel!);
          AppBloc.userCubit.onLoadUser();
        }
      });
      setState(() {});

    }
  }

  ///On update image
  void _onUpdate() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      /*_validName = UtilValidator.validate(
        _textNameController.text,
      );
      _validEmail = UtilValidator.validate(
        _textEmailController.text,
        type: ValidateType.email,
      );
      _validMobile = UtilValidator.validate(
        _textMobileController.text,
        type: ValidateType.phone,
      );
      _validAddress = UtilValidator.validate(
        _textAddressController.text,
      );
      _validWebsite = UtilValidator.validate(
        _textWebsiteController.text,
      );*/
      _validInfo = UtilValidator.validate(
        _textInfoController.text,
      );
    });

    if (/*_validName == null &&
        _validEmail == null &&
        _validMobile == null &&
        _validAddress == null &&
        _validWebsite == null &&*/
        _validInfo == null) {
      Navigator.pop(context);
    }
  }

  ///Build avatar
  Widget _buildImage() {
    if (profile != null) {
     return Container(
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
          borderRadius: BorderRadius.circular(60),
          child: CachedNetworkImage(
            imageUrl: "https://www.thereviewclip.com/uploads/client_logo/"+ profile!,
            fit: BoxFit.cover,
            errorWidget: (con, str, dy) {
              return SizedBox();
              /*return Image.asset(
                            "assets/images/default_image.jpeg",
                            fit: BoxFit.cover,
                          );*/
            },
          ),
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/default_image.jpeg"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('edit_profile'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontFamily: "ProximaNova")),
        actions: <Widget>[
          AppButton(
            Translate.of(context).translate('confirm'),
            type: ButtonType.text,
            onPressed: _onUpdate,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        _buildImage(),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: _onGetImage,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('name'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  enable: false,
                  hintText: Translate.of(context).translate('input_name'),
                  errorText: _validName,
                  focusNode: _focusName,
                  textInputAction: TextInputAction.next,
                  /*trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textNameController.clear();
                    },
                    child:  Icon(Icons.clear,color: Theme.of(context).iconTheme.color,),
                  ),*/
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusName,
                      _focusEmail,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validName = UtilValidator.validate(
                        _textNameController.text,
                      );
                    });
                  },
                  controller: _textNameController,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('email'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  enable: false,
                  hintText: Translate.of(context).translate('input_email'),
                  errorText: _validEmail,
                  focusNode: _focusEmail,
                  textInputAction: TextInputAction.next,
                  /*trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textEmailController.clear();
                    },
                    child:  Icon(Icons.clear,color: Theme.of(context).iconTheme.color,),
                  ),*/
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusEmail,
                      _focusAddress,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validEmail = UtilValidator.validate(
                        _textEmailController.text,
                        type: ValidateType.email,
                      );
                    });
                  },
                  controller: _textEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('Mobile number'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  enable: true,
                  hintText: Translate.of(context).translate('input_number'),
                  errorText: _validMobile,
                  focusNode: _focusMobile,
                  textInputAction: TextInputAction.next,
                  /* trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textMobileController.clear();
                    },
                    child:  Icon(Icons.clear,color: Theme.of(context).iconTheme.color,),
                  ),*/
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusEmail,
                      _focusAddress,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validMobile = UtilValidator.validate(
                        _textMobileController.text,
                        type: ValidateType.phone,
                      );
                    });
                  },
                  controller: _textMobileController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('Locaion'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  enable: false,
                  hintText: Translate.of(context).translate('input_address'),
                  errorText: _validAddress,
                  focusNode: _focusAddress,
                  textInputAction: TextInputAction.next,
                  /*trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textAddressController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),*/
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusAddress,
                      _focusWebsite,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validAddress = UtilValidator.validate(
                        _textAddressController.text,
                      );
                    });
                  },
                  controller: _textAddressController,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('Channel name'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  enable: channelEnable,
                  hintText:
                      Translate.of(context).translate('Input Channel Name'),
                  errorText: _validWebsite,
                  focusNode: _focusWebsite,
                  textInputAction: TextInputAction.next,
                  /*trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textWebsiteController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),*/
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusWebsite,
                      _focusInfo,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validAddress = UtilValidator.validate(
                        _textWebsiteController.text,
                      );
                    });
                  },
                  controller: _textWebsiteController,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('About'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_information',
                  ),
                  errorText: _validInfo,
                  focusNode: _focusInfo,
                  maxLines: 5,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textInfoController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _validInfo = UtilValidator.validate(
                        _textInfoController.text,
                      );
                    });
                  },
                  controller: _textInfoController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
