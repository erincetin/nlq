import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/apiUrls.dart';
import 'package:frontend/widgets/DbDropdownButton.dart';
import 'package:frontend/widgets/SideBar.dart';
import 'package:frontend/widgets/SqlQueryListViewBuilder.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = false;
  bool _isError = false;

  String dropdownValue = "";
  Map<String, dynamic>? decoded;

  static List<String> queryResults = [];
  String question = "";
  List<Map<String, dynamic>> queryData = [];

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
          "server": "46.101.100.15:5430",
          "database": "postgres",
          'username': 'root',
          'password': 'MetuNlqTe4m'
        }),
      );

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        queryResults.add(decoded!['query'].toString());
        queryData = decoded!['data'];

      }

    }
    catch(err){
      //Cannot connect to the server
      setState(() => _isError = true);
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
      ),
      drawer: const SideBar(),
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

            const DbDropdownButton(),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: getSqlQueryHandler,
              child: const Text('Sql sorgu'),
            ),
            _isError ? const Text("Connection refused, check your connection") : const SizedBox.shrink(),

            !_isLoading ?
            Expanded(
              child: SqlQueryListViewBuilder(queries: queryResults, data: queryData,),
            )
                :
            const SizedBox(
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
