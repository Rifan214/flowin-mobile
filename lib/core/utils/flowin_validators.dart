/// Shared client-side form field validators for Flowin.
class FlowinValidators {
  FlowinValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your email address';
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address (e.g. name@flowin.id)';
    }
    return null;
  }

  static String? requiredText(
    String? value, {
    required String fieldName,
    int minLength = 2,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldName cannot be empty';
    }
    if (trimmed.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }
}

