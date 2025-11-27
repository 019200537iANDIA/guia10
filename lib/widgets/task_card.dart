import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ValueChanged<bool?>? onToggle;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('task_card_${task.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          key: Key('task_checkbox_${task.id}'),
          value: task.isCompleted,
          onChanged: onToggle,
        ),
        title: Text(
          task.title,
          key: Key('task_title_${task.id}'),
          style: TextStyle(
            decoration: task.isCompleted 
              ? TextDecoration.lineThrough 
              : TextDecoration.none,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          task.description,
          key: Key('task_description_${task.id}'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          key: Key('task_delete_${task.id}'),
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}