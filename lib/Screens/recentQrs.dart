import 'package:flutter/material.dart';
import 'package:nhts/Screens/qrcode.dart';
import '../Utils/MandatoryDatas.dart';
import '../Model/UIModel.dart';
import '../Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

import '../login.dart';
import 'IncomingShipment.dart';

class RecentQrImages extends StatefulWidget {
  const RecentQrImages({Key? key}) : super(key: key);

  @override
  State<RecentQrImages> createState() => _RecentQrImagesState();
}

class _RecentQrImagesState extends State<RecentQrImages> {

  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';

  List<DropdownModel> txnDateDropdown = [];
  DropdownModel? selectedTxnDate;
  String valTxnDate="" ;

  List<DropdownModel> stkTypeDropdown = [];
  DropdownModel? selectedstkType;
  String valstkType="" ;

  List<DropdownModel1> qrIDDropdown = [];
  DropdownModel1? selectedqrID;
  String valqrID="" ;
  String qrString="" ;
  String qrDetails="" ;

  String exporterName = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";

  List<TransactionDetails> txnDetails=[];
  List splitDetails=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTxnData();
    getClientData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                },
              ),
              title: Text('QR Images',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700)),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.green,
              brightness: Brightness.light,
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child:txnDetails.isNotEmpty ? ListView.builder(
                          itemCount: txnDetails.length,
                          shrinkWrap: true,
                          itemBuilder: (context , item){
                            return Container(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.greenAccent,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                                  ),                          elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Transaction Date : ',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text(
                                                txnDetails[item].date!,
                                                style: const TextStyle(fontSize: 16, color: Colors.black),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'QR ID : ',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text(
                                                txnDetails[item].qrCode!,
                                                style: const TextStyle(fontSize: 16, color: Colors.black),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Stock Type : ',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text(
                                                txnDetails[item].stock =='1' ? 'Sorting' :
                                                txnDetails[item].stock =='2' ? 'Incoming Shipment' :'Packing',
                                                style: const TextStyle(fontSize: 16, color: Colors.black),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Crop Name',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text(
                                                txnDetails[item].blockID!,
                                                style: const TextStyle(fontSize: 16, color: Colors.black),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Planting ID : ',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text(
                                                txnDetails[item].plantingID!,
                                                style: const TextStyle(fontSize: 16, color: Colors.black),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        RaisedButton(
                                          elevation: 12,
                                          child: Text(
                                            'View QR',
                                            style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                                          ),
                                          onPressed: () {
                                            print('stocktype-- ${txnDetails[item].stock}');
                                            List<PrintModel> printLists = [];
                                            List<String> arrOfStr = txnDetails[item].qrString!.split("~");

                                            print(arrOfStr);

                                            if(txnDetails[item].stock =='1'){
                                              print('qrcode  ${ txnDetails[item].qrCode}');

                                              final now = DateTime.now();
                                              String productName = arrOfStr[5];
                                              String blockid = arrOfStr[2];
                                              String variety = arrOfStr[7];
                                              String quantity = arrOfStr[8];
                                              String FarmerName = arrOfStr[10];
                                              String plantingID = arrOfStr[16];
                                              String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                                              printLists.add(PrintModel("Farmer Name", FarmerName));
                                              printLists.add(PrintModel("Block ID", blockid));
                                              printLists.add(PrintModel("Planting ID", plantingID));
                                              printLists.add(PrintModel("Crop Name", productName));
                                              printLists.add(PrintModel("Variety", variety));
                                              printLists.add(PrintModel("Sorted Qty(Kg)", quantity));
                                              printLists.add(PrintModel("Exporter Name", exporterName));
                                              printLists.add(PrintModel("Date and Time", txntime));
                                              printLists.add(PrintModel("QR Unique Id", txnDetails[item].qrCode.toString()));
                                              List<MultiplePrintModel> multipleprintLists = [];
                                              multipleprintLists.add(MultiplePrintModel(printLists, qrString));

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QrReader(multipleprintLists, 'Sorting','recentQA')));
                                            }
                                            else if(txnDetails[item].stock =='2'){
                                              final now = DateTime.now();
                                              String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
                                              String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                                              String receptionBatchNo = msgNo;
                                              String blockID=arrOfStr[3];
                                              String plantingID=arrOfStr[18];
                                              String product=arrOfStr[6];
                                              String varietyId=arrOfStr[7];
                                              String recWeight=arrOfStr[9];
                                              String qrIdValue=arrOfStr[19];

                                              printLists.add(PrintModel("Batch Number", receptionBatchNo));
                                              printLists.add(PrintModel("Block ID", blockID));
                                              printLists.add(PrintModel("Planting ID", plantingID));
                                              printLists.add(PrintModel("Crop Name", product));

                                              printLists.add(PrintModel("Variety",varietyId));
                                              printLists.add(PrintModel("Received Qty(Kg)", recWeight));

                                              printLists.add(PrintModel("Exporter Name", exporterName));
                                              printLists.add(PrintModel("Date and Time", txntime));
                                              printLists.add(PrintModel("QR Unique Id", qrIdValue));


                                              List<MultiplePrintModel> multipleprintLists = [];
                                              multipleprintLists.add(MultiplePrintModel(printLists, qrString));

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QrReader(multipleprintLists, 'Incoming Shipment','recentQA')));
                                            }
                                            else if(txnDetails[item].stock =='3'){
                                              final now = DateTime.now();
                                              String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
                                              String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                                              String receptionBatchNo = msgNo;

                                              String lotNumber=arrOfStr[0];
                                              String blockId=arrOfStr[3];
                                              String plantingId=arrOfStr[18];
                                              String product=arrOfStr[6];
                                              String variety=arrOfStr[8];
                                              String packedQTy=arrOfStr[9];
                                              String qrIdValue=arrOfStr[19];

                                              print("varietyvalue:"+arrOfStr.toString());


                                              printLists.add(PrintModel("Lot Number", lotNumber));
                                              printLists.add(PrintModel("Block ID", blockId));
                                              printLists.add(PrintModel("Planting ID", plantingId));
                                              printLists.add(PrintModel("Crop Name", product));
                                              printLists.add(PrintModel("Variety",variety));
                                              printLists.add(PrintModel("Packed Qty(Kg)", packedQTy));
                                              printLists.add(PrintModel("Exporter Name", exporterName));
                                              printLists.add(PrintModel("Date and Time", txntime));
                                              printLists.add(PrintModel("QR Unique Id", qrIdValue));

                                              List<MultiplePrintModel> multipleprintLists = [];
                                              multipleprintLists.add(MultiplePrintModel(printLists, qrString));

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QrReader(multipleprintLists, 'Packing' ,'recentQA')));
                                            }

                                          },
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 10,),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      ) :Container(),/* Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Loading...'),
                          SizedBox(height: 15,),
                          CircularProgressIndicator(),
                        ],
                      ))*/
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
      context: context,
      type: AlertType.warning,
      title: exit,
      desc: ruexit,
      buttons: [
        DialogButton(
          child: Text(
            yes,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            no,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show()) ??
        false;
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(txt_label("Transaction date", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: txnDateDropdown,
      selecteditem: selectedTxnDate,
      hint: "Select Transfer date",
      onChanged: (value) {
        setState(() {
          stkTypeDropdown=[];
          qrIDDropdown=[];
          selectedstkType =null;
          selectedqrID =null;
          valstkType = '';
          valqrID = '';
          qrString='';
          qrDetails='';

          selectedTxnDate = value!;
          valTxnDate=selectedTxnDate!.value;
          loadStockType(valTxnDate);
        });
      },
    ));
    listings.add(txt_label("Stock type", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: stkTypeDropdown,
      selecteditem: selectedstkType,
      hint: "Select Stock Type",
      onChanged: (value) {
        setState(() {
          qrIDDropdown=[];
          selectedqrID =null;
          valqrID = '';
          qrString='';
          qrDetails='';

          selectedstkType = value!;
          valstkType=selectedstkType!.value;
          loadQRType(valstkType);
        });
      },
    ));
    listings.add(txt_label("QR ID's", Colors.black, 16.0, false));
    listings.add(DropDownWithModel1(
      itemlist: qrIDDropdown,
      selecteditem: selectedqrID,
      hint: "Select QR ID's",
      onChanged: (value) {
        setState(() {
          qrString='';
          qrDetails='';

          selectedqrID = value!;
          valqrID=selectedqrID!.name;
          qrString=selectedqrID!.value;
          qrDetails=selectedqrID!.value1;

          print('valqrID $valqrID');
          print('qrString $qrString');
          print('qrDetails $qrDetails');

        });
      },
    ));

    listings.add(txt_label("QR Details", Colors.black, 16.0, false));
    listings.add(cardlable_dynamicLarge(qrDetails.toString()));

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  _onBackPressed();
                },
                color: Colors.redAccent,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  List<PrintModel> printLists = [];
                  List<String> arrOfStr = qrString.split("~");

                  print(arrOfStr);


                  if(valstkType =='1'){
                    final now = DateTime.now();
                    String productName = arrOfStr[5];
                    String blockid = arrOfStr[2];
                    String variety = arrOfStr[7];
                    String quantity = arrOfStr[8];
                    String FarmerName = arrOfStr[10];
                    String plantingID = arrOfStr[16];
                    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                    printLists.add(PrintModel("Farmer Name", FarmerName));
                    printLists.add(PrintModel("Block ID", blockid));
                    printLists.add(PrintModel("Planting ID", plantingID));
                    printLists.add(PrintModel("Crop Name", productName));
                    printLists.add(PrintModel("Variety", variety));
                    printLists.add(PrintModel("Sorted Qty(Kg)", quantity));
                    printLists.add(PrintModel("Exporter Name", exporterName));
                    printLists.add(PrintModel("Date and Time", txntime));
                    printLists.add(PrintModel("QR Unique Id", valqrID.toString()));
                    List<MultiplePrintModel> multipleprintLists = [];
                    multipleprintLists.add(MultiplePrintModel(printLists, qrString));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QrReader(multipleprintLists, 'Sorting','recentQA')));
                  }else if(valstkType =='2'){
                    final now = DateTime.now();
                    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
                    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                    String receptionBatchNo = msgNo;
                    String blockID=arrOfStr[3];
                    String plantingID=arrOfStr[18];
                    String product=arrOfStr[6];
                    String varietyId=arrOfStr[7];
                    String recWeight=arrOfStr[9];
                    String qrIdValue=arrOfStr[18];

                    printLists.add(PrintModel("Batch Number", receptionBatchNo));
                    printLists.add(PrintModel("Block ID", blockID));
                    printLists.add(PrintModel("Planting ID", plantingID));
                    printLists.add(PrintModel("Crop Name", product));

                    printLists.add(PrintModel("Variety",varietyId));
                    printLists.add(PrintModel("Received Qty(Kg)", recWeight));

                    printLists.add(PrintModel("Exporter Name", exporterName));
                    printLists.add(PrintModel("Date and Time", txntime));
                    printLists.add(PrintModel("QR Unique Id", qrIdValue));


                    List<MultiplePrintModel> multipleprintLists = [];
                    multipleprintLists.add(MultiplePrintModel(printLists, qrString));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QrReader(multipleprintLists, 'Incoming Shipment','recentQA')));
                  }else if(valstkType =='3'){
                    final now = DateTime.now();
                    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
                    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                    String receptionBatchNo = msgNo;

                    String lotNumber=arrOfStr[0];
                    String blockId=arrOfStr[3];
                    String plantingId=arrOfStr[18];
                    String product=arrOfStr[6];
                    String variety=arrOfStr[7];
                    String packedQTy=arrOfStr[9];
                    String qrIdValue=arrOfStr[19];


                    printLists.add(PrintModel("Lot Number", lotNumber));
                    printLists.add(PrintModel("Block ID", blockId));
                    printLists.add(PrintModel("Planting ID", plantingId));
                    printLists.add(PrintModel("Crop Name", product));
                    printLists.add(PrintModel("Variety",variety));
                    printLists.add(PrintModel("Packed Qty(Kg)", packedQTy));
                    printLists.add(PrintModel("Exporter Name", exporterName));
                    printLists.add(PrintModel("Date and Time", txntime));
                    printLists.add(PrintModel("QR Unique Id", qrIdValue));

                    List<MultiplePrintModel> multipleprintLists = [];
                    multipleprintLists.add(MultiplePrintModel(printLists, qrString));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QrReader(multipleprintLists, 'Packing' ,'recentQA')));
                  }

                },
                color: Colors.green,
              ),
            ),
          ),
          //
        ],
      ),
    ));




    return listings;
  }

  Future<void> loadTxnData() async {
    print("qryBlockNumber" );

    String qryTransferFrom = 'select distinct qrCode,qrDate,stkType,qrString,detString,blockID,plantingID from qrDetails order by qrDate desc';
    print("qryBlockNumber" + qryTransferFrom.toString());
    List transferFromList = await db.RawQuery(qryTransferFrom);


    for (int i = 0; i < transferFromList.length; i++) {
      String qrDate = transferFromList[i]["qrDate"].toString();
      String qrCode = transferFromList[i]["qrCode"].toString();
      String stkType = transferFromList[i]["stkType"].toString();
      String qrStringV = transferFromList[i]["qrString"].toString();
      String detString = transferFromList[i]["detString"].toString();
      String blockID = transferFromList[i]["blockID"].toString();
      String platingID = transferFromList[i]["plantingID"].toString();
      qrString = qrStringV;
      setState(() {
        txnDetails.add(TransactionDetails(
          qrCode,
          stkType,
          qrDate,
          qrStringV,
          detString,
          blockID,
          platingID,
        ));
      });
    }
  }

  Future<void> loadStockType(String valTxnDate) async {
    String qryTransferFrom = 'select distinct stkType from qrDetails where qrDate = \''+valTxnDate+'\'';
    print("qryBlockNumber" + qryTransferFrom.toString());
    List transferFromList = await db.RawQuery(qryTransferFrom);

    stkTypeDropdown = [];
    stkTypeDropdown.clear();

    for (int i = 0; i < transferFromList.length; i++) {
      String packHouseName = transferFromList[i]["stkType"].toString();
      String packHouseID = transferFromList[i]["stkType"].toString();
      var uimodel = UImodel(packHouseName, packHouseID);
      setState(() {
        stkTypeDropdown.add(DropdownModel(
          packHouseID=='1'? 'Sorting' : packHouseID=='2'? 'Incoming Shipment' : 'Packing',
          packHouseID,
        ));
      });
    }
  }

  Future<void> loadQRType(String valstkType) async {
    String qryTransferFrom = 'select distinct qrCode,qrString,detString from qrDetails where stkType = \''+valstkType+'\'';
    print("qryBlockNumber" + qryTransferFrom.toString());
    List transferFromList = await db.RawQuery(qryTransferFrom);

    qrIDDropdown = [];
    qrIDDropdown.clear();

    for (int i = 0; i < transferFromList.length; i++) {
      String qrString = transferFromList[i]["qrString"].toString();
      String detString = transferFromList[i]["detString"].toString();
      String qrCode = transferFromList[i]["qrCode"].toString();
      setState(() {
        qrIDDropdown.add(DropdownModel1(
          qrCode,
          qrString,
          detString,
        ));
      });
    }
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    exporterName = agents[0]['exporterName'];
  }
}

class TransactionDetails{
  String? qrCode;
  String? stock;
  String? date;
  String? qrString;
  String? detString;
  String? blockID;
  String? plantingID;

  TransactionDetails(
      this.qrCode, this.stock, this.date, this.qrString, this.detString ,this.blockID,this.plantingID);
}
