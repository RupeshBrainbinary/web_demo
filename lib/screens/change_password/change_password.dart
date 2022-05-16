import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final _textPassController = TextEditingController();
  final _textOldPassController = TextEditingController();
  final _textRePassController = TextEditingController();
  final _focusPass = FocusNode();
  final _focusRePass = FocusNode();
  final _focusRoldPass = FocusNode();

  bool _loading = false;
  String? _validPass;
  String? _validRePass;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On change password
  void _onChangePassword() async {
    String clientId = UtilPreferences.getString(Preferences.clientId) ?? '';
    var result;

    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validPass = UtilValidator.validate(
        _textPassController.text,
      );
      _validRePass = UtilValidator.validate(
        _textRePassController.text,
        match: _textPassController.text,
      );
    });
    if (_validPass == null && _validRePass == null) {
      setState(() async {
        _loading = true;
        result = await Api.updatePassword({
          "old": _textOldPassController.text,
          "new": _textPassController.text,
          "cnfnew": _textRePassController.text,
          "clientId": clientId
        });
        _loading = false;
        print(result);
        Map<String,dynamic> map = result as Map<String,dynamic>;
        if(map['status']=="error"){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:  Text(map['msg']),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Error',
              onPressed: () { },
            ),
          ));
        }

      });

      setState(() {});

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('change_password'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontFamily: "ProximaNova")),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30,),
                Center(
                  child: Container(
                    child: Image.asset("assets/images/logo.png",),
                  ),
                ),
                SizedBox(height: 40,),
                Text(
                  Translate.of(context).translate('Old password'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_old_password',
                  ),
                  errorText: _validPass,
                  focusNode: _focusRoldPass,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textOldPassController.clear();
                    },
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusPass,
                      _focusRePass,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validPass = UtilValidator.validate(
                        _textOldPassController.text,
                      );
                    });
                  },
                  controller: _textOldPassController,
                ),
                Text(
                  Translate.of(context).translate('password'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_password',
                  ),
                  errorText: _validPass,
                  focusNode: _focusPass,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textPassController.clear();
                    },
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusPass,
                      _focusRePass,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validPass = UtilValidator.validate(
                        _textPassController.text,
                      );
                    });
                  },
                  controller: _textPassController,
                ),
                const SizedBox(height: 8),
                Text(
                  Translate.of(context).translate('confirm_password'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'confirm_your_password',
                  ),
                  errorText: _validRePass,
                  focusNode: _focusRePass,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textRePassController.clear();
                    },
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  onSubmitted: (text) {
                    _onChangePassword();
                  },
                  onChanged: (text) {
                    setState(() {
                      _validRePass = UtilValidator.validate(
                        _textRePassController.text,
                      );
                    });
                  },
                  controller: _textRePassController,
                ),
                const SizedBox(height: 16),
                AppButton(
                  Translate.of(context).translate('confirm'),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: _onChangePassword,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
