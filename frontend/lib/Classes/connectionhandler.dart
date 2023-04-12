import 'package:flutter/material.dart';

class connectionhandler with ChangeNotifier {
  String Server = 'default';
  String Port = 'default';
  String Username = 'default';
  String Password = 'default';
  void Set_Connection_datas(
      String Server, String Port, String Username, String Password) {
    this.Password = Password;
    this.Username = Username;
    this.Port = Port;
    this.Password = Password;
    notifyListeners();
  }
}
