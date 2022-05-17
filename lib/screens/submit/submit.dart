import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_business.dart';
import 'package:web_demo/screens/submit/review_webview.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class Submit extends StatefulWidget {
  const Submit({
    Key? key,
  }) : super(key: key);

  @override
  _SubmitState createState() {
    return _SubmitState();
  }
}

class _SubmitState extends State<Submit> {
  final _textTitleController = TextEditingController();
  final _textContentController = TextEditingController();
  final _textTagsController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textZipCodeController = TextEditingController();
  final _textPhoneController = TextEditingController();
  final _textFaxController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textWebsiteController = TextEditingController();
  final _textStatusController = TextEditingController();
  final _textPriceMinController = TextEditingController();
  final _textPriceMaxController = TextEditingController();

  final _focusTitle = FocusNode();
  final _focusContent = FocusNode();
  final _focusAddress = FocusNode();
  final _focusZipCode = FocusNode();
  final _focusPhone = FocusNode();
  final _focusFax = FocusNode();
  final _focusEmail = FocusNode();
  final _focusWebsite = FocusNode();
  final _focusPriceMin = FocusNode();
  final _focusPriceMax = FocusNode();

  String? _errorTitle;
  String? _errorContent;
  String? _errorAddress;
  String? _errorZipCode;
  String? _errorPhone;
  String? _errorFax;
  String? _errorEmail;
  String? _errorWebsite;
  String? _errorStatus;
  String? _errorPriceMin;
  String? _errorPriceMax;

  /// Data
  final List<CategoryModel> _listCategory = [];
  final List<CategoryModel> _listFacilities = [];
  final List<String> _tags = [];
  List<CategoryModel>? _listState;
  List<CategoryModel>? _listCity;

  ///Data Params
  ImageModel? _featureImage;
  List<ImageModel> _galleryImage = [];
  List<CategoryModel> _categories = [];
  List<CategoryModel> _facilities = [];
  List<BusinessModel> _bussinessList = [];
  CategoryModel? _category;
  CategoryModel? _state;
  CategoryModel? _city;
  LocationModel? _gps;
  CountryModel? _country;
  BusinessModel? _business;
  Color? _color;
  String? _date;
  List<OpenTimeModel>? _time;
  List<CountryModel> _countryList = [];
  TextEditingController country = TextEditingController();
  TextEditingController busines = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController controll = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController videoController = TextEditingController();
  bool isShow = false;
  int rating = 0;
  bool _loader = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> validateBusiness() async {
    _loader = true;
    setState(() {});
    await Api.validBusienss({
      "country": _country!.id,
      "category": _category!.id,
      "clientVal": busines.text,
      "loc": locationController.text,
      "city": cityController.text
    });
    _loader = false;
    setState(() {});
  }

  Future<void> validateRweview() async {
    _loader = true;
    setState(() {});
    String clientId = UtilPreferences.getString(Preferences.clientId) ?? '';
    await Api.validReview({
      "client_id": clientId,
      "ratting": rating,
      "comment": videoController.text,
      "rateText": "Good",
      "api": "1"
    });
    _loader = false;
    setState(() {});
  }

  Future<void> _loadData() async {
    _countryList = await Api.getCountryList();
    _country = _countryList.first;
    _categories = await Api.getCategory(_country!.id.toString());
    /*_category = _categories.first;
    Map<String, dynamic> params = {
      "country": _country!.id,
      "category": _category!.id,
    };
    _bussinessList = await Api.getBusinessList(params);
    _business = _bussinessList.first;
    busines.text = _business!.location;*/
    setState(() {});
  }

  @override
  void dispose() {
    _textTitleController.dispose();
    _textContentController.dispose();
    _textTagsController.dispose();
    _textAddressController.dispose();
    _textZipCodeController.dispose();
    _textPhoneController.dispose();
    _textFaxController.dispose();
    _textEmailController.dispose();
    _textWebsiteController.dispose();
    _textStatusController.dispose();
    _textPriceMinController.dispose();
    _textPriceMaxController.dispose();
    _focusTitle.dispose();
    _focusContent.dispose();
    _focusAddress.dispose();
    _focusZipCode.dispose();
    _focusPhone.dispose();
    _focusFax.dispose();
    _focusEmail.dispose();
    _focusWebsite.dispose();
    _focusPriceMin.dispose();
    _focusPriceMax.dispose();
    super.dispose();
  }

