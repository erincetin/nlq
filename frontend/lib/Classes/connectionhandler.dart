import 'package:flutter/material.dart';

class connectionhandler with ChangeNotifier {
  String dataname = 'default';
  String Server = 'default';
  String Port = 'default';
  String Username = 'default';
  String Password = 'default';

  void Set_Connection_datas(String dataname, String Server, String Port,
      String Username, String Password) {
    this.dataname = dataname;
    this.Password = Password;
    this.Username = Username;
    this.Port = Port;
    this.Server = Server;
    notifyListeners();
  }
}
