import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tasks/models/todo_list_manager.dart';
import 'package:tasks/views/globals.dart';
import 'package:tasks/views/todo_items_view.dart';
import 'package:provider/provider.dart';
import 'views/info_view.dart';
import 'views/input_task_View.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        var model = TodoListManager();
        model.init();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Tasklist';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: TodoItemsListView(),
    );
  }
}
