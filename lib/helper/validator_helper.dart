class HelperValidator {

  static String? nameValidate(String value) {
    if (value.isEmpty) {
      return "Please enter user name";
    }
    if (value.length < 2) {
      return "Enter valid username";
    }
    if (value.length > 50) {
      return "Name too long";
    }
    return null;
  }

  static String? emailValidate(String value) {
    RegExp emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value.isEmpty) {
      return "Please Enter email";
    }
    if (!emailPattern.hasMatch(value)) {
      return "Email format is invalid!";
    }
    return null;
  }

  static String? passwordValidate(String value) {
    if (value.isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  static String? validatePasswordMatch(String? value, String? password) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

}
