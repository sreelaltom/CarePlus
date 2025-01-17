class AuthValidators {
  static String? validateEmail({required String value}) {
    if (value.isEmpty) {
      return 'This is a required field';
    }

    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(value) ? null : 'Please enter a valid email.';
  }

  static String? validatePhone({required String value}) {
    if (value.isEmpty) {
      return 'This is a required field';
    }
    if (value.length > 10 || (value.length < 10)) {
      return 'Enter a valid number';
    }
    return null;
  }

  static String? validatePassword({required String value}) {
    if (value.isEmpty) {
      return 'This is a required field';
    }
    if (value.length < 8) {
      return 'Password should have at least 8 characters';
    }
    final capRegex = RegExp(r'.*[A-Z].*');
    if (capRegex.hasMatch(value) == false) {
      return 'Password should have at least one capital letter.';
    }
    final smallRegex = RegExp(r'.*[a-z].*');
    if (smallRegex.hasMatch(value) == false) {
      return 'Password should have at least one small letter.';
    }
    final numRegex = RegExp(r'.*[0-9].*');
    if (numRegex.hasMatch(value) == false) {
      return 'Password should have at least one number.';
    }
    final specialRegex = RegExp(r'.*[!@#$%^&*(),.?":{}|<>].*');
    if (specialRegex.hasMatch(value) == false) {
      return 'Password should have at least one special character.';
    }

    const passwordPattern =
        r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&*()-+=])(?=\S+$).{8,20}$';
    final regExp = RegExp(passwordPattern);
    return regExp.hasMatch(value) ? null : 'Please enter a valid password';
  }

  static String? validateConfirmPassword({
    required String value,
    required String matchValue,
  }) {
    final isValid = validatePassword(value: value);
    return isValid != null || value != matchValue
        ? 'Passwords do not match'
        : null;
  }

  static String? validateRegId({required String value}) {
    return null;
  }

  static String? validateName({required String value}) =>
      value.isEmpty ? "This field is required" : null;
}
