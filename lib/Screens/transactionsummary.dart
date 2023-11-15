import 'package:flutter/material.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/summaryModel.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';

var db = DatabaseHelper();
List<TSummaryModel> tsummarylist = [];
List<TSummaryPendingModel> tsummarypendinglist = [];

var datas = new AppDatas();

class TransactionSummary extends StatefulWidget {
  @override
  _TransactionSummary createState() => _TransactionSummary();
}

class _TransactionSummary extends State<TransactionSummary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Transaction Summary',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "Summary",
                ),
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "Datewise",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SummaryTabBar(),
              DatewiseTabBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryTabBar extends StatefulWidget {
  _SummaryTabBar createState() => _SummaryTabBar();
}

class _SummaryTabBar extends State<SummaryTabBar> {
  bool pendingsummary = false;
  @override
  void initState() {
    super.initState();
    getvaluesfromdb();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: _getListings(
                context), // <<<<< Note this change for the return type
          ),
          flex: 8,
        ),
      ])),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(Container(
      padding: EdgeInsets.all(10.0),
      child: Row(children: <Widget>[
        Expanded(
          child: MaterialButton(
            color: Colors.red,
            child: new Text("All",
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () {
              tsummarylist.clear();
              getvaluesfromdb();

              setState(() {
                pendingsummary = false;
              });
            },
          ),
          flex: 1,
        ),
        VerticalDivider(
          width: 10.0,
        ),
        Expanded(
            child: MaterialButton(
              color: Colors.green,
              child: new Text("Pending",
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () {
                tsummarypendinglist.clear();
                getpendingtsfromdb();
                setState(() {
                  pendingsummary = true;
                });
              },
            ),
            flex: 1),
      ]),
    ));
    if (tsummarylist.length > 0 && !pendingsummary) {
      listings.add(transummarylist(tsummarylist));
    }
    if (tsummarypendinglist.length > 0 && pendingsummary) {
      listings.add(transummaryPendinglist(tsummarypendinglist));
    }
    listings.add(btn_dynamic(
        label: "OK",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () {
          Navigator.pop(context);
        }));

    return listings;
  }

  Future<void> getvaluesfromdb() async {
    String qry_translist =
        'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total FROM txn_summary_cnt GROUP BY txn_Code;';
    print('tsummarylist 1:  ' + qry_translist);
    List translist = await db.RawQuery(qry_translist);
    print('translist:  ' + translist.toString());
    tsummarylist.clear();

    for (int i = 0; i < translist.length; i++) {
      String txnCode = translist[i]["txn_Code"].toString();
      String txnSynched = translist[i]["isSynched"].toString();
      String pending = translist[i]["pending"].toString();
      String total = translist[i]["total"].toString();
      String txnname = "";
      if (txnCode == datas.txnScouting) {
        txnname = "Scouting";
      } else if (txnCode == datas.txn_spray) {
        txnname = "Spraying";
      } else if (txnCode == datas.txnFarmerRegistration) {
        txnname = "Farmer Registration";
      } else if (txnCode == datas.txnFarmRegistration) {
        txnname = "Farm Registration";
      } else if (txnCode == datas.txnPlanting) {
        txnname = "Planting";
      } else if (txnCode == datas.txnSitePreparation) {
        txnname = "Site Selection";
      } else if (txnCode == datas.txnLandPreparation) {
        txnname = "Land Preparation";
      } else if (txnCode == datas.txnHarvest) {
        txnname = "Harvest";
      } else if (txnCode == datas.txn_sorting) {
        txnname = "Sorting";
      } else if (txnCode == datas.txnIncomingShipment) {
        txnname = "Incoming Shipment";
      } else if (txnCode == datas.txnPacking) {
        txnname = "Packing Operations";
      } else if (txnCode == datas.txnShipment) {
        txnname = "Shipment";
      } else if (txnCode == datas.txn_changePassword) {
        txnname = "Change Password";
      } else if (txnCode == datas.txnBlockRegistration) {
        txnname = "Block Registration";
      }
      else if (txnCode == datas.txnProductTransfer) {
        txnname = "Product Transfer";
      }
      else if (txnCode == datas.txnProductReception) {
        txnname = "Product Reception";
      }

      var tsModel = new TSummaryModel(txnname, total, txnSynched, pending);
      setState(() {
        tsummarylist.add(tsModel);
      });
    }
    print("tsummarylist 3: " + tsummarylist.length.toString());

    /*  String qry_translist_pen = 'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total FROM txn_summary_cnt GROUP BY txn_Code;';
    print('tsummarylist 1:  ' + qry_translist_pen);
    List trans_penlist = await db.RawQuery(qry_translist_pen);
    print('tsummarylist 2:  ' + trans_penlist.toString());
    tsummarylist.clear();

    for (int i = 0; i < trans_penlist.length; i++) {
      String txnCode = trans_penlist[i]["txn_Code"].toString();
      String txnSynched = trans_penlist[i]["isSynched"].toString();
      String pending = trans_penlist[i]["pending"].toString();
      String total = trans_penlist[i]["total"].toString();
      var tsModel = new TSummaryModel(txnCode, txnSynched,pending,total);
      tsummarylist.add(tsModel);
    }
    print("tsummarylist 3: " + tsummarylist.length.toString());*/
  }

  Future<void> getpendingtsfromdb() async {
    String qry_trans_pen_list = 'Select * from txn_summary_cnt_pending;';
    print('trans_pen_list 1:  ' + qry_trans_pen_list);
    List trans_pen_list = await db.RawQuery(qry_trans_pen_list);
    print('trans_pen_list  ' + trans_pen_list.toString());
    tsummarylist.clear();

    for (int i = 0; i < trans_pen_list.length; i++) {
      String _ID = trans_pen_list[i]["_ID"].toString();
      String txnCode = trans_pen_list[i]["txn_Code"].toString();
      String txn_Date = trans_pen_list[i]["txn_Date"].toString();
      String txn_Full_Date = trans_pen_list[i]["txn_Full_Date"].toString();
      String farmerName = trans_pen_list[i]["farmerName"].toString();
      String village = trans_pen_list[i]["village"].toString();
      String txnRefId = trans_pen_list[i]["txnRefId"].toString();
      String txnname = "";
      if (farmerName == 'null') {
        farmerName = '-';
      }
      if (village == 'null') {
        village = '-';
      }
      if (txnCode == datas.txnScouting) {
        txnname = "Scouting";
      } else if (txnCode == datas.txn_spray) {
        txnname = "Spraying";
      } else if (txnCode == datas.txnFarmerRegistration) {
        txnname = "Farmer Registration";
      } else if (txnCode == datas.txnFarmRegistration) {
        txnname = "Farm Registration";
      } else if (txnCode == datas.txnPlanting) {
        txnname = "Planting";
      } else if (txnCode == datas.txnSitePreparation) {
        txnname = "Site Selection";
      } else if (txnCode == datas.txnLandPreparation) {
        txnname = "Land Preparation";
      } else if (txnCode == datas.txnHarvest) {
        txnname = "Harvest";
      } else if (txnCode == datas.txn_sorting) {
        txnname = "Sorting";
      } else if (txnCode == datas.txnIncomingShipment) {
        txnname = "Incoming Shipment";
      } else if (txnCode == datas.txnPacking) {
        txnname = "Packing Operations";
      } else if (txnCode == datas.txnShipment) {
        txnname = "Shipment";
      } else if (txnCode == datas.txn_changePassword) {
        txnname = "Change Password";
      } else if (txnCode == datas.txnBlockRegistration) {
        txnname = "Block Registration";
      }
      else if (txnCode == datas.txnProductTransfer) {
        txnname = "Product Transfer";
      }
      else if (txnCode == datas.txnProductReception) {
        txnname = "Product Reception";
      }

      // var tsModel = new TSummaryModel(txnname+"/"+txnDate, txnSynched,pending,total);
      var tsModel = new TSummaryPendingModel(_ID, txnCode, txn_Date,
          txn_Full_Date, farmerName, village, txnRefId, txnname);
      setState(() {
        tsummarypendinglist.add(tsModel);
      });
    }
    print("tsummarylist 3: " + tsummarylist.length.toString());
  }
}

