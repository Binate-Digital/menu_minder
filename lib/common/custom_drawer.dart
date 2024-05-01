// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:great_8_cleaning/common_screens/drawer_screen/widget/menu_item.dart';

// import 'package:url_launcher/url_launcher.dart';

// import '../../Utils/app_colors.dart';
// import '../../Utils/app_route_name.dart';
// import '../../Utils/assets_path.dart';
// import '../../Utils/navigation.dart';
// import '../../Widgets/app_dialogs.dart';
// import '../../Widgets/custom_appbar_widget.dart';
// import '../../Widgets/custom_text_widget.dart';
// import '../../main.dart';
// import '../bottom_bar/view/bottom_bar.dart';
// import '../utils/app_navigator.dart';

// class DrawerScreen extends StatefulWidget {
//   @override
//   State<DrawerScreen> createState() => _DrawerScreenState();
// }

// class _DrawerScreenState extends State<DrawerScreen>
//     with SingleTickerProviderStateMixin {
//   final Uri _terms_condition = Uri.parse('https://www.google.com/');

//   Future<void> _terms_and_condition_Url() async {
//     if (!await launchUrl(_terms_condition)) {
//       throw 'Could not launch $_terms_condition';
//     }
//   }

//   AnimationController? animationController;

//   Animation<double>? scaleAnimation;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int popupAnimationDuration = 400;
//   Curve popupAnimationType = Curves.easeIn;
//   @override
//   void initState() {
//     animationController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: popupAnimationDuration));
//     scaleAnimation = CurvedAnimation(
//         parent: animationController!, curve: popupAnimationType);
//     animationController!.addListener(() {
//       setState(() {});
//     });
//     animationController!.forward();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: AppNavigatorKey.key,
//         drawer: ClipRRect(
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(50),
//               bottomRight: Radius.circular(50)),
//           child: Drawer(
//             width: 320.0,
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(50.r),
//                       bottomRight: Radius.circular(50.r)),
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       AppColors.primaryColor,
//                       AppColors.primaryColor,
//                     ],
//                   )),
//               child: ListView(
//                 physics: const ClampingScrollPhysics(),
//                 children: <Widget>[
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: AppColors.whiteColor,
//                     child: CircleAvatar(
//                         radius: 48.0,
//                         backgroundColor: AppColors.primaryColor,
//                         backgroundImage:
//                             const AssetImage(AssetPaths.USER_IMAGE)),
//                   ),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                   Center(
//                     child: CustomTextWidget(
//                       text: "John Smith",
//                       textColor: AppColors.whiteColor,
//                       textSize: 1.3.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 3.h,
//                   ),
//                   Center(
//                     child: CustomTextWidget(
//                       text: "johnsmith@getnada.com",
//                       textColor: AppColors.whiteColor.withOpacity(0.4),
//                       textSize: 1.13.sp,
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       ReuabledrawerItems(
//                         title: "Home",
//                         imagewant: true,
//                         imgs: AssetPaths.HOME2_ICON,
//                         onpress: () {
//                           AppNavigation.navigatorPop(context);
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Past Services",
//                         imagewant: true,
//                         imgs: AssetPaths.PAST_SERVICES_ICON,
//                         onpress: () {},
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Upload Property",
//                         imagewant: true,
//                         imgs: AssetPaths.UPLOAD_PROPERTY_ICON,
//                         onpress: () {},
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Terms & Conditions",
//                         imgs: AssetPaths.TERMS_CONDITIONS_ICON,
//                         imagewant: true,
//                         onpress: () {},
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Privacy Policy",
//                         imagewant: true,
//                         imgs: AssetPaths.PRIVACY_POLICY_ICON,
//                         onpress: () {},
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Help Center",
//                         imagewant: true,
//                         imgs: AssetPaths.HELP_CENTER_ICON,
//                         onpress: () {},
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Setting",
//                         imagewant: true,
//                         imgs: AssetPaths.SETTING_ICON,
//                         onpress: () {},
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30),
//                         child: Divider(
//                           color: AppColors.primaryColor.withOpacity(0.5),
//                           thickness: 3,
//                         ),
//                       ),
//                       ReuabledrawerItems(
//                         title: "Delete Account",
//                         imagewant: true,
//                         iconColor: AppColors.whiteColor,
//                         imgs: AssetPaths.USER_ICON,
//                         onpress: () {
//                           _showDialogToDeleteReminder(context);
//                         },
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Container(
//                         height: 45.0,
//                         width: 170.0,
//                         decoration: BoxDecoration(
//                             color: AppColors.whiteColor,
//                             borderRadius: const BorderRadius.only(
//                                 topRight: Radius.circular(10.0),
//                                 bottomRight: Radius.circular(10.0))),
//                         child: ReuabledrawerItems(
//                           title: "Logout",
//                           textColor: AppColors.primaryColor,
//                           iconColor: AppColors.primaryColor,
//                           imagewant: true,
//                           imgs: AssetPaths.LOGOUT_ICON,
//                           onpress: () {
//                             AppDialogs.showToast(
//                                 message: "Logout successfully");
//                             AppNavigation.navigateToRemovingAll(
//                                 context, AppRouteName.SOCIAL_LOGIN_SCREEN);
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: BottomBar());
//   }

//   Future<void> _showDialogToDeleteReminder(BuildContext context) async {
//     return (await showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setInnerState) {
//             return ScaleTransition(
//               scale: scaleAnimation!,
//               child: Dialog(
//                 backgroundColor: AppColors.whiteColor,
//                 insetAnimationCurve: Curves.bounceOut,
//                 insetAnimationDuration: const Duration(seconds: 2),
//                 insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 elevation: 5,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     CustomTextWidget(
//                       text: "Are you sure you want to delete \n this account?",
//                       fontWeight: FontWeight.bold,
//                       textColor: Colors.black,
//                       textSize: 1.2.sp,
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               AppNavigation.navigatorPop(context);
//                             },
//                             child: Container(
//                               // width: 20,
//                               // height: 40,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               decoration: BoxDecoration(
//                                   color: AppColors.greyButtonColor,
//                                   borderRadius: const BorderRadius.only(
//                                     bottomLeft: Radius.circular(20),
//                                     bottomRight: Radius.circular(0),
//                                   )),
//                               child: Center(
//                                 child: CustomTextWidget(
//                                   text: "Cancel",
//                                   fontWeight: FontWeight.bold,
//                                   textSize: 1.2.sp,
//                                   textColor: AppColors.blackColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               AppNavigation.navigateToRemovingAll(
//                                   context, AppRouteName.SOCIAL_LOGIN_SCREEN);
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [
//                                       AppColors.primaryColor,
//                                       AppColors.purpleDarkColor,
//                                     ],
//                                   ),
//                                   borderRadius: const BorderRadius.only(
//                                     bottomLeft: Radius.circular(0),
//                                     bottomRight: Radius.circular(20),
//                                   )),
//                               child: Center(
//                                 child: CustomTextWidget(
//                                   text: "Delete",
//                                   fontWeight: FontWeight.bold,
//                                   textSize: 1.2.sp,
//                                   textColor: AppColors.whiteColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           });
//         }));
//   }
// }
