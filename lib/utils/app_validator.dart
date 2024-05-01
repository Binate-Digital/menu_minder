import 'package:menu_minder/utils/regex.dart';

class AppValidator {
  static String? emailValidation(String value) {
    if (value.isEmpty) {
      return "Email field can't be empty.";
    }
    if (value.length > 35) {
      return "Email too large!";
    } else if (!RegExp(Regex.EMAIL_VALIDATION).hasMatch(value)) {
      return "Please enter valid email address.";
    }
    return null;
  }

  static validateField(String fieldName, String val) {
    if (val.trim().isEmpty) {
      return "$fieldName field can't be empty";
    }
  }

  static String? validateName(String value) {
    if (value.isEmpty) {
      return "Field can not be empty";
    }
    if (value.length > 35) {
      return "Name too large";
    }
    return null;
  }

  static String? validateOtp(String value) {
    if (value.length < 6) {
      return "Please enter complete OTP";
    }
    if (value.isEmpty) {
      return "Please enter OTP";
    }
    if (value != "123456") {
      return "Please enter correct OTP.";
    }
    return null;
  }

  static String? phoneValidation(String value) {
    if (value.isEmpty) {
      return "Phone Number field can't be empty";
    }
    if (value.length < 16) {
      return "Please enter valid phone number";
    }
    // if (!RegExp(Regex.PHONE_VALIDATE).hasMatch(value)) {
    //   return "Please enter valid phone number";
    // }
    return null;
  }

  static String? signPhoneValidation(String value) {
    if (value.isEmpty) {
      return "Phone Number field can't be empty";
    }
    if (value.length < 10) {
      return "Please enter valid phone number";
    }
    // if (!RegExp(Regex.PHONE_VALIDATE).hasMatch(value)) {
    //   return "Please enter valid phone number";
    // }
    return null;
  }

  static String? dateValidate(String value) {
    if (value.isEmpty) {
      return "Please enter DOB";
    }
    return null;
  }

  static String? expiryDate(String value) {
    if (value.isEmpty) {
      return "Please enter expiry date";
    }
    return null;
  }

  static String? validateLocation(String value) {
    if (value.isEmpty) {
      return "Please enter location";
    }
    return null;
  }

  static String? groupNameValidate(String value) {
    if (value.isEmpty) {
      return "Please enter group name.";
    }
    return null;
  }

  static String? aboutGroupValidate(String value) {
    if (value.isEmpty) {
      return "Write .";
    }
    return null;
  }

  static String? groupPrice(String value) {
    if (value.isEmpty) {
      return "Enter group charges.";
    }
    return null;
  }

  static String? cardHolderName(String value) {
    if (value.isEmpty) {
      return "Please enter card holder name.";
    }
    return null;
  }

  static String? cardNumber(String value) {
    if (value.isEmpty) {
      return "Please enter card number";
    } else if (value.length < 16) {
      return 'Card Number must be of length 16';
    } else if (value.length > 16) {
      return 'Wrong card number';
    }
    return null;
  }

  static String? cvcNumber(String value) {
    if (value.isEmpty) {
      return "Please enter CVC";
    } else if (value.length < 3) {
      return 'Enter correct CVC';
    }
    return null;
  }
}
