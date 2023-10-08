import 'package:flutter/material.dart';

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget({
    super.key,
    required this.todoCheckedStates,
    required this.todoText,
    required this.index,
    required this.removeTodo,
  });

  final ValueNotifier<List<bool>> todoCheckedStates;
  final String todoText;
  final int index;
  final Function(int) removeTodo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          todoText,
          style: todoCheckedStates.value[index]
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        value: todoCheckedStates.value[index],
        onChanged: (newValue) {
          todoCheckedStates.value = List.of(todoCheckedStates.value)
            ..[index] = newValue!;

          if (newValue) {
            // 1秒後に削除
            Future.delayed(const Duration(milliseconds: 600), () {
              if (todoCheckedStates.value[index]) {
                removeTodo(index);
              }
            });
          }
        },
      ),
    );
  }
}
