import 'dart:io';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:responsive_table/responsive_table.dart';

class DataPage extends StatefulWidget {
  final List<Map<String, dynamic>> sqlData;
  const DataPage({Key? key, required this.sqlData}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int? _total;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  var random = new Random();
  List<String> exell = [];

  List<Map<String, dynamic>> _generateData({int n: 100}) {
    List<Map<String, dynamic>> temps = [];
    var i = 0;

    print(i);
    // ignore: unused_local_variable
    for (var data in widget.sqlData) {
      temps.add(widget.sqlData[i]);
      i++;
    }
    return temps;
  }

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(n: random.nextInt(10000)));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _currentPerPage! > widget.sqlData.length
          ? _sourceFiltered.getRange(0, widget.sqlData.length).toList()
          : _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start: 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total! - start < _currentPerPage! ? _total! - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _sourcetoarray(List<Map<String, dynamic>> list) async {
    for (int i = 0; i < list[0].keys.toList().length; i++) {
      exell.add(list[0].keys.toList()[i]);
    }
    for (var data in list) {
      for (var sei in data.values.toList()) {
        exell.add(sei.toString());
      }
    }
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total! < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop!, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _total = widget.sqlData.length;
    super.initState();
    _headers = [];

    /// set headers
    for (int i = 0; i < widget.sqlData[0].keys.toList().length; i++) {
      _headers.add(DatatableHeader(
          text: widget.sqlData[0].keys.toList()[i].toString(),
          value: widget.sqlData[0].keys.toList()[i].toString(),
          show: true,
          sortable: true,
          textAlign: TextAlign.center));
    }

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DATA TABLE"),
        actions: [
          IconButton(
            onPressed: _initializeData,
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                maxHeight: 700,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  reponseScreenSizes: [ScreenSize.xs],
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter search term based on ' +
                                _searchKey!
                                    .replaceAll(new RegExp('[\\W_]+'), ' ')
                                    .toUpperCase(),
                            prefixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                }),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search), onPressed: () {})),
                        onSubmitted: (value) {
                          _filterData(value);
                        },
                      )),
                    if (!_isSearch)
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          })
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  autoHeight: false,
                  dropContainer: (data) {
                    return _DropDownContainer(data: data);
                  },
                  onChangedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onSubmittedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {
                    setState(() => _isLoading = true);

                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _sourceFiltered.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      } else {
                        _sourceFiltered.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                      var _rangeTop = _currentPerPage! < _sourceFiltered.length
                          ? _currentPerPage!
                          : _sourceFiltered.length;
                      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                      _searchKey = value;

                      _isLoading = false;
                    });
                  },
                  expanded: _expanded,
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                  footers: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        _sourcetoarray(_source);
                        main(exell);
                      },
                      child: Text('Export as excell'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Rows per page:"),
                    ),
                    if (_perPages.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<int>(
                          value: _currentPerPage,
                          items: _perPages
                              .map((e) => DropdownMenuItem<int>(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (dynamic value) {
                            setState(() {
                              _currentPerPage = value;
                              _currentPage = 1;
                              _resetData();
                            });
                          },
                          isExpanded: false,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      onPressed: _currentPage == 1
                          ? null
                          : () {
                              var _nextSet = _currentPage - _currentPerPage!;
                              setState(() {
                                _currentPage = _nextSet > 1 ? _nextSet : 1;
                                _resetData(start: _currentPage - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _currentPage + _currentPerPage! - 1 > _total!
                          ? null
                          : () {
                              var _nextSet = _currentPage + _currentPerPage!;

                              setState(() {
                                _currentPage = _nextSet < _total!
                                    ? _nextSet
                                    : _total! - _currentPerPage!;
                                _resetData(start: _nextSet - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    )
                  ],
                  headerDecoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  headerTextStyle: TextStyle(color: Colors.white),
                  rowTextStyle: TextStyle(color: Colors.black),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ])),
    );
  }

  void main(List<String> args) async {
    //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
    //var bytes = File(file).readAsBytesSync();
    var excel = Excel.createExcel();
    // or
    //var excel = Excel.decodeBytes(bytes);

    ///
    ///
    /// reading excel file values
    ///
    ///
    for (var table in excel.tables.keys) {
      print(table);
      print(excel.tables[table]!.maxCols);
      print(excel.tables[table]!.maxRows);
      for (var row in excel.tables[table]!.rows) {
        print("${row.map((e) => e?.value)}");
      }
    }

    ///
    /// Change sheet from rtl to ltr and vice-versa i.e. (right-to-left -> left-to-right and vice-versa)
    ///
    var sheet1rtl = excel['Sheet1'].isRTL;
    excel['Sheet1'].isRTL = false;
    print(
        'Sheet1: ((previous) isRTL: $sheet1rtl) ---> ((current) isRTL: ${excel['Sheet1'].isRTL})');

    var sheet2rtl = excel['Sheet2'].isRTL;
    excel['Sheet2'].isRTL = true;
    print(
        'Sheet2: ((previous) isRTL: $sheet2rtl) ---> ((current) isRTL: ${excel['Sheet2'].isRTL})');

    ///
    ///
    /// declaring a cellStyle object
    ///
    ///
    CellStyle cellStyle = CellStyle(
      bold: true,
      italic: true,
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
      rotation: 0,
    );

    var sheet = excel['mySheet'];

    var cell = sheet.cell(CellIndex.indexByString("A1"));
    cell.value = "Heya How are you I am fine ok goood night";
    cell.cellStyle = cellStyle;

    var cell2 = sheet.cell(CellIndex.indexByString("E5"));
    cell2.value = "Heya How night";
    cell2.cellStyle = cellStyle;

    /// printing cell-type
    print("CellType: " + cell.cellType.toString());

    ///
    ///
    /// Iterating and changing values to desired type
    ///
    ///
    for (int row = 0; row < sheet.maxRows; row++) {
      sheet.row(row).forEach((Data? cell1) {
        if (cell1 != null) {
          cell1.value = ' My custom Value ';
        }
      });
    }

    excel.rename("mySheet", "myRenamedNewSheet");

    var sheet1 = excel['Sheet1'];
    sheet1.cell(CellIndex.indexByString('A1')).value = 'Sheet1';

    /// fromSheet should exist in order to sucessfully copy the contents
    excel.copy('Sheet1', 'newlyCopied');

    var sheet2 = excel['newlyCopied'];
    sheet2.cell(CellIndex.indexByString('A1')).value = 'Newly Copied Sheet';

    /// renaming the sheet
    excel.rename('oldSheetName', 'newSheetName');

    /// deleting the sheet
    excel.delete('Sheet1');

    /// unlinking the sheet if any link function is used !!
    excel.unLink('sheet1');

    sheet = excel['sheet'];

    /// appending rows and checking the time complexity of it
    Stopwatch stopwatch = Stopwatch()..start();
    List<List<String>> list = [];
    List<String> list2 = [];
    for (int i = 0; i < widget.sqlData[0].keys.toList().length; i++) {
      list2.add(widget.sqlData[0].keys.toList()[i]);
    }
    list2 = [];
    for (var data in widget.sqlData) {
      for (var sei in data.values.toList()) {
        list2.add(sei.toString());
      }
      list2 = [];
      list.add(list2);
    }

    print('list creation executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    list.forEach((row) {
      sheet.appendRow(row);
    });
    print('appending executed in ${stopwatch.elapsed}');

    bool isSet = excel.setDefaultSheet(sheet.sheetName);
    // isSet is bool which tells that whether the setting of default sheet is successful or not.
    if (isSet) {
      print("${sheet.sheetName} is set to default sheet.");
    } else {
      print("Unable to set ${sheet.sheetName} to default sheet.");
    }

    var colIterableSheet = excel['ColumnIterables'];

    var colIterables = ['A', 'B', 'C', 'D', 'E'];
    int colIndex = 0;

    colIterables.forEach((colValue) {
      colIterableSheet.cell(CellIndex.indexByColumnRow(
        rowIndex: colIterableSheet.maxRows,
        columnIndex: colIndex,
      ))
        ..value = colValue;
    });

    // Saving the file

    String outputFile = Directory.current.path + "/r.xlsx";

    //stopwatch.reset();
    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      /// height: 100,
      child: Column(
        /// children: [
        ///   Expanded(
        ///       child: Container(
        ///     color: Colors.red,
        ///     height: 50,
        ///   )),
        /// ],
        children: _children,
      ),
    );
  }
}