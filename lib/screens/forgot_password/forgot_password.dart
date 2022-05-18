import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _textEmailController = TextEditingController();

  String? _validEmail;
  bool _loader = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Fetch API
  void _forgotPassword() async {
    setState(() {
      _validEmail = UtilValidator.validate(
        _textEmailController.text,
        type: ValidateType.email,
      );
    });
    if (_validEmail == null) {
      _loader = true;
      setState(() {});
      Map<String, dynamic> map =
          await Api.resetPassword(_textEmailController.text);
      _textEmailController.clear();
      _loader = false;
      setState(() {});
      if (map['status'] == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An email has been sent. Click the link in the email to reset your password.'),
          duration: const Duration(seconds: 3),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(map['msg']),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Error',
            onPressed: () {},
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('forgot_password'),
        ),
      ),
      body: _loader
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                // alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Center(
                        child: Container(
                          child: Image.asset(
                            "assets/images/logo.png",
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Translate.of(context).translate('email'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      AppTextInput(
                        hintText:
                            Translate.of(context).translate('input_email'),
                        errorText: _validEmail,
                        trailing: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {
                            _textEmailController.clear();
                          },
                          child: const Icon(Icons.clear),
                        ),
                        onSubmitted: (text) {
                          _forgotPassword();
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
                      AppButton(
                        Translate.of(context).translate('reset_password'),
                        mainAxisSize: MainAxisSize.max,
                        onPressed: _forgotPassword,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
