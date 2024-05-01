import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:menu_minder/providers/chat_provider.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/providers/map_provider.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/services/network/firbase_phone_login.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/utils/routes.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/repo/core_repo.dart';
import 'package:menu_minder/providers/notifications_provider.dart';
import 'package:menu_minder/view/auth/bloc/repository/auth_repo.dart';
import 'package:menu_minder/view/map/repository/map_repo.dart';
import 'package:menu_minder/view/splash/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'utils/route_observer.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              AuthProvider(AuthRepo(), LoginWithPhoneService.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(AuthRepo(), CoreRepo()),
        ),
        ChangeNotifierProvider(
          create: (context) => CoreProvider(CoreRepo()),
        ),
        ChangeNotifierProvider(
          create: (context) => MapProvider(MapRepo()),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(CoreRepo()),
        ),
        ChangeNotifierProvider(
          create: (context) => SpoonCularProvider(CoreRepo()),
        ),
      ],
      child: MaterialApp(
        title: 'Menu Minder',
        navigatorKey: StaticData.navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorObservers: [AppNavObserver()],
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 600, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.white),
        home: const App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
