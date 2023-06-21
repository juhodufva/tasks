import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tasks/models/todo_item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class InputTaskView extends StatefulWidget {
  const InputTaskView({super.key});

  @override
  State<InputTaskView> createState() => InputStateView();
}

class InputStateView extends State<InputTaskView> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  bool? done = false;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lisää uusi tehtävä"),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Tehtävän nimi',
                      labelText: 'Tehtävän nimi',
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tehtävän nimi on pakollinen';
                      }
                      return null;
                    },
                  ),
                  _FormDatePicker(
                    date: date,
                    onChanged: (value) {
                      setState(() {
                        date = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tehtävän kuvaus',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    minLines: 5,
                    maxLines: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tallennettu')),
                        );
                      }
                    },
                    child: const Text('Tallenna'),
                  ),
                ],
              ))),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
