import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasks/models/todo_item.dart';
import 'package:tasks/models/todo_list_manager.dart';
import 'package:image_picker/image_picker.dart';

class InputTaskView extends StatefulWidget {
  const InputTaskView({Key? key}) : super(key: key);

  @override
  _InputTaskViewState createState() => _InputTaskViewState();
}

class _InputTaskViewState extends State<InputTaskView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late bool _done = false;
  DateTime? _selectedDate;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lisää uusi ostos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Otsikko',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Kuvaus',
              ),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Hankinta päivä (pp.kk.vvvv)',
              ),
              onTap: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _selectedDate = date;
                  _dateController.text = DateFormat('dd.MM.yyyy').format(date);
                }
              },
            ),
            const SizedBox(height: 16.0),
            CheckboxListTile(
              title: const Text('Valmis'),
              value: _done,
              onChanged: (bool? value) {
                setState(() {
                  _done = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectImage,
              child: const Text('Valitse kuva'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 16.0),
              Image.file(
                _selectedImage!,
                width: 50,
                height: 50,
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text;
                  final description = _descriptionController.text;
                  final date = _selectedDate;
                  final done = _done;
                  final image = _selectedImage;

                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      date != null) {
                    final todoItem = TodoItem(
                      title: title,
                      description: description,
                      date: date,
                      done: done,
                      image: image,
                    );
                    Provider.of<TodoListManager>(context, listen: false)
                        .add(todoItem);

                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Täytä kaikki kentät'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Lisää'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
