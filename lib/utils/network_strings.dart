class NetworkStrings {
  static const String ACCEPT = 'application/json';

  ////// API STATUS CODE/////////////
  static const int SUCCESS_CODE = 200;
  static const int UNAUTHORIZED_CODE = 401;
  static const int CARD_ERROR_CODE = 402;
  static const int BAD_REQUEST_CODE = 400;
  static const int FORBIDDEN_CODE = 403;

  /////////// API MESSAGES /////////////////
  static const int API_SUCCESS_STATUS = 1;
  static const String EMAIL_UNVERIFIED = "0";
  static const String EMAIL_VERIFIED = "1";
  static const String PROFILE_INCOMPLETED = "0";
  static const String PROFILE_COMPLETED = "1";
  static const String BANNER_ADD_ID_ANDROID =
      "ca-app-pub-5760460145213220/6412515390";

  static const String BANNER_ADD_ID_ANDROID_TEST =
  "ca-app-pub-5760460145213220/2073325145";
      // "ca-app-pub-3940256099942544/6300978111";

  static const String BANNER_ADD_ID_IOS =
      "ca-app-pub-5760460145213220/1264130490";

  static const String BANNER_ADD_ID_IOS_TEST =
      "ca-app-pub-3940256099942544/2934735716";

  //Social Login Endpoints
  static const String SIGNUP_ENDPOINT = "user_create";
  static const String VERIFY_OTP_ENDPOINT = "otp-verify";
  static const String RESEND_OTP_CODE_ENDPOINT = "signup/resend-otp";
  static const String LOGIN_ENDPOINT = "signin";
  static const String FORGET_PASSWORD_ENDPOINT = "forgot_password";
  static const String CHANGE_PASSWORD_ENDPOINT = "update_password";
  static const String COMPLETE_PROFILE_ENDPOINT = "update-profile";
  static const String CONTENT_ENDPOINT = "content";
  static const String SOCIAL_LOGIN_ENDPOINT = "social";
  static const String SIGN_OUT_ENDPOINT = "logout";
  static const String OTHER_USER_PROFILE_ENDPOINT = "user_profile";

  /////////// API TOAST MESSAGES //////////////////
  static const String NO_INTERNET_CONNECTION = "No Internet Connection!";
  static const String SOMETHING_WENT_WRONG = "Something Went Wrong";
  static const String ALREADY_SELECTED_DATE_TEXT = "Already Selected!";
  static const String INVALID_CARD_ERROR = "Invalid Card Details.";
  static const String CARD_TYPE_ERROR = "Wrong card type.";
  static const String INVALID_BANK_ACCOUNT_DETAILS_ERROR =
      "Invalid Bank Account Details.";
  static const String MERCHANT_ACCOUNT_ERROR =
      "Error:Merchant Account can not be created.";
  ///////////////////// CONTENT QUERY PARAMETERS /////////////////
  static const String TERMS_AND_CONDITIONS_CONTENT_PARAMETER = "tc";
  static const String PRIVACY_POLICY_CONTENT_PARAMETER = "pp";
  static const String ABOUT_APP_CONTENT_PARAMETER = "about";
  static const String DISCLAIM_CONTENT_PARAMETER = "disclaim";

  // ---------------------- Shared Preference Key Names ------------------------ //
  static const String BEARER_TOKEN_KEY = "bearer_token";
  static const String CURRENT_USER_DATA_KEY = "current_user_data";
}
