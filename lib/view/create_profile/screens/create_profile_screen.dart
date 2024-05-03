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

  final famusRecicpesBreakFast = [
    'Spaghetti with Meatballs',
    'Shrimp tacos',
    'meatloaf',
    'Clam chowder',
    'Chicken lazone',
    'Stuffed peppers',
    'Cheeseburger with frenchfries',
    'Potroast',
    'Hotdogs with grilled vegys',
    'Lemon garlic pasta',
    'Texmex',
    'Breakfast strata',
    'Lasagna',
    'Beef stew',
    'Chicken paprikash',
    'Beef stroganoff',
    'Chicken pot pie crescenteups',
    'Ceasar salad',
    'Broccoli Slaw',
    'BBA chicken salad',
    'Kielbasa with sour kraut',
    'Slow cooker pork tenderloin',
    'Vegetable beef soup',
    'Tortellini soup with italian sausage and spinach',
    'Taco bell chili cheese burrito',
  ];

  final famusRecicpesBreakLunch = [
    'Spaghetti with Meatballs',
    'Shrimp tacos',
    'meatloaf',
    'Clam chowder',
    'Chicken lazone',
    'Stuffed peppers',
    'Cheeseburger with frenchfries',
    'Potroast',
    'Hotdogs with grilled vegys',
    'Lemon garlic pasta',
    'Texmex',
    'Breakfast strata',
    'Lasagna',
    'Beef stew',
    'Chicken paprikash',
    'Beef stroganoff',
    'Chicken pot pie crescenteups',
    'Ceasar salad',
    'Broccoli Slaw',
    'BBA chicken salad',
    'Kielbasa with sour kraut',
    'Slow cooker pork tenderloin',
    'Vegetable beef soup',
    'Tortellini soup with italian sausage and spinach',
    'Taco bell chili cheese burrito',
  ];

  final famusRecicpesBreakDinner = [
    'Spaghetti with Meatballs',
    'Shrimp tacos',
    'meatloaf',
    'Clam chowder',
    'Chicken lazone',
    'Stuffed peppers',
    'Cheeseburger with frenchfries',
    'Potroast',
    'Hotdogs with grilled vegys',
    'Lemon garlic pasta',
    'Texmex',
    'Breakfast strata',
    'Lasagna',
    'Beef stew',
    'Chicken paprikash',
    'Beef stroganoff',
    'Chicken pot pie crescenteups',
    'Ceasar salad',
    'Broccoli Slaw',
    'BBA chicken salad',
    'Kielbasa with sour kraut',
    'Slow cooker pork tenderloin',
    'Vegetable beef soup',
    'Tortellini soup with italian sausage and spinach',
    'Taco bell chili cheese burrito',
  ];
  final famousDiets = [
    'Sugar free',
    'Gluten free',
    'Extra veggies',
  ];

  final famousRecipiesDietNotChangable = [
    'Sugar free',
    'Gluten free',
    'Extra veggies',
  ];

  final email = TextEditingController();
  final phone = TextEditingController();
  final breakFastController = TextEditingController();
  final lunchController = TextEditingController();
  final dinnerController = TextEditingController();
  final refreal = TextEditingController();
  final diet = TextEditingController();
  final FocusNode phoneNode = FocusNode();
  // TextEditingController searchController = TextEditingController();
  ValueNotifier<List<String>?> dietList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>?> foodList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>?> lunchList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>?> dinnerList = ValueNotifier<List<String>>([]);
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

        _authProvider?.userdata?.data?.breakfastPrerence?.forEach((element) {
          famusRecicpesBreakFast.remove(element);
        });

        _authProvider?.userdata?.data?.lunchPrerence?.forEach((element) {
          famusRecicpesBreakLunch.remove(element);
        });

        _authProvider?.userdata?.data?.dinnerPrerence?.forEach((element) {
          famusRecicpesBreakDinner.remove(element);
        });

        _authProvider?.userdata?.data?.dietPeferences?.forEach((element) {
          famousDiets.remove(element);
        });
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
      lunchList.value = [];
      dinnerList.value = [];
      _authProvider?.userdata?.data?.breakfastPrerence?.forEach((e) {
        foodList.value?.add(e!);
      });

      _authProvider?.userdata?.data?.lunchPrerence?.forEach((e) {
        lunchList.value?.add(e!);
      });

      _authProvider?.userdata?.data?.dinnerPrerence?.forEach((e) {
        dinnerList.value?.add(e!);
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
                  _fullNameField(),
                  // _authProvider?.userdata?.data?.userSocialType == "phone"
                  //     ? const SizedBox()
                  //     :

                  AppStyles.height16SizedBox(),
                  // _authProvider?.userdata?.data?.userSocialType == "phone"
                  //     ? const SizedBox()
                  //     :

                  _emailField(),
                  AppStyles.height16SizedBox(),

                  //     :
                  _phoneNoTextField(),

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

                  _breakFastPrefrences(),
                  AppStyles.height16SizedBox(),

                  _LunchPrefrences(),
                  AppStyles.height16SizedBox(),

                  _dinnerPrefrences(),
                  AppStyles.height16SizedBox(),
                  CustomText(
                    text: 'Diet Preferences',
                    fontColor: widget.isEdit
                        ? AppColor.COLOR_BLACK
                        : AppColor.COLOR_WHITE,
                  ),
                  AppStyles.height8SizedBox(),
                  _dietPreffField(context),
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
                  _refralCodeField(),
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
                                                  breakFastPrefrences:
                                                      foodList.value,
                                                  lunchPrefrences:
                                                      lunchList.value,
                                                  dinnerPrefrences:
                                                      dinnerList.value,
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
                                                  breakFastPrefrences:
                                                      foodList.value,
                                                  dinnerPrefrences:
                                                      dinnerList.value,
                                                  lunchPrefrences:
                                                      lunchList.value,
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

  HeadingTextField _emailField() {
    return HeadingTextField(
        controller: email,
        heading: 'Email',
        textInputType: TextInputType.emailAddress,
        isRead: _authProvider?.userdata?.data?.userSocialType != "phone",
        inputFormat: [LengthLimitingTextInputFormatter(35)],
        validator: (String? val) => AppValidator.emailValidation(val!),
        headingColor:
            widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        bgColor: widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
        borderColor:
            widget.isEdit ? AppColor.TRANSPARENT_COLOR : AppColor.COLOR_BLACK);
  }

  HeadingTextField _fullNameField() {
    return HeadingTextField(
        controller: fullName,
        heading: 'Full Name',
        inputFormat: [LengthLimitingTextInputFormatter(35)],
        validator: (String? val) =>
            AppValidator.validateField("Full Name", val!),
        headingColor:
            widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        bgColor: widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
        borderColor:
            widget.isEdit ? AppColor.TRANSPARENT_COLOR : AppColor.COLOR_BLACK);
  }

  TypeAheadField<String> _dietPreffField(BuildContext context) {
    return TypeAheadField<String>(
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
            .where(
                (recipe) => recipe.toLowerCase().contains(search.toLowerCase()))
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
            fillColor:
                widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
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
          title: Text('No diets found. You can type your own diet.'),
        );
      },
    );
  }

  Visibility _refralCodeField() {
    return Visibility(
      visible: !widget.isEdit,
      child: HeadingTextField(
        heading: "Referral Code",
        controller: refreal,
        // validator: (val) {

        // },
        headingColor:
            widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        bgColor: widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
        borderColor:
            widget.isEdit ? AppColor.TRANSPARENT_COLOR : AppColor.COLOR_BLACK,
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

  _breakFastPrefrences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Breakfast Preferences',
          fontColor:
              widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
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
              breakFastController.clear();
              foodList.value?.add(suggestion);
              famusRecicpesBreakFast.remove(suggestion);
              setState(() {});
            }
          },
          suggestionsCallback: (search) {
            // Replace recipeList with your list of recipes
            return famusRecicpesBreakFast
                .where((recipe) =>
                    recipe.toLowerCase().contains(search.toLowerCase()))
                .toList();
          },
          itemBuilder: (context, recipe) {
            return ListTile(
              title: Text(recipe),
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            controller: breakFastController,
            onEditingComplete: () {
              if (foodList.value!.contains(breakFastController.text.trim())) {
                AppMessage.showMessage('Food Already Added');
                return;
              } else {
                if (breakFastController.text.trim().isNotEmpty) {
                  foodList.value?.add(breakFastController.text.trim());
                  famusRecicpesBreakFast
                      .remove(breakFastController.text.trim());
                  breakFastController.clear();
                  setState(() {});
                }
              }

              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor:
                    widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
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
          suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          noItemsFoundBuilder: (context) {
            return const ListTile(
              title: Text('No recipes found. You can type your own recipe.'),
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
                    padding: const EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 0),
                    child: FoodChip(
                      label: val[index]!,
                      color: AppColor.THEME_COLOR_SECONDARY,
                      isDeleteable: true,
                      onDelete: () {
                        if (!famusRecicpesBreakFast.contains(val[index])) {
                          famusRecicpesBreakFast.add(val[index]!);
                        }
                        val.removeAt(index);
                        setState(() {});
                      },
                    ),
                  ),
                ).toList(),
              );
            }),
      ],
    );
  }

  _LunchPrefrences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Lunch Preferences',
          fontColor:
              widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        ),
        AppStyles.height8SizedBox(),
        TypeAheadField<String>(
          onSuggestionSelected: (suggestion) {
            // if (food.text.isNotEmpty) {
            //   foodList.value!.add(suggestion);
            //   food.clear();
            //   setState(() {});
            // }
            if (lunchList.value!.contains(suggestion)) {
              AppMessage.showMessage('Food Already Added');
              FocusScope.of(context).unfocus();
              return;
            } else {
              lunchController.clear();
              lunchList.value?.add(suggestion);
              famusRecicpesBreakLunch.remove(suggestion);
              setState(() {});
            }
          },
          suggestionsCallback: (search) {
            // Replace recipeList with your list of recipes
            return famusRecicpesBreakLunch
                .where((recipe) =>
                    recipe.toLowerCase().contains(search.toLowerCase()))
                .toList();
          },
          itemBuilder: (context, recipe) {
            return ListTile(
              title: Text(recipe),
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            controller: lunchController,
            onEditingComplete: () {
              if (lunchList.value!.contains(lunchController.text.trim())) {
                AppMessage.showMessage('Food Already Added');
                return;
              } else {
                if (lunchController.text.trim().isNotEmpty) {
                  lunchList.value?.add(lunchController.text.trim());
                  famusRecicpesBreakLunch.remove(lunchController.text.trim());
                  lunchController.clear();
                  setState(() {});
                }
              }

              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor:
                    widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
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
          suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          noItemsFoundBuilder: (context) {
            return const ListTile(
              title: Text('No recipes found. You can type your own recipe.'),
            );
          },
        ),
        ValueListenableBuilder<List<String?>?>(
            valueListenable: lunchList,
            builder: (context, List<String?>? val, _) {
              return Wrap(
                children: List.generate(
                  val!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 0),
                    child: FoodChip(
                      label: val[index]!,
                      color: AppColor.THEME_COLOR_SECONDARY,
                      isDeleteable: true,
                      onDelete: () {
                        // famusRecicpes.add(val[index]!);
                        if (!famusRecicpesBreakLunch.contains(val[index])) {
                          famusRecicpesBreakLunch.add(val[index]!);
                        }
                        val.removeAt(index);
                        setState(() {});
                      },
                    ),
                  ),
                ).toList(),
              );
            }),
      ],
    );
  }

  _dinnerPrefrences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Dinner Preferences',
          fontColor:
              widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        ),
        AppStyles.height8SizedBox(),
        TypeAheadField<String>(
          onSuggestionSelected: (suggestion) {
            // if (food.text.isNotEmpty) {
            //   foodList.value!.add(suggestion);
            //   food.clear();
            //   setState(() {});
            // }
            if (dinnerList.value!.contains(suggestion)) {
              AppMessage.showMessage('Food Already Added');
              FocusScope.of(context).unfocus();
              return;
            } else {
              dinnerController.clear();
              dinnerList.value?.add(suggestion);
              famusRecicpesBreakDinner.remove(suggestion);
              setState(() {});
            }
          },
          suggestionsCallback: (search) {
            // Replace recipeList with your list of recipes
            return famusRecicpesBreakDinner
                .where((recipe) =>
                    recipe.toLowerCase().contains(search.toLowerCase()))
                .toList();
          },
          itemBuilder: (context, recipe) {
            return ListTile(
              title: Text(recipe),
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            controller: dinnerController,
            onEditingComplete: () {
              if (dinnerList.value!.contains(dinnerController.text.trim())) {
                AppMessage.showMessage('Food Already Added');
                return;
              } else {
                if (dinnerController.text.trim().isNotEmpty) {
                  dinnerList.value?.add(dinnerController.text.trim());
                  famusRecicpesBreakDinner.remove(dinnerController.text.trim());
                  dinnerController.clear();
                  setState(() {});
                }
              }

              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor:
                    widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
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
          suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          noItemsFoundBuilder: (context) {
            return const ListTile(
              title: Text('No recipes found. You can type your own recipe.'),
            );
          },
        ),
        ValueListenableBuilder<List<String?>?>(
            valueListenable: dinnerList,
            builder: (context, List<String?>? val, _) {
              return Wrap(
                children: List.generate(
                  val!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 0),
                    child: FoodChip(
                      label: val[index]!,
                      color: AppColor.THEME_COLOR_SECONDARY,
                      isDeleteable: true,
                      onDelete: () {
                        // famusRecicpes.add(val[index]!);
                        if (!famusRecicpesBreakDinner.contains(val[index])) {
                          famusRecicpesBreakDinner.add(val[index]!);
                        }
                        val.removeAt(index);
                        setState(() {});
                      },
                    ),
                  ),
                ).toList(),
              );
            }),
      ],
    );
  }

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
