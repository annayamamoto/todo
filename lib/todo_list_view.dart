import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoListView extends HookWidget {
  TodoListView({
    super.key,
  });

  final List<String> _todoList = [
    '今日やること1',
    '今日やること2',
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
  ];

  @override
  Widget build(BuildContext context) {
    // 各Todo項目のチェックボックスの状態を保存するためのリストを作成
    final todoCheckedStates = List.generate(
      _todoList.length,
      (index) => useState(false),
    );
    return Center(
      child: SingleChildScrollView(
        child: Column(
            children: _todoList.asMap().entries.map((e) {
          // .asMap()で、_todoListの各項目とそのインデックスを取得
          final index = e.key;
          final todo = e.value;
          return Card(
            color: Colors.deepPurple[50],
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 8,
            shadowColor: Colors.deepPurple,
            child: Column(
              children: <Widget>[
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(todo),
                  value: todoCheckedStates[index].value, // 現在のチェックボックスの状態
                  onChanged: (newValue) {
                    // チェックボックスがタップされたときの動作
                    todoCheckedStates[index].value = newValue!;
                  },
                ),
              ],
            ),
          );
        }).toList()),
      ),
    );
  }
}
