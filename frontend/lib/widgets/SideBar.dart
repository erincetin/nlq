import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/DatabaseConnectionScreen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

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
              child: const Text(
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
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('DATABASE'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DatabaseConnectionScreen()),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.border_color),
              title: const Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}