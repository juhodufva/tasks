import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasks/models/todo_list_manager.dart';

import '../models/todo_item.dart';
import 'input_task_view.dart';

class TodoItemsListView extends StatelessWidget {
  TodoItemsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TodoItem> itemList = [];

    Widget todoItemsBuilder = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTodoCard('Ensimmäinen', 'Tehtävän selitys',
            DateTime.parse('2023-03-23'), false),
        _buildTodoCard(
            'Toinen', 'Tehtävän selitys', DateTime.parse('2023-03-23'), false),
      ],
    );
    return Consumer<TodoListManager>(builder: (context, listManager, child) {
      itemList.forEach((item) {
        listManager.add(item);
      });
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tehtävälista'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Lisää tehtävä',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InputTaskView()));
              },
            ),
            IconButton(
                icon: const Icon(Icons.info),
                tooltip: 'info',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InputTaskView()));
                })
          ],
        ),
        body: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _buildTodoCard(
                listManager.items[index].title,
                listManager.items[index].description,
                listManager.items[index].date,
                listManager.items[index].done);
          },
        ),
      );
    });
  }

  Center _buildTodoCard(
      String? title, String? description, DateTime? date, bool? done) {
    title ??= "";
    description ??= "";
    String formattedDate = "";
    done ??= false;
    if (date != null) {
      formattedDate = DateFormat('dd.MM.yyyy').format(date);
    }

    return Center(
        child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              trailing:
                  Icon(Icons.done, color: done ? Colors.green : Colors.grey),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(title), Text(formattedDate)],
              ))
        ],
      ),
    ));
  }
}
