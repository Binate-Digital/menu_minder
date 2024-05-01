import 'package:flutter/material.dart';

class AppColor {
  static const Color THEME_COLOR_PRIMARY1 = Color(0xFFFA8072);
  static const Color THEME_COLOR_PRIMARY2 = Color(0xFFFECC2F);
  static const Color THEME_COLOR_SECONDARY = Color(0xFF93E9BE);
  static const TRANSPARENT_COLOR = Color(0x00000000);
  static const Color BG_COLOR = Color(0xFFFDF9F1);

  static const Color COLOR_GREY1 = Color(0xFF464646);
  static const Color COLOR_GREY2 = Color(0xFFBEBEBE);
  static const COLOR_GREY3 = Color(0xFFFBFDFE); // used for shadow
  static const Color COLOR_GREY4 = Color(0xFFF5F5F5);
  static const Color COLOR_BLUE = Color(0xFF1877F2);
  static const Color SKINNY = Color(0xFFE08484);
  static Color INPUTBACKGROUND = COLOR_WHITE;

  static const COLOR_RED1 = Color(0xFFFE0000);
  static const COLOR_GREEN1 = Color(0xFF13D106);
  static const Color COLOR_BLACK = Color(0xFF000000);
  static const Color COLOR_WHITE = Color(0xFFFFFFFF);
  static const COLOR_TRANSPARENT = Colors.transparent;
  static const COLOR_SCAFFOLD = Color(0xFFFFFDF2);
  static const COLOR_Light_Green = Color(0xFFE8F4E2);
  static const CONTAINER_GREY = Color(0xFFF8F8F8);
}

class AppDimen {
  static const double SPLASH_LOGO_WIDTH = 280;
  static const double APPBARSIZE = 50;
  static const double LOGIN_LOGO_WIDTH = 230;
  static const double LOGIN_PADDING_HORZ = 20;
  static const double DASHBOARD_PADDING_HORZ = LOGIN_PADDING_HORZ;
  static const double SCROLL_OFFSET_PADDING_VERT = 20;
  static const double LOGIN_APPBAR_HEIGHT = 60;
  static const double APPBAR_ICON_SIZE = 20;
  static const double APPBAR_ICON_BUTTON_SIZE = 20;
  static const double DASHBOARD_APPBAR_HEIGHT = LOGIN_APPBAR_HEIGHT;
  static const double APPBAR_HORZ_PADDING = 20;
  static const double LOGIN_BUTTON_VERT_PADDING = 17;
  static const double LOGIN_FIELD_BW_SPACING = 13;
  static const double LOGIN_LOGO_SPACING = 55;
  //static const double LOGIN_BUTTON_HORZ_PADDING=30;
  static const double LOGINFIELD_HORZ_PADDING = 8;
  static const double LOGINFIELD_VERT_PADDING = 8;
  static const double CUSTOMFIELD_VERT_PADDING = 14;
  static const double DESCRIPTIONFIELD_HORZ_PADDING = 14;
  static const double LOGINFIELD_ICON_HORZ_PADDING = 13;
  static const double DASHBOARD_NAVIGATION_BAR_HEIGHT = 60;
  static const double CHECK_BOX_SIZE = 15;
  static const double SCREEN_PADDING = 20;

  static const double HOME_LISTVIEW_HEIGHT = 190;

  static const double LOGIN_BUTTON_RADIUS = 12;
  static const double LOGIN_FIELD_RADIUS = LOGIN_BUTTON_RADIUS;
  static const double MESSAGE_FIELD_RADIUS = 10;
  static const double BOTTOMBAR_RADIUS = 30;
  static const double INSPECTION_PANE_RADIUS = 15;
  static const double DRAWER_RADIUS = 50;
  static const double PROFILE_PIC_DIAM = 130;
  static const double SEARCH_BOX_RADIUS = 17;
  static const double BOX_RADIUS = 20;
  static const double ALERT_RADIUS = 15;
  static const double BOTTOM_PANEL_RADIUS = 30;

  static const double MENU_HEIGHT = 430;
  static const double MENU_WIDTH = 200;

  static const double FONT_TEXT_FIELD = 13;
  static const double FONT_DROPDOWN_FIELD = 11;
  static const double FONT_ALERT_HEADING = 17;

  static const double ALERT_ICON_SIZE = 22;
}

class AppInteger {
  static const int SPLASH_DURATION_SEC = 2;
  static const int IMAGE_QUALITY = 25;
  static const int STANDARD_DURATION_MILLI = 400;
  static const int SWIPE_DURATION_MILLI = 300;
}

class FontFamily {
  static const POPPINS = "Poppins";
}

class ValidationRegex {
  static const String EMAIL_VALIDATION =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String PASSWORD_VALIDATE =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'; // to uncomment
  // static const String PASSWORD_VALIDATE = r'^([0-9]){2,4}$';
  // static const String PASSWORD_VALIDATE = r'^[0-9]+$';
  //static const String PASSWORD_VALIDATE = r'^[0-9].*$';// there is difference b/w * and .* and also + works which is e.* or e+
  //static const String PASSWORD_VALIDATE = r'^(([0-9]+)([a-z]+))|(([a-z]+)([0-9]+))$';
//  static const String PASSWORD_VALIDATE = r'^d+?$';
  // static const String PASSWORD_VALIDATE = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{1,}$';
  // static const String PASSWORD_VALIDATE = r'^\w+(?=[+])$';
  static const String PHONE_VALIDATE =
      r'^\+?1?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$';
  static const String PHONE_VALIDATE_SINGLE = r'^[0-9]$';
  static const String PHONE_FORMAT = "+##########";
  static const String CREDIT_CARD_FORMAT = "#### #### #### ####";
}

class MapConstants {
  static String mapKey = 'AIzaSyBmaS0B0qwokES4a_CiFNVkVJGkimXkNsk';
}
