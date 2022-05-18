import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/app_bloc.dart';
import 'package:web_demo/models/model_country.dart';
import 'package:web_demo/models/model_picker.dart';
import 'package:web_demo/screens/privacy_policy/privacy_policy.dart';
import 'package:web_demo/screens/termes_condition/terms_conditions.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/common_toast.dart';
import 'package:web_demo/widgets/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final _accountNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _focusAccountName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPhoneNumber = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();
  TextEditingController country = TextEditingController();

  bool _loading = false;
  String? _validAccountName;
  String? _validPhoneNumber;
  String? _validPassword;
  String? _validConfirmPassword;
  String? _validEmail;
  CountryModel? _country;
  List<CountryModel> _countryList = [];
  bool rememberMe = false;
  bool privacyPolicy = false;
  String? privacyPolicyError;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///On select country
  Future<void> _onSelectCountry() async {
    final item = await showModalBottomSheet<CountryModel?>(
      context: context,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
              data: _countryList, selected: [_country], controller: country),
        );
      },
    );
    if (item != null) {
      setState(() {
        _country = item;
      });
    }
  }

  Future<void> _loadData() async {
    _countryList = await Api.getCountryList();
    _country = _countryList.first;
    setState(() {});
  }

  ///On sign up
  void _signUp() async {
    setState(() {
      _validAccountName = UtilValidator.validate(
        _accountNameController.text,
      );
      _validEmail = UtilValidator.validate(
        _emailController.text,
        type: ValidateType.email,
      );
      /*_validPhoneNumber = UtilValidator.validate(
        _phoneNumberController.text,
      );*/
      _validPassword = UtilValidator.validate(
        _passwordController.text,
        min: 6,
      );
      _validConfirmPassword = UtilValidator.validate(
        _passwordController.text,
        match: _confirmPasswordController.text,
      );
      privacyPolicyError =
          (privacyPolicy == false ? "Terms of condition required" : null);
    });
    if (_validAccountName == null &&
        _validPhoneNumber == null &&
        _validPassword == null &&
        _validEmail == null &&
        _validConfirmPassword == null &&
        privacyPolicyError == null) {
      setState(() {
        _loading = true;
      });
      AppBloc.signUpCubit
          .onSignup(
        username: _accountNameController.text,
        countryName: _country!.title,
        mobileNo: _phoneNumberController.text,
        email: _emailController.text,
        password: _passwordController.text,
        conPassword: _confirmPasswordController.text,
      )
          .then((value) {
        if (value == false) {
          _focusConfirmPassword.unfocus();
          _focusPassword.unfocus();
          _focusPhoneNumber.unfocus();
          _focusEmail.unfocus();
          _focusAccountName.unfocus();
          CommonToast().toats(context, "signInError");
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('sign_up'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontFamily: "ProximaNova")),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                AppPickerItem(
                  title: Translate.of(context).translate('choose_country'),
                  value: _country == null ? null : _country!.title,
                  onPressed: _onSelectCountry,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('full_name_title'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_full_name'),
                  errorText: _validAccountName,
                  controller: _accountNameController,
                  focusNode: _focusAccountName,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _validAccountName = UtilValidator.validate(
                        _accountNameController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                        context, _focusAccountName, _focusEmail);
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _accountNameController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('email'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_email'),
                  errorText: _validEmail,
                  focusNode: _focusEmail,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _emailController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusEmail,
                      _focusPhoneNumber,
                    );
                  },
                  onChanged: (text) {
                    setState(() {
                      _validEmail = UtilValidator.validate(
                        _emailController.text,
                      );
                    });
                  },
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('mobile_number') +
                      " (Optional)",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_mobile'),
                  errorText: _validPhoneNumber,
                  focusNode: _focusPhoneNumber,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _phoneNumberController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusPhoneNumber,
                      _focusPassword,
                    );
                  },
                  onChanged: (text) {
                    /*setState(() {
                      _validPhoneNumber = UtilValidator.validate(
                        _phoneNumberController.text,
                      );
                    });*/
                  },
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('Set Password'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_password',
                  ),
                  errorText: _validPassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _validPassword = UtilValidator.validate(
                        _passwordController.text,
                        min: 6,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusPassword,
                      _focusConfirmPassword,
                    );
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _passwordController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  focusNode: _focusPassword,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('Confirm Password'),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'confirm_your_password',
                  ),
                  errorText: _validConfirmPassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _validConfirmPassword = UtilValidator.validate(
                        _confirmPasswordController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    _signUp();
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _confirmPasswordController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  obscureText: true,
                  controller: _confirmPasswordController,
                  focusNode: _focusConfirmPassword,
                ),
                const SizedBox(height: 8),
                privacyPolicyLinkAndTermsOfService(),
                privacyPolicyError == null
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const SizedBox(width: 24),
                            Expanded(
                              child: Text(
                                Translate.of(context)
                                    .translate(privacyPolicyError.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: Theme.of(context).errorColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                const SizedBox(height: 24),
                AppButton(
                  Translate.of(context).translate('sign_up'),
                  onPressed: _signUp,
                  mainAxisSize: MainAxisSize.max,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cheakBoxTerms() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    this.rememberMe = value!;
                  });
                }),
            // Text( Translate.of(context).translate('cheakBoxPreivacy')),
            Flexible(
              child: Text(
                Translate.of(context).translate('cheakBoxPreivacy'),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TermsConditionsScreen();
                    },
                  ));
                },
                child:
                    Text(Translate.of(context).translate('Terms_condition'))),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PrivacyPolicyScreen();
                    },
                  ));
                },
                child: Text(Translate.of(context).translate('privacy_policy'))),
          ],
        ),
      ],
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Checkbox(
            value: privacyPolicy,
            onChanged: (bool? value) {
              if (value != null) {
                privacyPolicy = value;
                setState(() {});
              }
            },
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(5, 10, 10, 0),
            child: Center(
                child: Text.rich(TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TermsConditionsScreen();
                            },
                          ));
                        }),
                  TextSpan(
                      text: ' & ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PrivacyPolicyScreen();
                                  },
                                ));
                              })
                      ])
                ]))),
          ),
        ),
      ],
    );
  }
}
