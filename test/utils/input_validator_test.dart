import 'package:flutter_test/flutter_test.dart';
import 'package:first_aid_app/utils/input_validator.dart';

void main() {
  group('InputValidator - Email', () {
    test('debería validar emails correctos', () {
      expect(InputValidator.isEmailValid('test@uandina.edu.pe'), true);
      expect(InputValidator.isEmailValid('usuario@gmail.com'), true);
      expect(InputValidator.isEmailValid('nombre.apellido@empresa.com'), true);
    });

    test('debería rechazar emails inválidos', () {
      expect(InputValidator.isEmailValid('invalido'), false);
      expect(InputValidator.isEmailValid('@uandina.edu.pe'), false);
      expect(InputValidator.isEmailValid('test@'), false);
      expect(InputValidator.isEmailValid('test@.com'), false);
      expect(InputValidator.isEmailValid(''), false);
    });

    test('validateEmail debería retornar mensaje de error correcto', () {
      expect(InputValidator.validateEmail(''), 'El email es requerido');
      expect(InputValidator.validateEmail(null), 'El email es requerido');
      expect(InputValidator.validateEmail('invalido'), 'Email inválido');
      expect(InputValidator.validateEmail('test@uandina.edu.pe'), null);
    });
  });

  group('InputValidator - Password', () {
    test('debería validar contraseñas con longitud mínima', () {
      expect(InputValidator.isPasswordValid('123456'), true);
      expect(InputValidator.isPasswordValid('password'), true);
      expect(InputValidator.isPasswordValid('12345'), false);
    });

    test('debería validar contraseñas fuertes', () {
      expect(InputValidator.isPasswordStrong('Password123'), true);
      expect(InputValidator.isPasswordStrong('Test1234'), true);
      expect(InputValidator.isPasswordStrong('password'), false);
      expect(InputValidator.isPasswordStrong('PASSWORD'), false);
      expect(InputValidator.isPasswordStrong('12345678'), false);
    });

    test('validatePassword debería retornar mensaje correcto', () {
      expect(InputValidator.validatePassword(''), 'La contraseña es requerida');
      expect(InputValidator.validatePassword(null), 'La contraseña es requerida');
      expect(InputValidator.validatePassword('12345'), 'La contraseña debe tener al menos 6 caracteres');
      expect(InputValidator.validatePassword('123456'), null);
    });
  });

  group('InputValidator - Task Title', () {
    test('debería validar títulos correctos', () {
      expect(InputValidator.validateTaskTitle('Tarea válida'), null);
      expect(InputValidator.validateTaskTitle('ABC'), null);
      expect(InputValidator.validateTaskTitle('T' * 50), null);
    });

    test('debería rechazar títulos inválidos', () {
      expect(InputValidator.validateTaskTitle(''), 'El título es requerido');
      expect(InputValidator.validateTaskTitle(null), 'El título es requerido');
      expect(InputValidator.validateTaskTitle('AB'), 'El título debe tener al menos 3 caracteres');
      expect(InputValidator.validateTaskTitle('T' * 51), 'El título no debe exceder 50 caracteres');
    });
  });

  group('InputValidator - Task Description', () {
    test('debería validar descripciones correctas', () {
      expect(InputValidator.validateTaskDescription('Descripción válida'), null);
      expect(InputValidator.validateTaskDescription('12345'), null);
    });

    test('debería rechazar descripciones inválidas', () {
      expect(InputValidator.validateTaskDescription(''), 'La descripción es requerida');
      expect(InputValidator.validateTaskDescription(null), 'La descripción es requerida');
      expect(InputValidator.validateTaskDescription('1234'), 'La descripción debe tener al menos 5 caracteres');
      expect(InputValidator.validateTaskDescription('D' * 201), 'La descripción no debe exceder 200 caracteres');
    });
  });
}