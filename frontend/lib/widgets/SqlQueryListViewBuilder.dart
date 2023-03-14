import 'package:flutter/material.dart';

import '../screens/DataScreen.dart';

class SqlQueryListViewBuilder extends StatelessWidget {
  final List<String> queries;
  final List<Map<String, dynamic>> data;

  const SqlQueryListViewBuilder({Key? key, required this.queries, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: List.generate(
        queries.length,
            (index) => Row(
          children: [
            Expanded(
              child: Container(
                child: ListTile(
                  title: Text(queries[index]),
                ),
                width: 800,
              ),
            ),
            Expanded(
              child: Container(
                width: 200,
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DataPage(sqlData: data)),
                    );
                  },
                  child: const Text('Show data'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
