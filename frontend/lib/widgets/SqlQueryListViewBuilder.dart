import 'package:flutter/material.dart';

import '../screens/DataScreen.dart';

class SqlQueryListViewBuilder extends StatelessWidget {
  final List<String> queries;
  final List<List<Map<String, dynamic>>> data;

  const SqlQueryListViewBuilder(
      {Key? key, required this.queries, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controller_ = [
      for (int i = 1; i < 75; i++) TextEditingController()
    ];
    return ListView(
      padding: const EdgeInsets.all(8),
      children: List.generate(
        queries.length,
        (index) => Row(
          children: [
            Expanded(
              child: Container(
                child: ListTile(
                  title: TextField(
                    maxLines: null,
                    controller: controller_[queries.length - index - 1]
                      ..text = queries[queries.length - index - 1]
                          .replaceAll('\\n', '\n'),
                    onChanged: (text) => {
                      queries[queries.length - index - 1] =
                          controller_[queries.length - index - 1]
                              .text
                              .toString()
                    },
                  ),
                ),
                width: 1000,
              ),
            ),
            Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataPage(
                              sqlData: data[data.length - index - 1],
                              sql_querry: queries[queries.length - index - 1]
                                  .toString(),
                            )),
                  );
                },
                child: const Text('Show data'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