class DatewiseTabBar extends StatefulWidget {
  _DatewiseTabBar createState() => _DatewiseTabBar();
}

class _DatewiseTabBar extends State<DatewiseTabBar> {
  @override
  void initState() {
    super.initState();
    getvaluesfromdb();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getvaluesfromdb() async {
    String qry_translist =
        'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total, txn_Date FROM txn_summary_cnt GROUP BY txn_Code;';
    print('tsummarylist 1:  ' + qry_translist);
    List translist = await db.RawQuery(qry_translist);
    print('tsummarylist 2:  ' + translist.toString());
    tsummarylist.clear();

    for (int i = 0; i < translist.length; i++) {
      String txnCode = translist[i]["txn_Code"].toString();
      String txnSynched = translist[i]["isSynched"].toString();
      String pending = translist[i]["pending"].toString();
      String total = translist[i]["total"].toString();
      String txn_Date = translist[i]["txn_Date"].toString();
      String txnname = "";
      if (txnCode == datas.txnScouting) {
        txnname = "Scouting";
      } else if (txnCode == datas.txn_spray) {
        txnname = "Spraying";
      } else if (txnCode == datas.txnFarmerRegistration) {
        txnname = "Farmer Registration";
      } else if (txnCode == datas.txnFarmRegistration) {
        txnname = "Farm Registration";
      } else if (txnCode == datas.txnPlanting) {
        txnname = "Planting";
      } else if (txnCode == datas.txnSitePreparation) {
        txnname = "Site Selection";
      } else if (txnCode == datas.txnLandPreparation) {
        txnname = "Land Preparation";
      } else if (txnCode == datas.txnHarvest) {
        txnname = "Harvest";
      } else if (txnCode == datas.txn_sorting) {
        txnname = "Sorting";
      } else if (txnCode == datas.txnIncomingShipment) {
        txnname = "Incoming Shipment";
      } else if (txnCode == datas.txnPacking) {
        txnname = "Packing Operations";
      } else if (txnCode == datas.txnShipment) {
        txnname = "Shipment";
      } else if (txnCode == datas.txn_changePassword) {
        txnname = "Change Password";
      } else if (txnCode == datas.txnBlockRegistration) {
        txnname = "Block Registration";
      }
      else if (txnCode == datas.txnProductTransfer) {
        txnname = "Product Transfer";
      }
      else if (txnCode == datas.txnProductReception) {
        txnname = "Product Reception";
      }

      var tsModel = new TSummaryModel(
          txnname + '/' + txn_Date, total, txnSynched, pending);
      setState(() {
        tsummarylist.add(tsModel);
      });
    }
    print("tsummarylist 3: " + tsummarylist.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: <Widget>[
      Expanded(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10.0),
          children: _getListings(
              context), // <<<<< Note this change for the return type
        ),
        flex: 8,
      ),
    ])));
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    /*listings.add( Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Colors.red,
                child: new Text("All",
                    style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                onPressed: (){
                  getvaluesfromdb();
                },
              ),
              flex:1,
            ),
            VerticalDivider(width: 10.0,),
            Expanded(
                child: MaterialButton(
                  color: Colors.green,
                  child: new Text("Pending",
                      style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                  onPressed: (){
                    getvaluesfromdb();
                  },
                ),
                flex:1
            ),
          ]),
    ));*/
    if (tsummarylist.length > 0) {
      listings.add(transummarylist(tsummarylist));
    }
    listings.add(btn_dynamic(
        label: "OK",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () {
          Navigator.pop(context);
        }));

    return listings;
  }
}

