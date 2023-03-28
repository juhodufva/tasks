import 'dart:collection';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:tasks/views/globals.dart';

import 'todo_item.dart';

class TodoListManager extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<TodoItem> _items = [];

  TodoListManager() {}

  Future<void> init() async {
    loadFromDb();
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<TodoItem> get items => UnmodifiableListView(_items);

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(TodoItem item) {
    log("Lisää uusi itemi");
    _items.add(item);
    dbHelper.insert(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void loadFromDb() async {
    final list = await dbHelper.queryAllRows();
    for (TodoItem item in list) {
      _items.add(item);
    }
    notifyListeners();
  }
}
