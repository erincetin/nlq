import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<List<String>>? stringlist;
  Future gettable(String sql) async {
    List<List<String>> ite = [];
    List<String> neww = [];
    List<String> newww = [];
    var datajson = [
      {
        "userID": 0,
        "userName": "celal",
        "password": "Esyc.8363",
        "lvl": "admin",
        "birimID": 1
      },
      {
        "userID": 1,
        "userName": "yaren",
        "password": "1234",
        "lvl": "admin",
        "birimID": 3
      },
      {
        "userID": 2,
        "userName": "songül",
        "password": "1234",
        "lvl": "kullanıcı",
        "birimID": 3
      },
      {
        "userID": 3,
        "userName": "ertuğrul",
        "password": "1234",
        "lvl": "kullanıcı",
        "birimID": 3
      }
    ];
    for (int j = 0; j < datajson[0].length; j++) {
      newww[j] = datajson[0].keys.toList()[j].toString();
    }
    ite.add(newww);
    for (int i = 0; i < datajson.length; i++) {
      Map<String, dynamic> map = datajson[i];
      for (int j = 0; j < map.length; j++) {
        neww[j] = map[j].toString();
      }
      ite.add(neww);
    }
    setState(() {
      for (int j = 0; j < ite.length; j++) {
        for (int i = 0; i < ite[0].length; i++) {
          stringlist?[i].add(ite[i][j]);
        }
      }
    });
  }

  @override
  void initState() {
    stringlist = [];
    super.initState();
    gettable("slm");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 100,
              rightHandSideColumnWidth: 600,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder: _generateRightHandSideColumnRow,
              itemCount: stringlist!.length,
              rowSeparatorWidget: const Divider(
                color: Colors.black54,
                height: 1.0,
                thickness: 0.0,
              ),
              leftHandSideColBackgroundColor: Colors.white,
              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
            ),
            height: MediaQuery.of(context).size.height - 300,
          ),
        ],
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      for (int i = 0; i < stringlist![0].length; i++)
        _getTitleItemWidget(stringlist![0][i], 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return FlatButton(
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(stringlist![index][0],
              style: TextStyle(fontSize: 13.0), textAlign: TextAlign.center)),
      height: 52,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      onPressed: () {},
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < stringlist![0].length; i++)
          Container(
            child: Text(stringlist![index][i]),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          )
      ],
    );
  }
}
