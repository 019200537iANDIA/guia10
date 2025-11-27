import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_aid_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('First Aid App - Integration Tests', () {
    testWidgets('Flujo completo: incrementar, decrementar y resetear contador',
        (tester) async {
      // Iniciar la app
      app.main();
      await tester.pumpAndSettle();

      // Verificar que la app inició correctamente
      expect(find.text('Sistema de Gestión de Tareas'), findsOneWidget);
      expect(find.byKey(const Key('counter_text')), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // TEST 1: Incrementar contador 3 veces
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pumpAndSettle();
      }
      expect(find.text('3'), findsOneWidget);

      // TEST 2: Decrementar contador 1 vez
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // TEST 3: Resetear contador
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      // TEST 4: Verificar que los botones funcionan después del reset
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Verificar que el título de la app es correcto', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('First Aid App - Testing'), findsOneWidget);
      expect(find.byKey(const Key('home_appbar')), findsOneWidget);
    });

    testWidgets('Verificar que todos los botones existen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('increment_button')), findsOneWidget);
      expect(find.byKey(const Key('decrement_button')), findsOneWidget);
      expect(find.byKey(const Key('reset_button')), findsOneWidget);
    });

    testWidgets('El contador puede volverse negativo', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Empezar en 0 y decrementar
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pumpAndSettle();
      
      expect(find.text('-1'), findsOneWidget);

      // Decrementar de nuevo
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pumpAndSettle();
      
      expect(find.text('-2'), findsOneWidget);
    });
  });
}