Widget transummarylist(List<TSummaryModel> tsummarylist) {
  Widget objWidget = Container(
    child: Column(children: <Widget>[
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tsummarylist == null ? 1 : tsummarylist.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // return the header
            return Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "Transaction Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Total",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Synched",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Pending",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  )
                ],
              ),
            );
          }
          index -= 1;
          // return row
          var row = tsummarylist[index];
          return Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tsname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tsTotal,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tsSynched,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tspending,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  )
                ],
              ),
            ),
          ]);
        },
      ),
    ]),
  );
  return objWidget;
}

Widget transummaryPendinglist(List<TSummaryPendingModel> tsummarylist) {
  Widget objWidget = Container(
    child: Column(
      children: [
        Column(children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tsummarylist == null ? 1 : tsummarylist.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                // return the header
                return Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10.0),
                  color: Colors.green,
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            "Farmer/ Supplier",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 3,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Transaction Name",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Transaction Date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Village/PFC",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 2,
                      )
                    ],
                  ),
                );
              }
              index -= 1;
              // return row
              var row = tsummarylist[index];
              return Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            tsummarylist[index].farmerName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 3,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tsummarylist[index].txnName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tsummarylist[index].txn_Full_Date,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tsummarylist[index].village,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                        flex: 2,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.only(left: 5, right: 5),
                ),
              ]);
            },
          ),
        ]),
      ],
    ),
  );
  return objWidget;
}
