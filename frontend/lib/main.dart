import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'SetDatabase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Demo for nl2sql app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  static List<String>? ornek;
  TextEditingController question = TextEditingController();
  Future createsql(String question) async {
    final response = await http.post(
      Uri.parse('http://46.101.100.15/question'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'question': question,
      }),
    );
    if (response != null) {
      Timer(const Duration(seconds: 3), () => showAlertDialog(context));
      Timer(
          const Duration(seconds: 3),
          () => setState(() {
                _isLoading = false;
              }));
    }
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      ornek!.add(response.toString());
      setState(() {
        _isLoading = true;
      });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create sql.');
    }
  }

  @override
  void initState() {
    ornek = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: kullanici(),
      body: Column(
        children: [
          Container(
            color: Colors.green.shade100,
            height: 10,
          ),
          TextField(
            controller: question,
            style: TextStyle(fontSize: 18),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Question",
                prefixIcon: Icon(Icons.search),
                hintText: "Enter your question"),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              createsql(question.toString());
            },
            child: Text('Sql sorgu'),
          ),
          if (_isLoading == false)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: new List.generate(
                  ornek!.length,
                  (index) => Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListTile(
                            title: Text(ornek![index]),
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
                            onPressed: () {},
                            child: Text('Show data'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                ),
                Container(child: CircularProgressIndicator()),
              ],
            ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        exitCode;
        exitCode;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Connection failed on main server"),
      content: Text("Try again later"),
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

class kullanici extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal, Colors.teal.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.teal.shade300],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Welcome'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('DATABASE'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const database()),
                )
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}
