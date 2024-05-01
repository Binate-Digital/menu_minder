import 'package:flutter/material.dart';
import 'package:menu_minder/utils/routes_names.dart';
import 'package:menu_minder/view/inbox/inbox_arguments.dart';
import 'package:menu_minder/view/inbox/screens/inbox_screen.dart';
import 'package:menu_minder/view/my_polls/screens/my_polls_screen.dart';
import 'package:menu_minder/view/splash/screens/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings,
        builder: (BuildContext context) {
          switch (routeSettings.name) {
            case AppRouteName.POLL_SCREEN:
              return const MyPollsScreen();
            case AppRouteName.splash:
              return const SplashScreen();
            case AppRouteName.inBoxScreen:
              InboxScreenArguments? inboxScreenArguments =
                  routeSettings.arguments as InboxScreenArguments?;
              return InboxScreen(
                isFromNotifications:
                    inboxScreenArguments?.isFromKilledNotifications ?? false,
              );
            default:
              return const SizedBox.shrink();
          }
        });
  }
}
