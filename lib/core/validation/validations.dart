// lib/core/utils/validators.dart

class Validators {
  // Email Validation (Login & Signup dono ke liye)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Remove whitespace
    value = value.trim();
    
    // Comprehensive email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    // Check for common typos
    if (value.contains('..') || value.startsWith('.') || value.endsWith('.')) {
      return 'Invalid email format';
    }
    
    return null;
  }

  // Password Validation for LOGIN (simple)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least\ncharacters';
    }
    
    return null;
  }

  // Password Validation for SIGNUP (strong)
  static String? validateSignupPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8\n characters';
    }
    
    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least\none uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least\none lowercase letter';
    }
    
    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least\none number';
    }
    
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least\none special character';
    }
    
    // Check for whitespace
    if (value.contains(' ')) {
      return 'Password cannot contain spaces';
    }
    
    return null;
  }

  // Name Validation (Signup only)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    value = value.trim();
    
    if (value.length < 2) {
      return 'Name must be at least \n2characters';
    }
    
    if (value.length > 50) {
      return 'Name must be less than\n50 characters';
    }
    
    // Only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters\nand spaces';
    }
    
    // No leading/trailing spaces
    if (value != value.trim()) {
      return 'Name cannot start or end\n with spaces';
    }
    
    return null;
  }

  // Phone Number Validation (Optional for signup)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    value = value.trim();
    
    // Pakistan phone number format
    final phoneRegex = RegExp(r'^(\+92|0)?3[0-9]{9}$');
    
    if (!phoneRegex.hasMatch(value.replaceAll(' ', '').replaceAll('-', ''))) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  // Confirm Password Validation (Signup only)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}