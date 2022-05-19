// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/repository/user.dart';
import 'package:web_demo/screens/home/home.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/common_toast.dart';
import 'package:web_demo/widgets/widget.dart';

class SignIn extends StatefulWidget {
  final String from;

  const SignIn({Key? key, required this.from}) : super(key: key);

  @override
  _SignInState createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  final _textIDController = TextEditingController();
  final _textPassController = TextEditingController();
  final _focusID = FocusNode();
  final _focusPass = FocusNode();

  bool _showPassword = false;
  String? _errorID;
  String? _errorPass;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textIDController.dispose();
    _textPassController.dispose();
    _focusID.dispose();
    _focusPass.dispose();
    super.dispose();
  }

  ///On navigate forgot password
  void _forgotPassword() {
    Navigator.pushNamed(context, Routes.forgotPassword);
  }

  ///On navigate sign up
  void _signUp() {
    Navigator.pushNamed(context, Routes.signUp);
  }

  ///On login
  void _login()async {
    isLoading = true;
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _errorID = UtilValidator.validate(_textIDController.text);
      _errorPass = UtilValidator.validate(_textPassController.text);
    });
    if (_errorID == null && _errorPass == null) {

      final result = await UserRepository.login(
        username:  _textIDController.text,
        password:_textPassController.text,
      );
      if(result !=null){
        await UtilPreferences.setString(
          Preferences.clientId,
          result.id.toString(),

        );
        await AppBloc.authenticateCubit.onSave(result);
        isLoading = false;
        setState(() {

        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AppContainer()),
                (route) => false);
      }else{
        isLoading = false;
        setState(() {

        });
        CommonToast().toats(context, "signInError");
      }


      // final value = AppBloc.loginCubit.onLogin(
      //     username: _textIDController.text,
      //     password: _textPassController.text,
      //     context: context);
      // if (value == null) {
      //   isLoading = false;
      //   setState(() {
      //
      //   });
      //   CommonToast().toats(context, "signInError");
      // } else {
      //   isLoading = false;
      //   setState(() {
      //
      //   });
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const AppContainer()),
      //       (route) => false);
      // }
    } else {
      isLoading = false;
      setState(() {});

      CommonToast().toats(context, "signInError");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('sign_in'),
        ),
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, login) {
          if (login == LoginState.success) {
            Navigator.pop(context, widget.from);
          }
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 70,
                        ),
                        Container(
                          child: Image.asset(
                            "assets/images/logo.png",
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        AppTextInput(
                          hintText: Translate.of(context).translate('Email ID'),
                          errorText: _errorID,
                          controller: _textIDController,
                          focusNode: _focusID,
                          textInputAction: TextInputAction.next,
                          onChanged: (text) {
                            setState(() {
                              _errorID = UtilValidator.validate(
                                _textIDController.text,
                              );
                            });
                          },
                          onSubmitted: (text) {
                            UtilOther.fieldFocusChange(
                                context, _focusID, _focusPass);
                          },
                          trailing: GestureDetector(
                            dragStartBehavior: DragStartBehavior.down,
                            onTap: () {
                              _textIDController.clear();
                            },
                            child: const Icon(Icons.clear),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextInput(
                          hintText: Translate.of(context).translate('password'),
                          errorText: _errorPass,
                          textInputAction: TextInputAction.done,
                          onChanged: (text) {
                            setState(() {
                              _errorPass = UtilValidator.validate(
                                _textPassController.text,
                              );
                            });
                          },
                          onSubmitted: (text) {
                            _login();
                          },
                          trailing: GestureDetector(
                            dragStartBehavior: DragStartBehavior.down,
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            child: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          obscureText: !_showPassword,
                          controller: _textPassController,
                          focusNode: _focusPass,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppButton(
                            Translate.of(context)
                                .translate('forgot_password'),
                            onPressed: _forgotPassword,
                            type: ButtonType.text,
                          ),
                        ),
                        const SizedBox(height: 5),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, login) {
                            return AppButton(
                              Translate.of(context).translate('sign_in'),
                              mainAxisSize: MainAxisSize.max,
                              onPressed: _login,
                              loading: login == LoginState.loading,
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AppButton(
                              '${Translate.of(context).translate('new_user')}',
                              onPressed: _signUp,
                              type: ButtonType.text,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
