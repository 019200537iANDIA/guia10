import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_aid_app/models/task_model.dart';
import 'package:first_aid_app/widgets/task_card.dart';

void main() {
  group('TaskCard Widget Tests', () {
    late Task testTask;

    setUp(() {
      testTask = Task(
        id: 'test_123',
        title: 'Tarea de Prueba',
        description: 'Esta es una descripción de prueba',
        createdAt: DateTime.now(),
        userId: 'user_test',
        isCompleted: false,
      );
    });

    testWidgets('debería mostrar título y descripción de la tarea', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Verificar que se muestra el título
      expect(find.text('Tarea de Prueba'), findsOneWidget);
      
      // Verificar que se muestra la descripción
      expect(find.text('Esta es una descripción de prueba'), findsOneWidget);
    });

    testWidgets('debería mostrar checkbox sin marcar cuando isCompleted es false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Buscar el checkbox
      final checkbox = tester.widget<Checkbox>(
        find.byKey(Key('task_checkbox_${testTask.id}')),
      );

      expect(checkbox.value, false);
    });

    testWidgets('debería mostrar checkbox marcado cuando isCompleted es true', (tester) async {
      final completedTask = testTask.copyWith(isCompleted: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: completedTask),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(
        find.byKey(Key('task_checkbox_${completedTask.id}')),
      );

      expect(checkbox.value, true);
    });

    testWidgets('debería mostrar título tachado cuando isCompleted es true', (tester) async {
      final completedTask = testTask.copyWith(isCompleted: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: completedTask),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(
        find.byKey(Key('task_title_${completedTask.id}')),
      );

      expect(titleWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('debería llamar onToggle cuando se toca el checkbox', (tester) async {
      bool toggleCalled = false;
      bool? toggledValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: (value) {
                toggleCalled = true;
                toggledValue = value;
              },
            ),
          ),
        ),
      );

      // Tocar el checkbox
      await tester.tap(find.byKey(Key('task_checkbox_${testTask.id}')));
      await tester.pump();

      expect(toggleCalled, true);
      expect(toggledValue, true);
    });

    testWidgets('debería llamar onDelete cuando se toca el botón de eliminar', (tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );

      // Tocar el botón de eliminar
      await tester.tap(find.byKey(Key('task_delete_${testTask.id}')));
      await tester.pump();

      expect(deleteCalled, true);
    });

    testWidgets('debería llamar onTap cuando se toca la tarjeta', (tester) async {
      bool tapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onTap: () {
                tapCalled = true;
              },
            ),
          ),
        ),
      );

      // Tocar la tarjeta (ListTile)
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapCalled, true);
    });

    testWidgets('debería mostrar icono de eliminar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Verificar que existe el botón de eliminar con icono
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
}