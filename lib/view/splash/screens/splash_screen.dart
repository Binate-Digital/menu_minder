import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:provider/provider.dart';
import '../../../services/network/firebase_messaging_service.dart';
import '../../../services/network/shared_preference.dart';
import '../../../utils/asset_paths.dart';
import '../../auth/bloc/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthProvider? _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    // LocationService().getCurrentPosition();
    Future.delayed(const Duration(seconds: 2))
        .then((value) => _checkCurrentUserMethod());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColor.TRANSPARENT_COLOR,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      body: SizedBox(
          width: double.infinity,
          child: Image.asset(
            AssetPath.SPLASH_BG,
            fit: BoxFit.fill,
          )),
    );
  }

  Future<void> _checkCurrentUserMethod() async {
    await SharedPreference().sharedPreference;
    await FirebaseMessagingService().initializeNotificationSettings();
    FirebaseMessagingService().foregroundNotification();
    FirebaseMessagingService().backgroundTapNotification();
  }
}
