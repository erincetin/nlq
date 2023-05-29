import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/DatabaseConnectionScreen.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade800, Colors.black],
              begin: Alignment.center,
              end: Alignment.bottomCenter),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 270,
              child: DrawerHeader(
                child: Text(
                  '',
                  style: TextStyle(color: Colors.black, fontSize: 23),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  border: Border.symmetric(),
                  image: DecorationImage(
                      image: AssetImage("assets/images/bitirme logo.PNG")),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                ),
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Database'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DatabaseConnectionScreen(),
                    ))
              },
            ),
          ],
        ),
      ),
    );
  }
}
