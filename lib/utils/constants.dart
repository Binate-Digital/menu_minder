import 'package:flutter/material.dart';

class Constants {
  BuildContext context;

  static bool isSubscriptionPurchased = false;

  Constants(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  static const Pattern EMAIL_VALIDATION_REGEX =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static const Pattern PASSWORD_VALIDATE_REGEX =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  static const String EMAIL_VALIDATION =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String PHONE_VALIDATION = r'^[0-9]+$';
  static const String LATITUDE_PATTERN =
      r'^(\+|-)?((\d((\.)|\.\d{1,10})?)|(0*?[0-8]\d((\.)|\.\d{1,10})?)|(0*?90((\.)|\.0{1,10})?))$';
  static const String LONGITUDE_PATTERN =
      r'^(\+|-)?((\d((\.)|\.\d{1,10})?)|(0*?\d\d((\.)|\.\d{1,10})?)|(0*?1[0-7]\d((\.)|\.\d{1,10})?)|(0*?180((\.)|\.0{1,10})?))$';
  static const String PASSWORD_VALIDATE =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static const String SSN_NUMBER_VALIDATION =
      r'^(?!666|000|9\\d{2})\\d{3}-(?!00)\\d{2}-(?!0{4})\\d{4}$';

  ///-------------------- Font Family -------------------- ///
  static const String ROBOTO_FAMILY = "Roboto";

  ///-------------------- Date Formats -------------------- ///
  static const String MM_DD_YYYY_FORMAT = 'MM/dd/yyyy';

  ///-------------------- Dummy Data -------------------- ///
  static const String DUMMY_NAME = "Tom_0408";
  static const String DUMMY_PHONE = "+123 456 7890";
  static const String DUMMY_EMAIL = "tom@domain.com";
  static const String DUMMY_DATE = "April 25,2021";
  static const String DUMMY_TIME = "04:55";
  static const String DUMMY_GENDER = "Male";
  static const String DUMMY_HEIGHT = "5'6\"";
  static const String DUMMY_WEIGHT = "200lb";
  static const String DUMMY_LITER_FLOW = "10ltr/min";
  static const String DUMMY_ADDRESS = "847,Christiansen Roads, Suite 927, USA";
  static const String DUMMY_CONNECTIONS = "(05)";
  static const String DUMMY_COST = "\$5";
  static const String DUMMY_ITEM_COUNT = "4";

  static const String DUMMY_ALEX_JIM = "Alex Jim";
  static const String DUMMY_JAIME = "Jaime";
  static const String DUMMY_LINDA = "Linda";
  static const String DUMMY_PARKER = "Parker";
  static const String DUMMY_ANDY = "Andy";

  static const String DUMMY_ORDER_TITLE = "Order Title";
  static const String DUMMY_STATUS = "Your order is ready Suite 200, Mt Laurel";
  static const String DUMMY_SEMI_ELECTRIC_BED = "Drive Semi electric Bed";
  static const String DUMMY_OVERBED_TABLE = "Overbed Table";
  static const String DUMMY_THERAPEUTIC_BED_MATTRESS =
      "Therapeutic Bed Mattress";
  static const String DUMMY_VINYL_GLOVES = "Vinyl Gloves, Box of 100";
  static const String DUMMY_FACE_SHIELD = "Face Shield";
  static const String DUMMY_DRIVE_TRANSFER_BENCH = "Drive Transfer Bench";
  static const String DUMMY_CHROME_GRAB_BARS = "Chrome grab bars";
  static const String DUMMY_PRODUCT_UPGRADE = "Product Upgrade";

  static const String DUMMY_PROFILE_PICTURE =
      "https://firebasestorage.googleapis.com/v0/b/game-of-memes-852ee.appspot.com/o/image.jpeg?alt=media&token=0007b2a2-c2e4-4dfd-bf4c-c8169080f7b3";
  static const String DUMMY_HISTORY =
      "https://static.babyandchild.ae/imgs/1679_children-and-face-masks-most-xlarge.jpg";

  static const String DUMMY_TITLE =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";

  static const String DUMMY_TEXT =
      """Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
      Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.""";

  ///-------------------- Navigation Routes -------------------- ///
  static const String SPLASH_ROUTE = "/";
  static const String SIGN_UP_ROUTE = "/signup";
  static const String SIGN_IN_ROUTE = "/signin";
  static const String SOCIAL_LOGIN_ROUTE = "/social";
  static const String FORGOT_PASSWORD_ROUTE = "/forget";
  static const String VERIFICATION_ROUTE = "/verification";
  static const String CHANGE_PASSWORD_ROUTE = "/change_password";
  static const String UPDATE_PASSWORD_ROUTE = "/update_password";

  static const String FAVOURITE_ROUTE = "/favourites";
  static const String MY_SOUND_ROUTE = "/my_sound";
  static const String UPLOAD_ROUTE = "/upload";
  static const String SETTINGS_ROUTE = "/settings";
  static const String ACCOUNTS_ROUTE = "/accounts";
  static const String MANAGE_SUBSCRIPION = "/manage_subscription";
  static const String MY_CREDIT_ROUTE = "/my_credit";

  static const String TERMS_AND_PRIVACY_ROUTE = "/terms_privacy";
  static const String PRIVACY_ROUTE = "/privacy";
  static const String HELP_CENTER_ROUTE = "/help_center";
  static const String HOME_ROUTE = "/home";
  static const String NOTIFICATION_ROUTE = "/notification";
  static const String PICK_UP_ROUTE = "/pick_up";
  static const String VIEW_ORDER_ROUTE = "/view_order";
  static const String MY_ORDER_ROUTE = "/my_order";
  static const String ORDER_DETAILS_ROUTE = "/order_details";
  static const String MY_PATIENT_ROUTE = "/my_patient";
  static const String PATIENTS_DETAILS_ROUTE = "/patients_details";
  static const String PATIENT_INFO_ROUTE = "/patient_info_route";
  static const String EDIT_PATIENT_PROFILE_ROUTE = "/edit_patient_profile";
  static const String INBOX_ROUTE = "/inbox_route";
  static const String CHAT_ROUTE = "/chat_route";
  static const String PRODUCT_CATALOGUE_ROUTE = "/product_catalogue";
  static const String PRODUCT_DETAILS_ROUTE = "/product_details";
  static const String EQUIPMENT_ROUTE = "/equipment";
  static const String MY_CART_ROUTE = "/my_cart";

  ///-------------------- API Constants -------------------- ///
  static const String MAP_KEY = 'AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ';
  static const String ACCEPT = 'application/json';
  static const int SUCCESS_CODE = 200;
  static const int UNAUTHORIZED_USER_CODE = 401;
  static const int API_SUCCESS_STATUS = 1;
  static const int API_FAILURE_STATUS = 0;
  static const String TERMS_AND_CONDITIONS = "tc";
  static const String PRIVACY_POLICY = "pp";

  /// Registration
  static const String ANDROID = "android";
  static const String IOS = "ios";
  static const int EMAIL_VERIFIED = 1;
  static const int PROFILE_COMPLETED = 1;

  ///-------------------- API's End Point -------------------- ///

  /// Registration
  static const String LOGIN = "user_login";
  static const String SIGN_UP = "signup";
  static const String FORGOT_PASSWORD = "forgot_password";
  static const String VERIFICATION = "user_verification";
  static const String UPDATE_PASSWORD = "update_password";
  static const String RESEND_CODE = "re_send_code";
  static const String HOSPITAL_LIST = "hospitalList";
  static const String COMPLETE_PROFILE = "complete_profile";
  static const String LOGOUT = "logout";

  /// Settings
  static const String CONTENT = "content";
  static const String HELP_CENTER = "helpFeedback";
  static const String NOTIFICATION_LIST = "notificationList";
  static const String CHANGE_PASSWORD = "changePassword";

  // CHAT
  static const String GET_MESSAGE = "getMessage";
  static const String SAVE_MESSAGE = "saveMessage";
  static const String ADMIN_INFO = "adminInfo";

  //Patient APIs
  static const String ADD_PATIENT = "addPatient";
  static const String UPDATE_PATIENT = "updatePatient";
  static const String LIST_PATIENT = "patientList";
  static const String LIST_PRODUCT = "productList";
  static const String GET_CATEGORIES = "AllCategoryList";

  //ORDER APIS
  static const String ADD_ORDER = "addOrder";
  static const String ALL_ORDERS = "orderList";
  static const String CHECK_ORDER = "checkOrder";
  static const String OPEN_ORDERS_TYPE = "in_process";
  static const String CLOSE_ORDERS_TYPE = "close";

  ///status from apis for order items
  static const String PRODUCT_ORDERED = "ordered";
  static const String PRODUCT_PLACED = "processed";
  static const String PRODUCT_ON_THE_WAY_TO_HOSPITAL = "out-for-delivery";
  static const String PRODUCT_DELIVERED_TO_HOSPITAL = "delivered";
  static const String PRODUCT_PICKUP_REQUESTED = "pickup-requested";
  static const String PRODUCT_RETURNED = "picked-up";

  ///
  static const String PATIENT_ORDERS = "patientOrderList";
  static const String PATIENT_OPEN_ORDERS = "patientOrderListInProcess";
  static const String REQUEST_PICKUP = "pickUpRequest";

  ///-------------------- Shared Preference Keys -------------------- ///
  static const String BEARER_TOKEN = "Bearer Token";
  static const String USER = "User";
  static const int BAD_REQUEST_CODE = 400;
  static const int NOT_FOUND = 404;
  static const String USER_TYPE = "User Type";
}
