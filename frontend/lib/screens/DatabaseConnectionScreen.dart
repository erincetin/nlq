import 'package:flutter/material.dart';

class DatabaseConnectionScreen extends StatefulWidget {
  const DatabaseConnectionScreen({Key? key}) : super(key: key);

  @override
  State<DatabaseConnectionScreen> createState() => _DatabaseConnectionScreenState();
}



class _DatabaseConnectionScreenState extends State<DatabaseConnectionScreen> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
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
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Set up new connection",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextField(
              controller: connName,
              style: const TextStyle(fontSize: 18),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name of Connection",
                  prefixIcon: Icon(Icons.info),
                  hintText: "Enter new connection name"),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                SizedBox(
                  width: 350,
                  height: 100,
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
                const SizedBox(
                  width: 150,
                ),
                SizedBox(
                  width: 350,
                  height: 100,
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
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 350,
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
                const SizedBox(
                  width: 150,
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: password,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
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
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {},
              child: const Text('Connect database'),
            ),
          ],
        ),
      ),
    );
  }
}