  ///On Upload Gallery
  void _onUploadGallery() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.galleryUpload,
      arguments: _galleryImage,
    );

    if (result != null && result is List<ImageModel>) {
      setState(() {
        _galleryImage = result;
      });
    }
  }

  ///On Select Category
  void _onSelectCategory() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
          title: Translate.of(context).translate('choose_category'),
          selected: [_category],
          data: _categories,
          controller: category),
    );
    if (result != null && result is CategoryModel) {
      setState(() {
        _category = result;
      });
      Map<String, dynamic> params = {
        "country": _country!.id,
        "category": _category!.id,
      };
      _bussinessList = await Api.getBusinessList(params);
      _business = null;
      setState(() {});
    }
  }

  void _onSelectBusiness() async {
    _business = null;
    busines.clear();
    isShow = false;
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
          title: Translate.of(context).translate('select_add_business'),
          selected: [_business],
          data: _bussinessList,
          controller: busines,
          isShow: true),
    );
    if (result != null && result is BusinessModel) {
      setState(() {
        _business = result;
      });
    } else {
      isShow = true;
      print(busines.text);
    }
    setState(() {});
  }

  ///On Select Facilities
  void _onSelectFacilities() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
          title: Translate.of(context).translate('choose_facilities'),
          selected: _facilities,
          data: _listFacilities,
          controller: controll),
    );
    if (result != null && result is List<CategoryModel>) {
      setState(() {
        _facilities = result;
      });
    }
  }

  ///On Input Tag
  void _onChooseTag() async {}

  ///On Select Country
  void _onSelectCountry() async {
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
      _categories = await Api.getCategory(_country!.id.toString());
      _category = null;
      _business = null;
      setState(() {});
    }
  }

  ///On Select state
  void _onSelectState() async {}

  ///On Select city
  void _onSelectCity() async {}

  ///On Select Address
  void _onSelectAddress() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.gpsPicker,
      arguments: _gps,
    );
    if (selected != null && selected is LocationModel) {
      setState(() {
        _gps = selected;
      });
    }
  }

  ///On Select Color
  void _onSelectColor() async {
    final result = await showDialog<Color?>(
      context: context,
      builder: (BuildContext context) {
        Color? selected;
        return AlertDialog(
          title: Text(Translate.of(context).translate('choose_color')),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Theme.of(context).primaryColor,
              onColorChanged: (color) {
                selected = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.pop(context);
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('apply'),
              onPressed: () {
                Navigator.pop(context, selected);
              },
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        _color = result;
      });
    }
  }

  ///On Select Icon
  void _onSelectIcon() async {}

  ///Show Picker Time
  void _onShowDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      initialDate: now,
      firstDate: DateTime(now.year),
      context: context,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _date = picked.dateView;
      });
    }
  }

  ///On Select Open Time
  void _onOpenTime() async {}

  ///On Submit
  void _onSubmit() async {
    final success = _validData();
    if (success) {
      await Future.delayed(const Duration(seconds: 1));
      _onSuccess();
    }
  }

  ///On Success
  void _onSuccess() {
    Navigator.pushReplacementNamed(context, Routes.submitSuccess);
  }

  ///valid data
  bool _validData() {
    ///Title
    _errorTitle = UtilValidator.validate(
      _textTitleController.text,
    );

    ///Content
    _errorContent = UtilValidator.validate(
      _textContentController.text,
    );

    ///Address
    _errorAddress = UtilValidator.validate(
      _textAddressController.text,
    );

    ///ZipCode
    _errorZipCode = UtilValidator.validate(
      _textZipCodeController.text,
      type: ValidateType.number,
      allowEmpty: true,
    );

    ///Phone
    _errorPhone = UtilValidator.validate(
      _textPhoneController.text,
      type: ValidateType.phone,
      allowEmpty: true,
    );

    ///Fax
    _errorFax = UtilValidator.validate(
      _textFaxController.text,
      type: ValidateType.phone,
      allowEmpty: true,
    );

    ///Email
    _errorEmail = UtilValidator.validate(
      _textEmailController.text,
      type: ValidateType.email,
      allowEmpty: true,
    );

    ///Website
    _errorWebsite = UtilValidator.validate(
      _textWebsiteController.text,
      allowEmpty: true,
    );

    ///Status
    _errorStatus = UtilValidator.validate(
      _textStatusController.text,
      allowEmpty: true,
    );

    ///Price Min
    _errorPriceMin = UtilValidator.validate(
      _textPriceMinController.text,
      type: ValidateType.number,
      allowEmpty: true,
    );

    ///Price Max
    _errorPriceMax = UtilValidator.validate(
      _textPriceMinController.text,
      type: ValidateType.number,
      allowEmpty: true,
    );

    final min = int.tryParse(_textPriceMinController.text) ?? 0;
    final max = int.tryParse(_textPriceMaxController.text) ?? 0;
    if (min > max) {
      _errorPriceMax = Translate.of(context).translate('min_value_not_valid');
    }

    if (_errorTitle != null ||
        _errorContent != null ||
        _errorAddress != null ||
        _errorAddress != null ||
        _errorPhone != null ||
        _errorFax != null ||
        _errorEmail != null ||
        _errorWebsite != null ||
        _errorStatus != null ||
        _errorPriceMin != null ||
        _errorPriceMax != null) return false;

    ///Feature image
    if (_featureImage == null) {
      AppBloc.messageCubit.onShow('feature_image_require');
      return false;
    }

    return true;
  }

  ///Build gallery
  Widget _buildGallery() {
    DecorationImage? decorationImage;
    IconData icon = Icons.add;
    if (_galleryImage.isNotEmpty) {
      icon = Icons.dashboard_customize_outlined;
      decorationImage = DecorationImage(
        image: AssetImage(
          _galleryImage.first.image,
        ),
        fit: BoxFit.cover,
      );
    }
    return InkWell(
      onTap: _onUploadGallery,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        color: Theme.of(context).primaryColor,
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: decorationImage,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  ///Build content
  Widget _buildContent() {
    String textActionOpenTime = Translate.of(context).translate('add');
    if (_time != null) {
      textActionOpenTime = Translate.of(context).translate('edit');
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 180,
            //   child: AppUploadImage(
            //     title: Translate.of(context).translate('upload_feature_image'),
            //     image: _featureImage,
            //     onChange: (result) {
            //       setState(() {
            //         _featureImage = result;
            //       });
            //     },
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     _buildGallery(),
            //   ],
            // ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('country'),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              title: Translate.of(context).translate('choose_country'),
              value: _country == null ? null : _country!.title,
              onPressed: _onSelectCountry,
            ),

            /*        AppTextInput(
              hintText: Translate.of(context).translate('input_title'),
              errorText: _errorTitle,
              controller: _textTitleController,
              focusNode: _focusTitle,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                setState(() {
                  _errorTitle = UtilValidator.validate(
                    _textTitleController.text,
                  );
                });
              },
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusTitle,
                  _focusContent,
                );
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textTitleController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('Description'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              maxLines: 6,
              hintText: Translate.of(context).translate('input_content'),
              errorText: _errorContent,
              controller: _textContentController,
              focusNode: _focusContent,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorContent = UtilValidator.validate(
                    _textContentController.text,
                  );
                });
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textContentController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),*/

            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('category'),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              title: Translate.of(context).translate('choose_category'),
              value: _category == null ? null : _category!.title,
              onPressed: _onSelectCategory,
            ),
            const SizedBox(height: 16),

            Text(
              Translate.of(context).translate('select_add_business'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              title: Translate.of(context).translate('add_business'),
              value: _business == null ? busines.text : _business!.title,
              onPressed: _onSelectBusiness,
            ),
            const SizedBox(height: 16),
            // Text(
            //   Translate.of(context).translate('facilities'),
            //   style: Theme.of(context)
            //       .textTheme
            //       .subtitle1!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            // AppPickerItem(
            //   title: Translate.of(context).translate('choose_facilities'),
            //   value: _facilities.map((e) => e.title).join(", "),
            //   onPressed: _onSelectFacilities,
            // ),
            // const SizedBox(height: 16),
            // Text(
            //   Translate.of(context).translate('tags'),
            //   style: Theme.of(context)
            //       .textTheme
            //       .subtitle1!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            // AppPickerItem(
            //   title: Translate.of(context).translate('choose_tags'),
            //   value: _tags.isEmpty ? null : _tags.join(","),
            //   onPressed: _onChooseTag,
            // ),
            // const SizedBox(height: 16),
            // const Divider(),
            // const SizedBox(height: 16),

            isShow
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translate.of(context).translate('location'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AppTextInput(
                        hintText:
                            Translate.of(context).translate('input_title'),
                        controller: locationController,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Translate.of(context).translate('city'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AppTextInput(
                        hintText:
                            Translate.of(context).translate('input_title'),
                        controller: cityController,
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox(),
            Text(
              Translate.of(context).translate('video_title'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            AppTextInput(
              hintText: Translate.of(context).translate('input_title'),
              controller: videoController,
            ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('star_rating'),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        rating = index + 1;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.star,
                        color: (rating - 1 < index)
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 16),
            AppButton(
              Translate.of(context).translate('continue_record'),
              onPressed: () async {
                if (isShow) {
                  await validateBusiness();
                }
                await validateRweview();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  ReviewWebView(comment:videoController.text,)));
                /*if ((await Permission.camera.isGranted) == false) {
                  await Permission.camera.request();
                }
                if ((await Permission.storage.isGranted) == false) {
                  await Permission.storage.request();
                }
                if ((await Permission.microphone.isGranted) == false) {
                  await Permission.microphone.request();
                }
                if (await Permission.camera.isGranted &&
                    await Permission.microphone.isGranted &&
                    await Permission.storage.isGranted) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  ReviewWebView(comment:videoController.text,)));
                }*/

                /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Data Added SuccessFull'),
                  duration: const Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'ACTION',
                    onPressed: () {},
                  ),
                ));*/
              },
              mainAxisSize: MainAxisSize.max,
            )

            // AppPickerItem(
            //   leading: Icon(
            //     Icons.location_on_outlined,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Translate.of(context).translate(
            //     'choose_gps_location',
            //   ),
            //   value: _gps != null
            //       ? '${_gps!.long.toStringAsFixed(3)},${_gps!.lat.toStringAsFixed(3)}'
            //       : null,
            //   onPressed: _onSelectAddress,
            // ),
            // const SizedBox(height: 8),
            // AppTextInput(
            //   hintText: Translate.of(context).translate('input_address'),
            //   errorText: _errorAddress,
            //   controller: _textAddressController,
            //   focusNode: _focusAddress,
            //   textInputAction: TextInputAction.next,
            //   onChanged: (text) {
            //     setState(() {
            //       _errorAddress = UtilValidator.validate(
            //         _textAddressController.text,
            //       );
            //     });
            //   },
            //   onSubmitted: (text) {
            //     UtilOther.fieldFocusChange(
            //       context,
            //       _focusAddress,
            //       _focusZipCode,
            //     );
            //   },
            //   leading: Icon(
            //     Icons.home_outlined,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textAddressController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            // ),
/*            Text(
              Translate.of(context).translate('Add Business'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('Add Business'),
              errorText: _errorZipCode,
              controller: _textZipCodeController,
              focusNode: _focusZipCode,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                setState(() {
                  _errorZipCode = UtilValidator.validate(
                    _textZipCodeController.text,
                    type: ValidateType.number,
                    allowEmpty: true,
                  );
                });
              },
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusZipCode,
                  _focusPhone,
                );
              },
              leading: Icon(
                Icons.wallet_travel_outlined,
                color: Theme.of(context).hintColor,
              ),
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textZipCodeController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),*/
            // const SizedBox(height: 8),
            // AppTextInput(
            //   hintText: Translate.of(context).translate('input_phone'),
            //   errorText: _errorPhone,
            //   controller: _textPhoneController,
            //   focusNode: _focusPhone,
            //   textInputAction: TextInputAction.next,
            //   onChanged: (text) {
            //     setState(() {
            //       _errorPhone = UtilValidator.validate(
            //         _textPhoneController.text,
            //         type: ValidateType.phone,
            //         allowEmpty: true,
            //       );
            //     });
            //   },
            //   onSubmitted: (text) {
            //     UtilOther.fieldFocusChange(
            //       context,
            //       _focusPhone,
            //       _focusFax,
            //     );
            //   },
            //   leading: Icon(
            //     Icons.phone_outlined,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textPhoneController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // AppTextInput(
            //   hintText: Translate.of(context).translate('input_fax'),
            //   errorText: _errorFax,
            //   controller: _textFaxController,
            //   focusNode: _focusFax,
            //   textInputAction: TextInputAction.next,
            //   onChanged: (text) {
            //     setState(() {
            //       _errorFax = UtilValidator.validate(
            //         _textFaxController.text,
            //         type: ValidateType.phone,
            //         allowEmpty: true,
            //       );
            //     });
            //   },
            //   onSubmitted: (text) {
            //     UtilOther.fieldFocusChange(
            //       context,
            //       _focusFax,
            //       _focusEmail,
            //     );
            //   },
            //   leading: Icon(
            //     Icons.phone_callback_outlined,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textFaxController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // AppTextInput(
            //   hintText: Translate.of(context).translate('input_email'),
            //   errorText: _errorEmail,
            //   controller: _textEmailController,
            //   focusNode: _focusEmail,
            //   textInputAction: TextInputAction.next,
            //   onChanged: (text) {
            //     setState(() {
            //       _errorEmail = UtilValidator.validate(
            //         _textEmailController.text,
            //         type: ValidateType.email,
            //         allowEmpty: true,
            //       );
            //     });
            //   },
            //   onSubmitted: (text) {
            //     UtilOther.fieldFocusChange(
            //       context,
            //       _focusEmail,
            //       _focusWebsite,
            //     );
            //   },
            //   leading: Icon(
            //     Icons.email_outlined,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textEmailController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // AppTextInput(
            //   hintText: Translate.of(context).translate('input_website'),
            //   errorText: _errorWebsite,
            //   controller: _textWebsiteController,
            //   focusNode: _focusWebsite,
            //   textInputAction: TextInputAction.done,
            //   onChanged: (text) {
            //     setState(() {
            //       _errorWebsite = UtilValidator.validate(
            //         _textWebsiteController.text,
            //         allowEmpty: true,
            //       );
            //     });
            //   },
            //   leading: Icon(
            //     Icons.language_outlined,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textWebsiteController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            // ),
            // const SizedBox(height: 16),
            // const Divider(),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             Translate.of(context).translate('color'),
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .subtitle1!
            //                 .copyWith(fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 8),
            //           AppPickerItem(
            //             leading: Container(
            //               width: 24,
            //               height: 24,
            //               decoration: BoxDecoration(
            //                 color: _color ?? Theme.of(context).primaryColor,
            //                 borderRadius: BorderRadius.circular(4),
            //               ),
            //             ),
            //             value: _color?.value.toRadixString(16),
            //             title: Translate.of(context).translate(
            //               'choose_color',
            //             ),
            //             onPressed: _onSelectColor,
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             Translate.of(context).translate('icon'),
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .subtitle1!
            //                 .copyWith(fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 8),
            //           AppPickerItem(
            //             leading: null,
            //             value: null,
            //             title: Translate.of(context).translate('choose_icon'),
            //             onPressed: _onSelectIcon,
            //           ),
            //         ],
            //       ),
            //     )
            //   ],
            // ),
            //   const SizedBox(height: 8),
            //   Text(
            //     Translate.of(context).translate('status'),
            //     style: Theme.of(context)
            //         .textTheme
            //         .subtitle1!
            //         .copyWith(fontWeight: FontWeight.bold),
            //   ),
            //   const SizedBox(height: 8),
            //   AppTextInput(
            //     hintText: Translate.of(context).translate(
            //       'input_status',
            //     ),
            //     errorText: _errorStatus,
            //     controller: _textStatusController,
            //     textInputAction: TextInputAction.done,
            //     onChanged: (text) {
            //       setState(() {
            //         _errorStatus = UtilValidator.validate(
            //           _textStatusController.text,
            //           allowEmpty: true,
            //         );
            //       });
            //     },
            //     leading: Icon(
            //       Icons.alternate_email,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     trailing: GestureDetector(
            //       dragStartBehavior: DragStartBehavior.down,
            //       onTap: () {
            //         _textStatusController.clear();
            //       },
            //       child: const Icon(Icons.clear),
            //     ),
            //   ),
            //   const SizedBox(height: 8),
            //   Text(
            //     Translate.of(context).translate(
            //       'date_established',
            //     ),
            //     style: Theme.of(context)
            //         .textTheme
            //         .subtitle1!
            //         .copyWith(fontWeight: FontWeight.bold),
            //   ),
            //   const SizedBox(height: 8),
            //   AppPickerItem(
            //     leading: Icon(
            //       Icons.calendar_today_outlined,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     value: _date,
            //     title: Translate.of(context).translate(
            //       'choose_date',
            //     ),
            //     onPressed: _onShowDatePicker,
            //   ),
            //   const SizedBox(height: 8),
            //   Row(
            //     children: [
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               Translate.of(context).translate('price_min'),
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .subtitle1!
            //                   .copyWith(fontWeight: FontWeight.bold),
            //             ),
            //             const SizedBox(height: 8),
            //             AppTextInput(
            //               hintText: Translate.of(context).translate(
            //                 'input_price',
            //               ),
            //               errorText: _errorPriceMin,
            //               controller: _textPriceMinController,
            //               focusNode: _focusPriceMin,
            //               textInputAction: TextInputAction.next,
            //               onChanged: (text) {
            //                 setState(() {
            //                   _errorPriceMin = UtilValidator.validate(
            //                     _textPriceMinController.text,
            //                     type: ValidateType.number,
            //                     allowEmpty: true,
            //                   );
            //                 });
            //               },
            //               onSubmitted: (text) {
            //                 UtilOther.fieldFocusChange(
            //                   context,
            //                   _focusPriceMin,
            //                   _focusPriceMax,
            //                 );
            //               },
            //               leading: Icon(
            //                 Icons.price_change_outlined,
            //                 color: Theme.of(context).hintColor,
            //               ),
            //               trailing: GestureDetector(
            //                 dragStartBehavior: DragStartBehavior.down,
            //                 onTap: () {
            //                   _textPriceMinController.clear();
            //                 },
            //                 child: const Icon(Icons.clear),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               Translate.of(context).translate('price_max'),
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .subtitle1!
            //                   .copyWith(fontWeight: FontWeight.bold),
            //             ),
            //             const SizedBox(height: 8),
            //             AppTextInput(
            //               hintText: Translate.of(context).translate(
            //                 'input_price',
            //               ),
            //               errorText: _errorPriceMax,
            //               controller: _textPriceMaxController,
            //               focusNode: _focusPriceMax,
            //               textInputAction: TextInputAction.done,
            //               onChanged: (text) {
            //                 setState(() {
            //                   _errorPriceMax = UtilValidator.validate(
            //                     _textPriceMaxController.text,
            //                     type: ValidateType.number,
            //                     allowEmpty: true,
            //                   );
            //                 });
            //               },
            //               leading: Icon(
            //                 Icons.price_change_outlined,
            //                 color: Theme.of(context).hintColor,
            //               ),
            //               trailing: GestureDetector(
            //                 dragStartBehavior: DragStartBehavior.down,
            //                 onTap: () {
            //                   _textPriceMaxController.clear();
            //                 },
            //                 child: const Icon(Icons.clear),
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            //   const SizedBox(height: 4),
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         Translate.of(context).translate('open_time'),
            //         style: Theme.of(context)
            //             .textTheme
            //             .subtitle1!
            //             .copyWith(fontWeight: FontWeight.bold),
            //       ),
            //       TextButton(
            //         onPressed: _onOpenTime,
            //         child: Text(
            //           textActionOpenTime,
            //           style: Theme.of(context).textTheme.button!.copyWith(
            //                 color: Theme.of(context).colorScheme.secondary,
            //               ),
            //         ),
            //       )
            //     ],
            //   )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          title: Text(
            Translate.of(context).translate('record_review'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontFamily: "ProximaNova"),
          ),
/*          actions: [
            TextButton(
              onPressed: _onSubmit,
              child: Text(Translate.of(context).translate('add')),
            )
          ],*/
        ),
        body: SafeArea(
          child: _loader
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
        ),
      ),
    );
  }
}
