import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/Classes/connectionhandler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../apiUrls.dart';

class DatabaseConnectionScreen extends StatefulWidget {
  @override
  State<DatabaseConnectionScreen> createState() =>
      _DatabaseConnectionScreenState();
}

class _DatabaseConnectionScreenState extends State<DatabaseConnectionScreen> {
  bool _passwordVisible = false;
  Map<String, dynamic>? decoded;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Future<void> getCollectionList() async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(ApiUrl.getcollection),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
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
            'database_type': "mongodb"
          }));

      if (response.statusCode == 200) {
        decoded = jsonDecode(response.body);
        if (decoded!["success"] == true) {
          Provider.of<connectionhandler>(context, listen: false)
              .change_collect(decoded!["result"]);
        } else {}
      }
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController connName = TextEditingController();
    TextEditingController hostname = TextEditingController();
    TextEditingController port = TextEditingController();
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Database Connection Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              width: 200,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Set up new connection",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: connName,
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of database",
                    prefixIcon: Icon(Icons.info),
                    hintText: "Enter new database name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: hostname,
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of host",
                    prefixIcon: Icon(Icons.info),
                    hintText: "Enter new host name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: port,
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Port",
                    prefixIcon: Icon(Icons.info),
                    hintText: "Enter your Port"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: username,
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    prefixIcon: Icon(Icons.info),
                    hintText: "Enter your username"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: password,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.info),
                  hintText: 'Enter your password',
                  // Here is key idea
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  connName.text = 'testdb';
                  hostname.text = '209.38.241.139';
                  port.text = '5432';
                  username.text = 'testuser';
                  password.text = 'test123';
                },
                child: const Text('for demo'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Provider.of<connectionhandler>(context, listen: false)
                    .Set_Connection_datas(
                        connName.text.toString(),
                        hostname.text.toString(),
                        port.text.toString(),
                        username.text.toString(),
                        password.text.toString());
                getCollectionList();
                showAlertDialog(context);
              },
              child: const Text('Save database'),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Database information is saved"),
      content: Text("You can ask your questions."),
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
