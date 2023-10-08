import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo/todo_list_view.dart';

class TabBarWidget extends HookWidget {
  TabBarWidget({super.key});

  /// タブ切り替え画面
  final List<Widget> tabList = [
    const Tab(child: Text('Todo')),
    const Tab(child: Text('Done')),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: tabList.length);
    return Column(
      children: [
        TabBar(
          tabs: tabList,
          controller: controller,
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: const [
              TodoListView(),
              Center(child: Text('Tab 2 View')),
            ],
          ),
        )
      ],
    );
  }
}
