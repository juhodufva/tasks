import 'package:flutter/material.dart';

import 'input_task_View.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('Matematiikan tentti'),
              subtitle: Text('22.02.2023, luokkatila A1086'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('DONE'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('NOT DONE'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InputTaskView()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.done,
                ),
              ],
            ),
            Image.network(
              'https://cataas.com/cat/says/hello%20world!',
              width: 600,
              height: 240,
            )
          ],
        ),
      ),
    );
  }
}
