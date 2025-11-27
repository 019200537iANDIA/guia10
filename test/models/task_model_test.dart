import 'package:flutter_test/flutter_test.dart';
import 'package:first_aid_app/models/task_model.dart';

void main() {
  group('Task Model - Pruebas Unitarias', () {
    test('debería crear una tarea válida', () {
      final task = Task(
        title: 'Estudiar Flutter',
        description: 'Completar la guía 10 de pruebas',
        createdAt: DateTime.now(),
        userId: 'user123',
      );

      expect(task.title, 'Estudiar Flutter');
      expect(task.description, 'Completar la guía 10 de pruebas');
      expect(task.isCompleted, false);
      expect(task.userId, 'user123');
    });

    test('debería validar título correctamente', () {
      final validTask = Task(
        title: 'Tarea válida',
        description: 'Descripción válida',
        createdAt: DateTime.now(),
        userId: 'user123',
      );

      final invalidTask = Task(
        title: 'AB', // Muy corto
        description: 'Descripción válida',
        createdAt: DateTime.now(),
        userId: 'user123',
      );

      expect(validTask.isTitleValid(), true);
      expect(invalidTask.isTitleValid(), false);
    });

    test('debería validar descripción correctamente', () {
      final validTask = Task(
        title: 'Tarea',
        description: 'Descripción suficientemente larga',
        createdAt: DateTime.now(),
        userId: 'user123',
      );

      final invalidTask = Task(
        title: 'Tarea',
        description: 'Cor', // Muy corto
        createdAt: DateTime.now(),
        userId: 'user123',
      );

      expect(validTask.isDescriptionValid(), true);
      expect(invalidTask.isDescriptionValid(), false);
    });

    test('debería convertir a Map correctamente', () {
      final now = DateTime.now();
      final task = Task(
        title: 'Test',
        description: 'Test description',
        createdAt: now,
        userId: 'user123',
        isCompleted: true,
      );

      final map = task.toMap();

      expect(map['title'], 'Test');
      expect(map['description'], 'Test description');
      expect(map['isCompleted'], true);
      expect(map['userId'], 'user123');
      expect(map['createdAt'], now.millisecondsSinceEpoch);
    });

    test('debería crear desde Map correctamente', () {
      final now = DateTime.now();
      final map = {
        'title': 'Test',
        'description': 'Test description',
        'isCompleted': true,
        'createdAt': now.millisecondsSinceEpoch,
        'userId': 'user123',
      };

      final task = Task.fromMap(map, 'task123');

      expect(task.id, 'task123');
      expect(task.title, 'Test');
      expect(task.description, 'Test description');
      expect(task.isCompleted, true);
      expect(task.userId, 'user123');
    });

    test('copyWith debería actualizar solo campos especificados', () {
      final original = Task(
        title: 'Original',
        description: 'Original description',
        createdAt: DateTime.now(),
        userId: 'user123',
      );

      final updated = original.copyWith(
        title: 'Actualizado',
        isCompleted: true,
      );

      expect(updated.title, 'Actualizado');
      expect(updated.description, 'Original description');
      expect(updated.isCompleted, true);
      expect(updated.userId, 'user123');
    });
  });
}