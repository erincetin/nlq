import 'package:flutter/material.dart';

class database extends StatefulWidget {
  const database({Key? key}) : super(key: key);

  @override
  State<database> createState() => _databaseState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _databaseState extends State<database> {
  bool _passwordVisible = false;
  String dropdownValue = "";
  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameofconn = TextEditingController();
    TextEditingController hostname = TextEditingController();
    TextEditingController port = TextEditingController();
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Database Connection Page'),
      ),
      body: Column(
        children: [
          DropdownButton(),
          Container(
            color: Colors.green.shade100,
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Set up new connection",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextField(
            controller: nameofconn,
            style: TextStyle(fontSize: 18),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name of Connection",
                prefixIcon: Icon(Icons.info),
                hintText: "Enter new connection name"),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              SizedBox(
                width: 350,
                height: 100,
                child: TextField(
                  controller: hostname,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name of host",
                      prefixIcon: Icon(Icons.info),
                      hintText: "Enter new host name"),
                ),
              ),
              SizedBox(
                width: 150,
              ),
              SizedBox(
                width: 350,
                height: 100,
                child: TextField(
                  controller: port,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Port",
                      prefixIcon: Icon(Icons.info),
                      hintText: "Enter your Port"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 350,
                child: TextField(
                  controller: username,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      prefixIcon: Icon(Icons.info),
                      hintText: "Enter your username"),
                ),
              ),
              SizedBox(
                width: 150,
              ),
              SizedBox(
                  width: 350,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: password,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',

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
                  )),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {},
            child: Text('Connect database'),
          ),
        ],
      ),
    );
  }
}

class DropdownButton extends StatefulWidget {
  const DropdownButton({super.key});

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
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
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
