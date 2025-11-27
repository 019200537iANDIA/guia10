class InputValidator {
  static bool isEmailValid(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    // Mínimo 6 caracteres
    return password.length >= 6;
  }

  static bool isPasswordStrong(String password) {
    // Al menos 8 caracteres, una mayúscula, una minúscula y un número
    final strongRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$'
    );
    return strongRegex.hasMatch(password);
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'El email es requerido';
    }
    if (!isEmailValid(email)) {
      return 'Email inválido';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (!isPasswordValid(password)) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? validateTaskTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'El título es requerido';
    }
    if (title.trim().length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }
    if (title.trim().length > 50) {
      return 'El título no debe exceder 50 caracteres';
    }
    return null;
  }

  static String? validateTaskDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'La descripción es requerida';
    }
    if (description.trim().length < 5) {
      return 'La descripción debe tener al menos 5 caracteres';
    }
    if (description.trim().length > 200) {
      return 'La descripción no debe exceder 200 caracteres';
    }
    return null;
  }
}