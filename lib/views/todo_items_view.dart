import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/models/todo_list_manager.dart';
import 'package:tasks/models/todo_item.dart';
import 'package:path/path.dart';
import 'input_task_view.dart';
import 'package:image_picker/image_picker.dart';

class TodoItemsListView extends StatelessWidget {
  const TodoItemsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listManager = Provider.of<TodoListManager>(context, listen: false);

    return Consumer<TodoListManager>(builder: (context, listManager, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kauppalista'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Lisää tehtävä',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputTaskView(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.info),
              tooltip: 'info',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InfoScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: listManager.items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = listManager.items[index];
            return _buildTodoCard(
              context,
              item,
              () => listManager.deleteItem(item),
            );
          },
        ),
      );
    });
  }

  Future<void> _pickImage(TodoItem item) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      item.setImage(File(pickedImage.path));
    }
  }

  Center _buildTodoCard(
      BuildContext context, TodoItem item, VoidCallback onDelete) {
    final title = item.title;
    final description = item.description;
    final date = item.date;
    final done = item.done;
    final image = item.image;
    final formattedDate =
        date != null ? DateFormat('dd.MM.yyyy').format(date) : '';

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.done,
                    color: done ? Colors.green : Colors.grey,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: onDelete,
                  ),
                ],
              ),
              leading: image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(image),
                    )
                  : null,
              onTap: () => _pickImage(item),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  Text(description),
                  Text(formattedDate),
                ],
              ),
            ),
            // if (image != null) ...[
            //   SizedBox(
            //     width: double.infinity,
            //     child: Image.file(image),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: const Center(
        child: Text(
            'Tämä on kauppalista sovellus. Pääset lisäämään ostoksesi etusivulla olevan + painikkeen kautta, jossa pääset syöttämään ostoksen nimen ja tarvittaessa lisäämään lisätietoja muun muassa kuvan. Sovellusta voi käyttää myös näyttö poikittais suunnassa. '),
      ),
    );
  }
}
