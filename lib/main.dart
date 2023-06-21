import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:tasks/models/todo_item.dart';
import 'package:tasks/models/todo_list_manager.dart';
import 'package:tasks/views/globals.dart';
import 'package:tasks/views/todo_items_view.dart';
import 'package:provider/provider.dart';
import 'data/db_helper.dart';
import 'views/info_view.dart';
import 'views/input_task_View.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final databasePath = '$path/todo_list.db';

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        var model = TodoListManager();
        model.init();
        return model;
        var setPreferredOrientations = SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp, // Sallii pystysuuntaisen kääntymisen
          DeviceOrientation.landscapeLeft, // Sallii vasemmalle kääntymisen
          DeviceOrientation.landscapeRight, // Sallii oikealle kääntymisen
        ]);
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate: 'dd.MM.yyyy',
    };
    final id = await dbHelper.insert(row as TodoItem);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnDate: 'dd.MM.yyyy',
    };
    final rowsAffected = await dbHelper.update(row as TodoItem);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}
