import 'package:flutter/material.dart';

class connectionhandler with ChangeNotifier {
  List<String> Collect = <String>[
    'Default',
  ];
  String dataname = 'default';
  String Server = 'default';
  String Port = 'default';
  String Username = 'default';
  String Password = 'default';
  String Collection = 'default';
  String type = 'default';
  void change_collect(List<String> result) {
    for (int j = 0; j < result.length; j++) {
      this.Collect.add(result[j]);
    }
  }

  void Set_Connection_datas(String dataname, String Server, String Port,
      String Username, String Password) {
    this.dataname = dataname;
    this.Password = Password;
    this.Username = Username;
    this.Port = Port;
    this.Server = Server;
    notifyListeners();
  }

  void Set_Collection(String collec) {
    this.Collection = collec;
  }

  void Set_type(String type) {
    this.type = type;
  }
}
