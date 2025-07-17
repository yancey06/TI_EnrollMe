String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
} 