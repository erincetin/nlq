import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Classes/connectionhandler.dart';
import 'package:frontend/apiUrls.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../screens/DataScreen.dart';

class SqlQueryListViewBuilder extends StatefulWidget {
  final List<String> queries;
  final List<List<Map<String, dynamic>>> data;
  final bool isLoading;

  const SqlQueryListViewBuilder(
      {Key? key,
      required this.queries,
      required this.data,
      required this.isLoading})
      : super(key: key);

  @override
  State<SqlQueryListViewBuilder> createState() =>
      _SqlQueryListViewBuilderState();
}

class _SqlQueryListViewBuilderState extends State<SqlQueryListViewBuilder> {
  late List<Map<String, dynamic>> demo1 = [];
  Map<String, dynamic> decoded = {};
  bool _isLoading = false;
  List<Map<String, dynamic>> demo2 = [
    {
      "rengi": "beyaz",
      "userID": "0",
      "userName": "celal",
      "password": "Esyc",
      "lvl": "admin",
      "birimID": "1"
    },
    {
      "rengi": "beyaz",
      "userID": "0",
      "userName": "songül",
      "password": "Esyc",
      "lvl": "admin",
      "birimID": "1"
    },
    {
      "rengi": "beyaz",
      "userID": "0",
      "userName": "ertuğrul",
      "password": "Esy",
      "lvl": "admin",
      "birimID": "1"
    },
    {
      "rengi": "demo2",
      "userID": "0",
      "userName": "ertuğrul",
      "password": "Esy",
      "lvl": "admin",
      "birimID": "1"
    }
  ];
  Future<void> getdataHandler_(String sql) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(ApiUrl.getData),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'query': sql,
            'hostname': Provider.of<connectionhandler>(context, listen: false)
                    .Server
                    .toString() +
                ':' +
                Provider.of<connectionhandler>(context, listen: false)
                    .Port
                    .toString(),
            'username':
                Provider.of<connectionhandler>(context, listen: false).Username,
            'password':
                Provider.of<connectionhandler>(context, listen: false).Password,
            'database':
                Provider.of<connectionhandler>(context, listen: false).dataname,
            'database_type':
                Provider.of<connectionhandler>(context, listen: false).type,
            'collection': Provider.of<connectionhandler>(context, listen: false)
                .Collection,
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        if (decoded!["success"] == true) {
          for (int j = 0; j < decoded!["result"].length; j++) {
            Map<String, dynamic> tmp = {};
            for (int i = 0; i < decoded!["columns"].length; i++) {
              tmp.addAll({decoded!["columns"][i]: decoded!["data"][j][i]});
            }
            setState(() {
              demo1.add(tmp);
            });
          }
        } else {
          demo1 = demo2;
        }
      }
    } catch (err) {
      //Cannot connect to the server

      print(err);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getnosqldataHandler_(String sql) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(ApiUrl.getnosqlData),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'query': sql,
            'hostname': Provider.of<connectionhandler>(context, listen: false)
                    .Server
                    .toString() +
                ':' +
                Provider.of<connectionhandler>(context, listen: false)
                    .Port
                    .toString(),
            'username':
                Provider.of<connectionhandler>(context, listen: false).Username,
            'password':
                Provider.of<connectionhandler>(context, listen: false).Password,
            'database':
                Provider.of<connectionhandler>(context, listen: false).dataname,
            'database_type':
                Provider.of<connectionhandler>(context, listen: false).type,
            'collection': Provider.of<connectionhandler>(context, listen: false)
                .Collection,
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body.replaceAll('NaN', '\"NaN\"'));
        if (decoded!["success"] == true) {
          for (int j = 0; j < decoded!["result"].length; j++) {
            Map<String, dynamic> tmp = {};

            tmp.addAll(decoded!["result"][j]);
            setState(() => demo1.add(tmp));
          }
        } else {
          demo1 = demo2;
        }
      }
    } catch (err) {
      //Cannot connect to the server

      print(err);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          !widget.isLoading
              ? SizedBox.shrink()
              : Container(
                  width: 30,
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                ),
          ...widget.queries.reversed.toList().mapIndexed((i, query) {
            int l = widget.queries.length;
            TextEditingController controller = TextEditingController();
            return Row(
              children: [
                Expanded(
                  child: Container(
                    child: ListTile(
                      title: TextField(
                        maxLines: null,
                        controller: controller
                          ..text = query.replaceAll('\\n', '\n'),
                        onChanged: (text) => {
                          widget.queries[l - i - 1] = controller.text.toString()
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
                            widget.data.remove(widget.data[l - i - 1]);
                            widget.queries.remove(widget.queries[l - i - 1]);
                          });
                        },
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          Provider.of<connectionhandler>(context, listen: false)
                                      .type ==
                                  'mongodb'
                              ? await getdataHandler_(
                                  widget.queries[l - i - 1].toString())
                              : await getdataHandler_(
                                  widget.queries[l - i - 1].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataPage(
                                      sqlData:
                                          demo1.length == 0 ? demo2 : demo1,
                                      sql_querry:
                                          widget.queries[l - i - 1].toString(),
                                    )),
                          );
                        },
                        child: const Text('Show data'),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
