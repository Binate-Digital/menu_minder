import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:menu_minder/common/custom_background_widget.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/customize_international_country_code_picker/custom_intl_phone_field.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/app_validator.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/models/create_profile_model.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
import 'package:menu_minder/view/create_profile/widgets/food_chip.dart';
import 'package:menu_minder/view/subscription/screens/subscription_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/customize_international_country_code_picker/custom_phonenumber.dart';
import '../../../common/heading_textfield.dart';
import '../../../utils/dummy.dart';
import '../../invite_family_member/screens/invite_family_screen.dart';
import '../widgets/upload_image_widget.dart';

class CreateProfileScreen extends StatefulWidget {
  final bool isEdit;
  const CreateProfileScreen({super.key, required this.isEdit});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final fullName = TextEditingController();
  final famusRecicpes = [
    'Hamburger',
    'Grilled Cheese',
    'Fried Chicken',
  ];
  final famousDiets = [
    'Sugar free',
    'Gluten free',
    'Extra veggies',
  ];

  final famousRecipiesNotChangable = [
    'Hamburger',
    'Grilled Cheese',
    'Fried Chicken',
  ];
  final famousRecipiesDietNotChangable = [
    'Sugar free',
    'Gluten free',
    'Extra veggies',
  ];
  final email = TextEditingController();
  final phone = TextEditingController();
  final food = TextEditingController();
  final refreal = TextEditingController();
  final diet = TextEditingController();
  final FocusNode phoneNode = FocusNode();
  // TextEditingController searchController = TextEditingController();
  ValueNotifier<List<String>?> dietList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>?> foodList = ValueNotifier<List<String>>([]);
  AuthProvider? _authProvider;

