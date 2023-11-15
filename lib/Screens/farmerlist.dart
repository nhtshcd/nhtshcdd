import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Database/Model/FarmerMaster.dart';

class FarmerList extends StatefulWidget {
  @override
  _FarmerListTableState createState() => _FarmerListTableState();
}

class _FarmerListTableState extends State<FarmerList> {
  List<FarmerMaster> farmermaster = [];
  List<String> farmeritemscount = ['15'];
  String CatalogValue = '15';

  @override
  void initState() {
    print("farmermaster 1: ");
    GetFarmerdataDB();
    print("farmermaster 2: ");
    super.initState();
  }

  void GetFarmerdataDB() async {
    var db = DatabaseHelper();
    List<FarmerMaster> farmermaster1 = await db.GetFarmerdata();
    setState(() {
      farmermaster = farmermaster1;
      for (int i = 0; i < farmermaster.length; i++) {
        // print("exporter" + farmermaster[i].exporter.toString());
        print("fName" + farmermaster[i].fName.toString());
        print("farmerId" + farmermaster[i].farmerId.toString());
        print("villageId" + farmermaster[i].villageId.toString());
        print("status" + farmermaster[i].status.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Farmer List',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text('Show'),
                          padding:
                              const EdgeInsets.only(left: 0.0, right: 10.0),
                        ),
                        flex: 4,
                      ),
                      new Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: DropdownButton<String>(
                            value: CatalogValue,
                            isExpanded: false,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.green,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.green, fontSize: 14),
                            onChanged: (String? data) {
                              //int position = farmeritemscount.indexOf(data);
                              setState(() {
                                CatalogValue = data!;
                              });
                            },
                            items: getfarmeritemscount()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('entries'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: Colors.black,
              ),
              new Expanded(
                  flex: 9,
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(children: <Widget>[
                        new Expanded(
                          child: _getBodyWidget(),
                          flex: 7,
                        ),
                      ]))),
            ],
          ),
        ));
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 50,
        rightHandSideColumnWidth: 520,
        headerWidgets: _getTitleWidget(),
        isFixedHeader: true,
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: _getfarmercount(),
      ),
    );
  }

  int _getfarmercount() {
    if (int.parse(CatalogValue) > farmermaster.length) {
      return farmermaster.length;
    } else {
      return int.parse(CatalogValue);
    }
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('S.No', 50),
      _getDivider(),
      _getTitleItemWidget('Village', 150),
      _getDivider(),
      _getTitleItemWidget('Farmer Name', 150),
      _getDivider(),
      _getTitleItemWidget('Farmer Id', 150),
      _getDivider(),
    ];
  }

  Widget _getDivider() {
    return Container(
      height: 40,
      child: VerticalDivider(
        color: Colors.black,
      ),
    );
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Colors.green)),
      width: width,
      height: 40,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  /* Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }*/

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    int sno = index + 1;
    return Container(
      child: Text(
        '$sno',
        style: TextStyle(fontSize: 15.0),
      ),
      width: 70,
      height: 40,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  List<String> getfarmeritemscount() {
    List<String> farmercount = ['15'];
    if (farmermaster.length > 0) {
      if (farmermaster.length > 0 && farmermaster.length < 15) {
        farmercount = ['15'];
      } else if (farmermaster.length > 15 && farmermaster.length <= 25) {
        farmercount = ['15', '25'];
      } else if (farmermaster.length > 25 && farmermaster.length <= 50) {
        farmercount = ['15', '25', '50'];
      } else {
        farmercount = ['15', '25', '50', '100'];
      }
    }
    return farmercount;
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            _getDivider(),
            Container(
              child: Text(
                farmermaster.elementAt(index).villageName!,
                style: TextStyle(fontSize: 15.0),
              ),
              width: 150,
              height: 40,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
            _getDivider(),
            Container(
              child: Text(
                farmermaster.elementAt(index).fName!,
                style: TextStyle(fontSize: 15.0),
              ),
              width: 150,
              height: 40,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
            _getDivider(),
            Container(
              child: Text(
                farmermaster.elementAt(index).farmerId!,
                style: TextStyle(fontSize: 15.0),
              ),
              width: 150,
              height: 40,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
            _getDivider(),
          ],
        ),
        Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 1.0,
        ),
      ],
    );
  }
}
