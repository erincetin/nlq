import 'package:flutter/material.dart';

import '../constants.dart';

class DbDropdownButton extends StatefulWidget {
  const DbDropdownButton({super.key});

  @override
  State<DbDropdownButton> createState() => _DbDropdownButtonState();
}

class _DbDropdownButtonState extends State<DbDropdownButton> {
  String dropdownValue = databases.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Choose database"),
        const SizedBox(
          width: 50,
        ),
        SizedBox(
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
        ),
      ],
    );
  }
}