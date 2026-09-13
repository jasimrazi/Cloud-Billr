class Validators {

  static String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phone = value.trim();

    // Remove spaces, + and -
    final cleanedPhone = phone.replaceAll(' ', '').replaceAll('-', '');

    if (cleanedPhone.startsWith('+')) {
      if (cleanedPhone.length < 10 || cleanedPhone.length > 15) {
        return 'Enter a valid phone number';
      }
    } else {
      if (cleanedPhone.length < 7 || cleanedPhone.length > 15) {
        return 'Enter a valid phone number';
      }
    }

    return null;
  }

  static String? websiteValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Website is optional
    }

    final website = value.trim().toLowerCase();

    if (!website.startsWith('http://') &&
        !website.startsWith('https://') &&
        !website.startsWith('www.')) {
      return 'Enter a valid website URL';
    }

    return null;
  }

}