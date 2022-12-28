import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/data.dart';

import 'SetDatabase.dart';

void main() {
  runApp(const MyApp());
}

const List<String> databases = <String>['company', 'movies'];

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
  String example = "slm";
  String dropdownValue = "";
  Map<String, dynamic>? decoded;
  String Databaseinfo =
      " | concert_singer | stadium : stadium_id, location, name, capacity, highest, lowest, average | singer : singer_id, name, country, song_name, song_release_year, age, is_male | concert : concert_id, concert_name, theme, stadium_id, year | singer_in_concert : concert_id, singer_id";
  static List<String>? ornek;
  TextEditingController question = TextEditingController();
  List<Map<String, dynamic>> datajson = [];
  Future createsql(String question) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/get-sql-query'),
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
    if (response != null) {
      Timer(
          const Duration(seconds: 3),
          () => setState(() {
                _isLoading = false;
              }));
    }
    if (response.statusCode == 200) {
      decoded = jsonDecode(response.body);
      ornek!.add(decoded!['query'].toString());
      datajson = decoded!['data'];
      setState(() {
        _isLoading = true;
      });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Timer(const Duration(seconds: 3), () => showAlertDialog(context));
      ornek!.add(example);
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
          Row(
            children: [
              Text("Choose database"),
              SizedBox(
                width: 50,
              ),
              DropdownButton1(),
            ],
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DataPage(datajson: datajson)),
                              );
                            },
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
              colors: [Colors.green.shade500, Colors.green.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'HELLO',
                style: TextStyle(color: Colors.black, fontSize: 23),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green, Colors.green.shade700],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                )
              },
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

class DropdownButton1 extends StatefulWidget {
  const DropdownButton1({super.key});

  @override
  State<DropdownButton1> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton1> {
  String dropdownValue = databases.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: databases.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
