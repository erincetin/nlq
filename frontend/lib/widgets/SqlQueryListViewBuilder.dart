import 'package:flutter/material.dart';

import '../screens/DataScreen.dart';

class SqlQueryListViewBuilder extends StatefulWidget {
  final List<String> queries;
  final List<List<Map<String, dynamic>>> data;

  const SqlQueryListViewBuilder(
      {Key? key, required this.queries, required this.data})
      : super(key: key);

  @override
  State<SqlQueryListViewBuilder> createState() =>
      _SqlQueryListViewBuilderState();
}

class _SqlQueryListViewBuilderState extends State<SqlQueryListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controller_ = [
      for (int i = 1; i < 75; i++) TextEditingController()
    ];
    return ListView(
      padding: const EdgeInsets.all(8),
      children: List.generate(
        widget.queries.length,
        (index) => Row(
          children: [
            Expanded(
              child: Container(
                child: ListTile(
                  title: TextField(
                    maxLines: null,
                    controller: controller_[widget.queries.length - index - 1]
                      ..text = widget.queries[widget.queries.length - index - 1]
                          .replaceAll('\\n', '\n'),
                    onChanged: (text) => {
                      widget.queries[widget.queries.length - index - 1] =
                          controller_[widget.queries.length - index - 1]
                              .text
                              .toString()
                    },
                  ),
                ),
                width: 1000,
              ),
            ),
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                verticalDirection: VerticalDirection.down,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.data.remove(
                            widget.data[widget.data.length - index - 1]);
                        widget.queries.remove(
                            widget.queries[widget.queries.length - index - 1]);
                      });
                    },
                    child: Icon(Icons.close, color: Colors.red),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataPage(
                                  sqlData: widget
                                      .data[widget.data.length - index - 1],
                                  sql_querry: widget.queries[
                                          widget.queries.length - index - 1]
                                      .toString(),
                                )),
                      );
                    },
                    child: const Text('Show data'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
