class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v)) return 'Invalid email';
    return null;
  }

  static String? minLength(String? value, int min) {
    final v = value ?? '';
    if (v.length < min) return 'Must be at least $min characters';
    return null;
  }
}
