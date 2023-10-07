import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoListView extends HookWidget {
  const TodoListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AnimatedListState> listKey = useMemoized(() => GlobalKey());
    final todoList = useState<List<String>>([
      '今日やること1',
      '今日やること2',
      '今日やること3',
      '今日やること4',
      '今日やること5',
      '今日やること6',
      '今日やること7',
      '今日やること8',
      '今日やること9',
      '今日やること10',
      '今日やること11',
      '今日やること12',
    ]);
    // 各Todo項目のチェックボックスの状態
    final todoCheckedStates = useState<List<bool>>(
        List.generate(todoList.value.length, (index) => (false)));

    void removeTodoAt(int index) {
      String removedItem = todoList.value[index];
      bool isChecked = todoCheckedStates.value[index];
      listKey.currentState!.removeItem(
        index,
        (context, animation) =>
            _buildRemovedItem(removedItem, isChecked, context, animation),
        duration: const Duration(milliseconds: 300),
      );

      todoList.value = List.of(todoList.value)..removeAt(index);
      todoCheckedStates.value = List.of(todoCheckedStates.value)
        ..removeAt(index);
    }

    return AnimatedList(
        key: listKey,
        initialItemCount: todoList.value.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(
                Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut))),
            child: Card(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  todoList.value[index],
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
                        removeTodoAt(index);
                      }
                    });
                  }
                },
              ),
            ),
          );
        });
  }
}

Widget _buildRemovedItem(String item, bool isChecked, BuildContext context,
    Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            item,
            style: isChecked
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          value: isChecked,
          onChanged: null,
        ),
      ),
    ),
  );
}
