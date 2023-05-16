import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Classes/connectionhandler.dart';
import 'package:frontend/apiUrls.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/widgets/SideBar.dart';
import 'package:frontend/widgets/SqlQueryListViewBuilder.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> demo1 = [];
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
  String admin_question = 'default';
  String link = 'default';
  String database_format = 'default';
  bool _isLoading = false;
  bool _isError = false;

  static String dropdownValue = 'ORACLE';
  Map<String, dynamic>? decoded;

  static List<String> queryResults = [];
  String question = "";
  List<List<Map<String, dynamic>>> queryData = [];

  void questionTextChangeHandler(String input) {
    setState(() {
      question = input;
    });
  }

  void linkTextChangeHandler(String input) {
    setState(() {
      link = input;
    });
  }

  void admin_questionTextChangeHandler(String input) {
    setState(() {
      admin_question = input;
    });
  }

  void database_formatTextChangeHandler(String input) {
    setState(() {
      database_format = input;
    });
  }

  Future<void> getdataHandler(String sql) async {
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
            'database_type': "postgresql",
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        if (decoded!["success"] == true) {
          for (int j = 0; j < decoded!["data"].length; j++) {
            Map<String, dynamic> tmp = {};
            for (int i = 0; i < decoded!["columns"].length; i++) {
              tmp.addAll({decoded!["columns"][i]: decoded!["data"][j][i]});
            }
            demo1.add(tmp);
          }
          setState(() => queryData.add(demo1));
        } else {
          queryData.add(demo1);
        }
      }
    } catch (err) {
      //Cannot connect to the server
      setState(() => queryData.add(demo2));
      print(err);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getSqlQueryHandler() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    http.Response response;
    try {
      response = await http.post(Uri.parse(ApiUrl.getQuery),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'input': question,
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
            'database_type': "postgresql",
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        setState(() => queryResults.add(decoded!["query"].toString()));
        getdataHandler(decoded!["query"].toString());
      }
    } catch (err) {
      //Cannot connect to the server
      setState(() => _isError = true);
      setState(() => queryResults.add(err.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Demo for nl2sql app'),
        actions: <Widget>[
          TextButton(
            autofocus: true,
            focusNode: FocusNode(),
            style: TextButton.styleFrom(
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isError = false;
                queryResults = [];
                queryData = [];
              });
            },
            child: const Text('Refresh page'),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: SideBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            TextField(
              autocorrect: true,
              onChanged: questionTextChangeHandler,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Question",
                prefixIcon: Icon(Icons.search),
                hintText: "Enter your question",
              ),
            ),
            question == 'admin'
                ? Column(
                    children: [
                      TextField(
                        onChanged: admin_questionTextChangeHandler,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Admin question",
                          prefixIcon: Icon(Icons.search),
                          hintText: "question(.......)",
                        ),
                      ),
                      TextField(
                        onChanged: linkTextChangeHandler,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ML MODEL",
                          prefixIcon: Icon(Icons.search),
                          hintText: "Link of model(.......)",
                        ),
                      ),
                      TextField(
                        onChanged: database_formatTextChangeHandler,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Database format",
                          prefixIcon: Icon(Icons.search),
                          hintText: "format of database(.......)",
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 5,
                  ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[100]!,
                      border: Border.all(
                        color: Colors.blue[400]!,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    "Choose database",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        background: Paint()
                          ..strokeWidth = 25.0
                          ..color = Colors.transparent
                          ..style = PaintingStyle.fill
                          ..strokeJoin = StrokeJoin.round),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.blue[200]!,
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 8,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: databases
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 500,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue.shade700),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: getSqlQueryHandler,
                  child: const Text('Sql sorgu'),
                ),
                SizedBox(
                  width: 300,
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      _isError = false;
                      queryResults = [];
                      queryData = [];
                    });
                  },
                  child: const Text('Clear All'),
                )
              ],
            ),
            _isError
                ? const Text("Connection refused, check your connection")
                : const SizedBox.shrink(),
            !_isLoading
                ? Expanded(
                    child: SqlQueryListViewBuilder(
                      queries: queryResults,
                      data: queryData,
                    ),
                  )
                : const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
