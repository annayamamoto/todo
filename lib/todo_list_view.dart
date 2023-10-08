import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo/Widget/todo_card_widget.dart';

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

    // todoタスクを削除する
    void removeTodoAt(int index) {
      String removedItem = todoList.value[index];
      bool isChecked = todoCheckedStates.value[index];
      // listKeyを使用してAnimatedListの状態にアクセスし、
      // removeItemメソッドを用いてアニメーションをつけてtodoタスクを削除する
      listKey.currentState!.removeItem(
        index,
        (context, animation) =>
            _buildRemovedItem(removedItem, isChecked, context, animation),
        // 削除のアニメーション時間
        duration: const Duration(milliseconds: 300),
      );

      // todoListとtodoCheckedStatesから削除したtodoタスクを取り除く
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
            child: TodoCardWidget(
              todoText: todoList.value[index],
              index: index,
              todoCheckedStates: todoCheckedStates,
              removeTodo: removeTodoAt,
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
