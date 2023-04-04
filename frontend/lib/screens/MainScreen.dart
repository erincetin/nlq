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
  List<Map<String, dynamic>> demo1 = [
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
      "rengi": "demo1",
      "userID": "0",
      "userName": "ertuğrul",
      "password": "Esy",
      "lvl": "admin",
      "birimID": "1"
    }
  ];
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

  Future<void> getSqlQueryHandler() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(ApiUrl.getQuery),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'input': question,
          'data': dropdownValue,
          'server':
              Provider.of<connectionhandler>(context, listen: false).Server,
          'database':
              Provider.of<connectionhandler>(context, listen: false).Port,
          'username':
              Provider.of<connectionhandler>(context, listen: false).Username,
          'password':
              Provider.of<connectionhandler>(context, listen: false).Password
        }),
      );

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        queryResults.add(decoded!['query'].toString());
        queryData.add(decoded!['data']);
      }
    } catch (err) {
      //Cannot connect to the server
      setState(() => _isError = true);
      setState(() => queryResults.add(jsonEncode({
            'input': question,
            'data': dropdownValue,
            'server':
                Provider.of<connectionhandler>(context, listen: false).Server,
            'database':
                Provider.of<connectionhandler>(context, listen: false).Port,
            'username':
                Provider.of<connectionhandler>(context, listen: false).Username,
            'password':
                Provider.of<connectionhandler>(context, listen: false).Password
          })));
      setState(() =>
          queryData.isNotEmpty ? queryData.add(demo1) : queryData.add(demo2));
      print(err);
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
        title: const Text('Demo for nl2sql app'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              setState(() {
                queryResults = [];
                queryData = [];
              });
            },
            child: const Text('Refresh page'),
          ),
          SizedBox(
            width: 25,
          )
        ],
      ),
      drawer: SideBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            TextField(
              onChanged: questionTextChangeHandler,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Question",
                prefixIcon: Icon(Icons.search),
                hintText: "Enter your question",
              ),
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
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue.shade700),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: getSqlQueryHandler,
              child: const Text('Sql sorgu'),
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
