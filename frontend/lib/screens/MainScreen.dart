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
      "error": "error",
    }
  ];

  String link = 'default';
  String database_format = 'default';
  bool _isLoading = false;
  bool _isError = false;

  static String dropdownValue = 'Mysql';
  static String dropdownValue_collection = 'Default';
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

  void database_formatTextChangeHandler(String input) {
    setState(() {
      database_format = input;
    });
  }

  Future<void> getnosqldataHandler(String nosql) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(ApiUrl.getnosqlData),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'query': nosql,
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
            'database_type': dropdownValue.toLowerCase().toString(),
            'collection':
                Provider.of<connectionhandler>(context, listen: false).Collect
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body.replaceAll('NaN', '\"NaN\"'));
        if (decoded!["success"] == true) {
          for (int j = 0; j < decoded!["result"].length; j++) {
            Map<String, dynamic> tmp = {};

            tmp.addAll(decoded!["result"][j]);

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
            'database_type': dropdownValue.toLowerCase().toString(),
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        if (decoded!["success"] == true) {
          for (int j = 0; j < decoded!["query"].length; j++) {
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

  Future<void> getnoSqlQueryHandler() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    http.Response response;
    try {
      response = await http.post(Uri.parse(ApiUrl.getnosqlQuery),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'question': question,
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
            'database_type': dropdownValue.toLowerCase().toString(),
            'collection':
                Provider.of<connectionhandler>(context, listen: false).Collect
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        setState(() => queryResults.add(decoded!["query"].toString()));
        getnosqldataHandler(decoded!["query"].toString());
      }
    } catch (err) {
      //Cannot connect to the server
      setState(() => _isError = true);
      setState(() => queryResults.add(err.toString()));
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
      response = await http.post(Uri.parse(ApiUrl.getsqlQuery),
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
            'database_type': dropdownValue.toLowerCase().toString()
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('NLQ'),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              autocorrect: true,
              onChanged: (value) {
                questionTextChangeHandler(value);
              },
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Question",
                prefixIcon: Icon(Icons.search),
                hintText: "Enter your question",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.blue[100]!,
                      border: Border.all(
                        color: Colors.blue[400]!,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(22))),
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
                          Provider.of<connectionhandler>(context, listen: false)
                              .Set_type(dropdownValue.toLowerCase().toString());
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
                SizedBox(
                  width: 30,
                ),
                dropdownValue != "Mongodb"
                    ? SizedBox()
                    : Container(
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue[100]!,
                            border: Border.all(
                              color: Colors.blue[400]!,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          "Choose Collection",
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
                dropdownValue != "Mongodb"
                    ? SizedBox()
                    : SizedBox(
                        height: 45,
                        width: 150,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.blue[200]!,
                              borderRadius: BorderRadius.circular(20)),
                          child: DropdownButtonFormField<String>(
                            value: dropdownValue_collection,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 8,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? value) {},
                            items: Provider.of<connectionhandler>(this.context,
                                    listen: false)
                                .Collect
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
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade700),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      question == ''
                          ? showAlertDialog(context)
                          : dropdownValue.toLowerCase().toString() == 'mongodb'
                              ? getnoSqlQueryHandler()
                              : (getSqlQueryHandler());
                      Provider.of<connectionhandler>(context, listen: false)
                          .Set_Collection(Provider.of<connectionhandler>(
                                  context,
                                  listen: false)
                              .Collect
                              .toString());
                      Provider.of<connectionhandler>(context, listen: false)
                          .Set_type(dropdownValue.toLowerCase().toString());
                    },
                    child: const Text('Convert Query'),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight - Alignment(0.15, 0.15),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade700),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _isError = false;
                        queryResults = [];
                        queryData = [];
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ),
              ],
            ),
            _isError
                ? const Text("Connection refused, check your connection")
                : const SizedBox.shrink(),
            SqlQueryListViewBuilder(
              queries: queryResults,
              data: queryData,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Error"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Please ask your question"),
      content: Text("Question is empty"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
