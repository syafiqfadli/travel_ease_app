class InputValidator {
  String? emailValidation(String? text) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text!);

    if (text.isEmpty) {
      return "Please enter email";
    }

    if (!emailValid) {
      return "Please enter valid email";
    }

    return null;
  }

  String? passwordValidation(String? text) {
    if (text!.isEmpty) {
      return "Please enter password";
    }

    return null;
  }

  String? nameValidation(String? text) {
    if (text!.isEmpty) {
      return "Please enter name";
    }

    return null;
  }

  String? createPasswordValidation(String? text) {
    if (text!.isEmpty) {
      return "Please enter password";
    }

    final bool hasUppercase = RegExp(r"^(?=.*?[A-Z])").hasMatch(text);
    final bool hasLowercase = RegExp(r"^(?=.*?[a-z])").hasMatch(text);
    final bool hasNumber = RegExp(r"^(?=.*?[0-9])").hasMatch(text);
    final bool isMinimum = RegExp(r"^.{8,}$").hasMatch(text);

    // 1 false
    if (hasUppercase && hasLowercase && hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
""";
    }

    if (hasUppercase && !hasLowercase && hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 lowercase letter
""";
    }

    if (!hasUppercase && hasLowercase && hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 uppercase letter
""";
    }

    if (hasUppercase && hasLowercase && !hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 number
""";
    }

    // 2 false
    if (hasUppercase && hasLowercase && !hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
- 1 number
""";
    }

    if (hasUppercase && !hasLowercase && hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
- 1 lowercase letter
""";
    }

    if (!hasUppercase && hasLowercase && hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
- 1 uppercase letter
""";
    }

    if (!hasUppercase && hasLowercase && hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 1 uppercase letter 
- 8 characters
""";
    }

    if (!hasUppercase && !hasLowercase && hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 uppercase letter 
- 1 lowercase letter 
""";
    }

    if (!hasUppercase && hasLowercase && !hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 uppercase letter 
- 1 number 
""";
    }

    if (hasUppercase && !hasLowercase && !hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 lowercase letter 
- 1 number 
""";
    }

    if (!hasUppercase && !hasLowercase && hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 lowercase letter 
- 1 uppercase letter 
""";
    }

    if (hasUppercase && !hasLowercase && hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 1 lowercase letter 
- 8 characters
""";
    }

    // 3 false
    if (hasUppercase && !hasLowercase && !hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
- 1 lowercase letter
- 1 number
""";
    }

    if (!hasUppercase && hasLowercase && !hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
- 1 uppercase letter
- 1 number
""";
    }

    if (!hasUppercase && !hasLowercase && hasNumber && !isMinimum) {
      return """
Password must contains at least:
- 8 characters
- 1 uppercase letter
- 1 lowercase letter
""";
    }

    if (!hasUppercase && !hasLowercase && !hasNumber && isMinimum) {
      return """
Password must contains at least:
- 1 uppercase letter
- 1 lowercase letter
- 1 number
""";
    }

    return null;
  }
}