  String? initialCountryCode;
  @override
  void initState() {
    _authProvider = context.read<AuthProvider>();
    email.text = _authProvider?.userdata?.data?.userEmail ?? "";

    if (_authProvider?.userdata?.data?.userSocialType == "phone") {
      print("Social Login With Phone Number");
      initialCountryCode = _authProvider?.userdata?.data?.userCountryCode ?? "";
      phone.text = _authProvider?.userdata?.data?.userPhone ?? "";
    }
    // phone.text = _authProvider?.userdata?.data?.userPhone != null
    //     ? _authProvider!.userdata!.data!.userPhone.toString()
    //     // phoneMask.maskText(profile.value!.phone!)
    //     : "";
    if (widget.isEdit) {
      ////CHECK AND PARSE PHONE NUMBER

      fullName.text = _authProvider?.userdata?.data?.userName ?? "";
      initialCountryCode = _authProvider?.userdata?.data?.userCountryCode ?? "";
      phone.text = _authProvider?.userdata?.data?.userPhone ?? "";

      if (_authProvider?.userdata?.data?.userPhone != null &&
          _authProvider?.userdata?.data?.userCountryCode != null) {
        phoneNumber = PhoneNumber(
            countryISOCode:
                _authProvider!.userdata!.data!.userCountryCode.toString(),
            countryCode: CountryCode.fromCountryCode(
                    _authProvider?.userdata?.data?.userCountryCode ?? 'US')
                .code!,
            number: _authProvider!.userdata!.data!.userPhone!);

        _authProvider?.userdata?.data?.foodPeferences?.forEach((element) {
          famusRecicpes.remove(element);
        });

        _authProvider?.userdata?.data?.dietPeferences?.forEach((element) {
          famousDiets.remove(element);
        });
        // context.read<CoreProvider>().updateSharedList(value: value, sid: sid)
      }

      // if (_authProvider?.userdata?.data?.userPhone != null) {
      //   final countrycode =

      // phoneNumber = _authProvider!.userdata!.data!.userPhone;
      email.text = _authProvider?.userdata?.data?.userSocialType == "phone"
          ? (_authProvider?.userdata?.data?.userAlternateEmail ?? '')
          : _authProvider?.userdata?.data?.userEmail ?? "";
      // foodList.value = List<String>.from(
      //     _authProvider?.userdata?.data?.foodPeferences ?? []);

      foodList.value = [];
      _authProvider?.userdata?.data?.foodPeferences?.forEach((e) {
        foodList.value?.add(e!);
      });

      dietList.value = [];
      _authProvider?.userdata?.data?.dietPeferences?.forEach((element) {
        dietList.value?.add(element!);
      });
    }

    if (_authProvider?.userdata?.data?.userPhone != null) {
      phoneNumber = PhoneNumber(
          countryISOCode:
              _authProvider!.userdata!.data!.userCountryCode.toString(),
          countryCode: CountryCode.fromCountryCode(
                  _authProvider?.userdata?.data?.userCountryCode ?? 'US')
              .code!,
          number: _authProvider!.userdata!.data!.userPhone!);
    }

    // if (_authProvider != null) {
    //   email.text = _authProvider!.userdata!.data!.userEmail.toString();
    // }
    super.initState();
  }

  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: "+1(###) ###-####",
  );

  String? code = "+1";

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWidget(
      resizeToAvoidBottomInset: false,
      showBackground: !widget.isEdit,
      appBar: widget.isEdit
          ? AppStyles.pinkAppBar(context, "Edit Profile")
          : AppStyles.appBar("Create Profile", () {
              AppNavigator.pushAndRemoveUntil(
                  context, const SocialLoginScreen());
            }),
      child: WillPopScope(
        onWillPop: () async {
          if (widget.isEdit) {
            AppNavigator.pop(context);
          } else {
            AppNavigator.pop(context);
            AppNavigator.pushAndRemoveUntil(context, const SocialLoginScreen());
          }
          return false;
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStyles.height12SizedBox(height: 20),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const UploadImageWidget(),
                        AppStyles.height8SizedBox(),
                        AppStyles.contentStyle(
                            widget.isEdit
                                ? "Change Profile Image"
                                : "Upload Your Image",
                            color: widget.isEdit
                                ? AppColor.COLOR_BLACK
                                : AppColor.COLOR_WHITE,
                            fontSize: 16),
                      ],
                    ),
                  ),
                  AppStyles.height16SizedBox(),
                  HeadingTextField(
                      controller: fullName,
                      heading: 'Full Name',
                      inputFormat: [LengthLimitingTextInputFormatter(35)],
                      validator: (String? val) =>
                          AppValidator.validateField("Full Name", val!),
                      headingColor: widget.isEdit
                          ? AppColor.COLOR_BLACK
                          : AppColor.COLOR_WHITE,
                      bgColor: widget.isEdit
                          ? Colors.grey.shade100
                          : AppColor.COLOR_WHITE,
                      borderColor: widget.isEdit
                          ? AppColor.TRANSPARENT_COLOR
                          : AppColor.COLOR_BLACK),
                  // _authProvider?.userdata?.data?.userSocialType == "phone"
                  //     ? const SizedBox()
                  //     :

                  AppStyles.height16SizedBox(),
                  // _authProvider?.userdata?.data?.userSocialType == "phone"
                  //     ? const SizedBox()
                  //     :

                  HeadingTextField(
                      controller: email,
                      heading: 'Email',
                      textInputType: TextInputType.emailAddress,
                      isRead: _authProvider?.userdata?.data?.userSocialType !=
                          "phone",
                      inputFormat: [LengthLimitingTextInputFormatter(35)],
                      validator: (String? val) =>
                          AppValidator.emailValidation(val!),
                      headingColor: widget.isEdit
                          ? AppColor.COLOR_BLACK
                          : AppColor.COLOR_WHITE,
                      bgColor: widget.isEdit
                          ? Colors.grey.shade100
                          : AppColor.COLOR_WHITE,
                      borderColor: widget.isEdit
                          ? AppColor.TRANSPARENT_COLOR
                          : AppColor.COLOR_BLACK),
                  AppStyles.height16SizedBox(),

                  // HeadingTextField(
                  //     controller: email,
                  //     heading: 'Phone',
                  //     textInputType: TextInputType.emailAddress,
                  //     isRead: isEmail,
                  //     inputFormat: [LengthLimitingTextInputFormatter(35)],
                  //     validator: (String? val) =>
                  //         AppValidator.emailValidation(val!),
                  //     headingColor: widget.isEdit
                  //         ? AppColor.COLOR_BLACK
                  //         : AppColor.COLOR_WHITE,
                  //     bgColor: widget.isEdit
                  //         ? Colors.grey.shade100
                  //         : AppColor.COLOR_WHITE,
                  //     borderColor: widget.isEdit
                  //         ? AppColor.TRANSPARENT_COLOR
                  //         : AppColor.COLOR_BLACK),

                  // AppStyles.headingStyle("Phone",
                  //     color: AppColor.COLOR_WHITE,
                  //     fontWeight: FontWeight.normal),
                  // const SizedBox(
                  //   height: 5,
                  // ),

                  // _authProvider?.userdata?.data?.userSocialType != "phone"
                  //     ? const SizedBox()
                  //     :
                  _phoneNoTextField(),

                  // KeyboardActions(
                  //   autoScroll: false,
                  //   config: AppFunctions.iosNumericKeyboard(context, phoneNode),
                  //   child: HeadingTextField(
                  //       heading: "Phone Number",
                  //       controller: phone,
                  //       isRead: !isEmail,
                  //       textInputType: TextInputType.number,
                  //       focusNode: !isEmail ? null : phoneNode,
                  //       inputFormat: [
                  //         // LengthLimitingTextInputFormatter(16),
                  //         phoneMask,
                  //       ],
                  //       validator: (String? val) =>
                  //           AppValidator.phoneValidation(val!),
                  //       headingColor: widget.isEdit
                  //           ? AppColor.COLOR_BLACK
                  //           : AppColor.COLOR_WHITE,
                  //       bgColor: widget.isEdit
                  //           ? Colors.grey.shade100
                  //           : AppColor.COLOR_WHITE,
                  //       borderColor: widget.isEdit
                  //           ? AppColor.TRANSPARENT_COLOR
                  //           : AppColor.COLOR_BLACK),
                  // ),

                  // AppStyles.height16SizedBox(),
                  // HeadingTextField(
                  //   heading: "Food Preferences",
                  //   controller: food,

                  //   validator: (val) {
                  //     if (foodList.value!.isEmpty) {
                  //       return "Please enter atleast 1 food preference";
                  //     }
                  //     return null;
                  //   },
                  //   headingColor: widget.isEdit
                  //       ? AppColor.COLOR_BLACK
                  //       : AppColor.COLOR_WHITE,
                  //   bgColor: widget.isEdit
                  //       ? Colors.grey.shade100
                  //       : AppColor.COLOR_WHITE,
                  //   borderColor: widget.isEdit
                  //       ? AppColor.TRANSPARENT_COLOR
                  //       : AppColor.COLOR_BLACK,
                  //   onEditingCompleted: (v) {
                  //     if (food.text.isNotEmpty) {
                  //       foodList.value!.add(v!);
                  //       food.clear();
                  //       setState(() {});
                  //     }
                  //   },

                  // ),
                  AppStyles.height16SizedBox(),
                  CustomText(
                    text: 'Food Prefrences',
                    fontColor: widget.isEdit
                        ? AppColor.COLOR_BLACK
                        : AppColor.COLOR_WHITE,
                  ),
                  AppStyles.height8SizedBox(),
                  TypeAheadField<String>(
                    onSuggestionSelected: (suggestion) {
                      // if (food.text.isNotEmpty) {
                      //   foodList.value!.add(suggestion);
                      //   food.clear();
                      //   setState(() {});
                      // }
                      if (foodList.value!.contains(suggestion)) {
                        AppMessage.showMessage('Food Already Added');
                        FocusScope.of(context).unfocus();
                        return;
                      } else {
                        food.clear();
                        foodList.value?.add(suggestion);
                        famusRecicpes.remove(suggestion);
                        setState(() {});
                      }
                    },
                    suggestionsCallback: (search) {
                      // Replace recipeList with your list of recipes
                      return famusRecicpes
                          .where((recipe) => recipe
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, recipe) {
                      return ListTile(
                        title: Text(recipe),
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: food,
                      onEditingComplete: () {
                        if (foodList.value!.contains(food.text.trim())) {
                          AppMessage.showMessage('Food Already Added');
                          return;
                        } else {
                          if (food.text.trim().isNotEmpty) {
                            foodList.value?.add(food.text.trim());
                            famusRecicpes.remove(food.text.trim());
                            food.clear();
                            setState(() {});
                          }
                        }

                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: widget.isEdit
                              ? Colors.grey.shade100
                              : AppColor.COLOR_WHITE,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          // fillColor: AppColor.COLOR_WHITE,
                          hintText: 'Select Food You want?'
                          // labelText: 'Recipe',
                          ),
                    ),
                    suggestionsBoxDecoration: const SuggestionsBoxDecoration(

                        // hintText: 'Select or type a recipe',
                        ),
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    noItemsFoundBuilder: (context) {
                      return const ListTile(
                        title: Text(
                            'No recipes found. You can type your own recipe.'),
                      );
                    },
                  ),

                  ValueListenableBuilder<List<String?>?>(
                      valueListenable: foodList,
                      builder: (context, List<String?>? val, _) {
                        return Wrap(
                          children: List.generate(
                            val!.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 0),
                              child: FoodChip(
                                label: val[index]!,
                                color: AppColor.THEME_COLOR_SECONDARY,
                                isDeleteable: true,
                                onDelete: () {
                                  // famusRecicpes.add(val[index]!);
                                  if (famousRecipiesNotChangable
                                      .contains(val[index])) {
                                    famusRecicpes.add(val[index]!);
                                  }
                                  val.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          ).toList(),
                        );
                      }),
                  // AppStyles.height16SizedBox(),

                  AppStyles.height16SizedBox(),
                  CustomText(
                    text: 'Diet Preferences',
                    fontColor: widget.isEdit
                        ? AppColor.COLOR_BLACK
                        : AppColor.COLOR_WHITE,
                  ),
                  AppStyles.height8SizedBox(),
                  TypeAheadField<String>(
                    onSuggestionSelected: (suggestion) {
                      // if (food.text.isNotEmpty) {
                      //   foodList.value!.add(suggestion);
                      //   food.clear();
                      //   setState(() {});
                      // }
                      if (dietList.value!.contains(suggestion)) {
                        AppMessage.showMessage('Diet Already Added');
                        FocusScope.of(context).unfocus();
                        return;
                      } else {
                        dietList.value?.add(suggestion);
                        famousDiets.remove(suggestion);
                        diet.clear();
                        setState(() {});
                      }
                    },
                    suggestionsCallback: (search) {
                      // Replace recipeList with your list of recipes
                      return famousDiets
                          .where((recipe) => recipe
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, recipe) {
                      return ListTile(
                        title: Text(recipe),
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: diet,
                      onEditingComplete: () {
                        if (dietList.value!.contains(diet.text.trim())) {
                          AppMessage.showMessage('Diet Already Added');
                          return;
                        } else {
                          if (diet.text.trim().isNotEmpty) {
                            dietList.value?.add(diet.text.trim());
                            famousDiets.remove(diet.text.trim());
                            diet.clear();
                            setState(() {});
                          }
                        }

                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: widget.isEdit
                              ? Colors.grey.shade100
                              : AppColor.COLOR_WHITE,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: widget.isEdit
                                    ? AppColor.TRANSPARENT_COLOR
                                    : AppColor.COLOR_BLACK,
                                width: .5),
                          ),
                          // fillColor: AppColor.COLOR_WHITE,
                          hintText: 'Select Diet You want?'
                          // labelText: 'Recipe',
                          ),
                    ),
                    suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    noItemsFoundBuilder: (context) {
                      return const ListTile(
                        title:
                            Text('No diets found. You can type your own diet.'),
                      );
                    },
                  ),
                  // HeadingTextField(
                  //   heading: "Diet Preferences",
                  //   controller: diet,
                  //   validator: (val) {
                  //     if (dietList.value!.isEmpty) {
                  //       return "Please enter atleast 1 diet preference";
                  //     }
                  //     return null;
                  //   },
                  //   headingColor: widget.isEdit
                  //       ? AppColor.COLOR_BLACK
                  //       : AppColor.COLOR_WHITE,
                  //   bgColor: widget.isEdit
                  //       ? Colors.grey.shade100
                  //       : AppColor.COLOR_WHITE,
                  //   borderColor: widget.isEdit
                  //       ? AppColor.TRANSPARENT_COLOR
                  //       : AppColor.COLOR_BLACK,
                  //   onEditingCompleted: (v) {
                  //     if (diet.text.isNotEmpty) {
                  //       dietList.value!.add(v!);
                  //       diet.clear();
                  //       setState(() {});
                  //     }
                  //   },
                  // ),
                  ValueListenableBuilder<List<String?>?>(
                      valueListenable: dietList,
                      builder: (context, List<String?>? val, _) {
                        return Wrap(
                          children: List.generate(
                            val!.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 0),
                              child: FoodChip(
                                label: val[index]!,
                                color: AppColor.THEME_COLOR_SECONDARY,
                                isDeleteable: true,
                                onDelete: () {
                                  // famusRecicpes.add(val[index]!);
                                  if (famousRecipiesDietNotChangable
                                      .contains(val[index])) {
                                    famousDiets.add(val[index]!);
                                  }
                                  val.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          ).toList(),
                        );
                      }),

                  Visibility(
                      visible: !widget.isEdit,
                      child: AppStyles.height16SizedBox()),
                  Visibility(
                    visible: !widget.isEdit,
                    child: HeadingTextField(
                      heading: "Referral Code",
                      controller: refreal,
                      // validator: (val) {

                      // },
                      headingColor: widget.isEdit
                          ? AppColor.COLOR_BLACK
                          : AppColor.COLOR_WHITE,
                      bgColor: widget.isEdit
                          ? Colors.grey.shade100
                          : AppColor.COLOR_WHITE,
                      borderColor: widget.isEdit
                          ? AppColor.TRANSPARENT_COLOR
                          : AppColor.COLOR_BLACK,
                    ),
                  ),
                  AppStyles.height16SizedBox(),
                  AppStyles.height16SizedBox(),
                  widget.isEdit
                      ? Consumer<AuthProvider>(builder: (context, val, _) {
                          if (val.createProfileState == States.success) {
                            AppMessage.showMessage(
                                'Profile updated successfully.');
                            AppNavigator.pop(context);
                            val.initState();
                          }
                          return val.createProfileState == States.loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: CustomLoadingBarWidget(),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: PrimaryButton(
                                      text: "Save Details",
                                      onTap: () async {
                                        if (_key.currentState!.validate()) {
                                          // if (phoneNumber != null) {
                                          // print("EMAIL $")
                                          val.createProfile(
                                              context,
                                              CreateProfileModel(
                                                  userName: fullName.text,
                                                  alternateEmail: _authProvider
                                                              ?.userdata
                                                              ?.data
                                                              ?.userSocialType ==
                                                          "phone"
                                                      ? email.text.trim()
                                                      : null,
                                                  email: _authProvider
                                                              ?.userdata
                                                              ?.data
                                                              ?.userSocialType ==
                                                          "phone"
                                                      ? email.text.trim()
                                                      : null,
                                                  userCountryCode: phoneNumber
                                                      ?.countryISOCode,
                                                  userPhone:
                                                      phoneNumber?.number,
                                                  userImage:
                                                      profile.value?.image,
                                                  foodPeferences:
                                                      foodList.value,
                                                  refrealCode: refreal.text,
                                                  dietPeferences:
                                                      dietList.value));
                                          // } else {
                                          //   AppMessage.showMessage(
                                          //       'Please Select Phone Number');
                                          // }
                                        }
                                      }),
                                );
                        })
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: PrimaryButton(
                                      text: "Add Family Member",
                                      onTap: () {
                                        if (_key.currentState!.validate()) {
                                          AppNavigator.push(
                                              context,
                                              const InviteFamilyScreen(
                                                isEdit: false,
                                              ));
                                        }
                                      })),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Consumer<AuthProvider>(
                                  builder: (context, val, _) {
                                if (val.createProfileState == States.success) {
                                  // if (val.userdata?.data?.userIsSubscribed ==
                                  //     1) {
                                  //   AppNavigator.pushAndRemoveUntil(
                                  //       context, const BottomBar());
                                  // } else {
                                  //   AppNavigator.push(
                                  //       context,
                                  //       const SubscriptionScreen(
                                  //         isTrial: true,
                                  //         isFromProfile: true,
                                  //       ));
                                  // }
                                  AppNavigator.push(
                                      context,
                                      const SubscriptionScreen(
                                        isTrial: true,
                                        logoutKrdo: true,
                                        isFromProfile: true,
                                      ));

                                  val.initState();
                                }
                                return val.createProfileState == States.loading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            backgroundColor:
                                                AppColor.COLOR_WHITE,
                                            color:
                                                AppColor.THEME_COLOR_PRIMARY1,
                                          ),
                                        ],
                                      )
                                    : PrimaryButton(
                                        text: "Create Profile",
                                        onTap: () {
                                          // validatePhone();
                                          if (_key.currentState!.validate()) {
                                            val.createProfile(
                                                context,
                                                CreateProfileModel(
                                                  userName: fullName.text,
                                                  alternateEmail: _authProvider
                                                              ?.userdata
                                                              ?.data
                                                              ?.userSocialType ==
                                                          "phone"
                                                      ? email.text.trim()
                                                      : null,
                                                  email: _authProvider
                                                              ?.userdata
                                                              ?.data
                                                              ?.userSocialType ==
                                                          "phone"
                                                      ? email.text.trim()
                                                      : null,
                                                  userCountryCode: phoneNumber
                                                      ?.countryISOCode,
                                                  userPhone:
                                                      phoneNumber?.number,
                                                  userImage:
                                                      profile.value!.image,
                                                  foodPeferences:
                                                      foodList.value,
                                                  dietPeferences:
                                                      dietList.value,
                                                ));
                                          }
                                        });
                              })),
                            ],
                          ),
                        ),

                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // validatePhone() {
  //   if (phone.text.isEmpty) {
  //     errorPhone = "Phone Number field can't be empty.";
  //   } else if (phone.text.isNotEmpty) {
  //     final resuklt = phone.text.length >= country!.minLength &&
  //             phone.text.length <= country!.maxLength
  //         ? null
  //         : "Invalid Phone Number.";

  //     errorPhone = resuklt;
  //   }

  //   setState(() {});
  // }

  PhoneNumber? phoneNumber;

  Widget _phoneNoTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppString.TEXT_PHONE_NUMBER,
          fontColor:
              widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        ),
        const SizedBox(
          height: 8,
        ),
        IntlPhoneField(
          // focusNode: controller.otpFocusNode,
          showCountryFlag: true,
          readOnly: _authProvider?.userdata?.data?.userSocialType == "phone",
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            filled: true,
            errorStyle: const TextStyle(color: AppColor.COLOR_RED1),
            // constraints: BoxConstraints(minHeight: 20),

            fillColor:
                widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),

            hintText: '',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.BG_COLOR,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
          initialCountryCode: initialCountryCode ?? 'US',
          onChanged: (phone) {
            phoneNumber = phone;
            setState(() {});
            // controller.countryCodeValue = phone.countryISOCode;
            // controller.countryCodeNumber = phone.countryCode;
          },
          keyboardType: TextInputType.phone,
          controller: phone,
        ),
      ],
    );
  }
}
