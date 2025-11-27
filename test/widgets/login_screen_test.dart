import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_aid_app/screens/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('debería mostrar todos los elementos de la UI', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verificar que existe el título de la app
      expect(find.text('First Aid App'), findsOneWidget);

      // Verificar que existe el campo de email
      expect(find.byKey(const Key('email_field')), findsOneWidget);

      // Verificar que existe el campo de contraseña
      expect(find.byKey(const Key('password_field')), findsOneWidget);

      // Verificar que existe el botón de login (usar Key en lugar de texto)
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('debería mostrar error cuando email es inválido', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Ingresar email inválido
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'emailinvalido',
      );

      // Ingresar contraseña válida
      await tester.enterText(
        find.byKey(const Key('password_field')),
        '123456',
      );

      // Tocar el botón de login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verificar que se muestra el error
      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('debería mostrar error cuando contraseña es muy corta', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Ingresar email válido
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@uandina.edu.pe',
      );

      // Ingresar contraseña corta
      await tester.enterText(
        find.byKey(const Key('password_field')),
        '12345',
      );

      // Tocar el botón de login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verificar que se muestra el error
      expect(find.text('La contraseña debe tener al menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('debería permitir ingresar texto en los campos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Ingresar email
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@uandina.edu.pe',
      );

      // Ingresar contraseña
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Verificar que el texto se ingresó
      expect(find.text('test@uandina.edu.pe'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('debería tener iconos en los campos de texto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verificar icono de email
      expect(find.byIcon(Icons.email), findsOneWidget);

      // Verificar icono de contraseña
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('el botón de login debería existir', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Ingresar datos válidos
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@uandina.edu.pe',
      );

      await tester.enterText(
        find.byKey(const Key('password_field')),
        '123456',
      );

      await tester.pump();

      // Verificar que el botón existe usando su Key
      final button = find.byKey(const Key('login_button'));
      expect(button, findsOneWidget);
      
      // Verificar que es un ElevatedButton
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}