import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:nhts/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nhts/Screens/sorting.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nhts/Utils/QrScanner.dart';
import 'package:zebrautility/ZebraPrinter.dart';
import 'package:zebrautility/zebrautility.dart';
import '../Utils/secure_storage.dart';
import '../login.dart';
import '../main.dart';

import '../login.dart';

class MultiQRGenerator extends StatefulWidget {
  String qrString = "";
  String noOfBgs = "";

  MultiQRGenerator(this.qrString, this.noOfBgs);

  @override
  MultiQrReaderScreeen createState() => MultiQrReaderScreeen(qrString, noOfBgs);
}

class MultiQrReaderScreeen extends State<MultiQRGenerator>
    with TickerProviderStateMixin {
  String qrtext = '';
  String noOfBgs = '';
  String qrCode = 'QR Code';
  String boxprnt = 'No of Box Labels to Print';
  String prnt = 'Print';
  String close = 'Close';
  String Identity = "";
  String amount = "";
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';

  bool _connected = false;
  bool _pressed = false;
  ZebraPrinter? zebraPrinter;

  MultiQrReaderScreeen(this.qrtext, this.noOfBgs);
  List<String> arrOfStr = [];

  //String getup = qrtext.toString();

  TextEditingController countController = new TextEditingController();
  int count = 1;
  @override
  void initState() {
    arrOfStr = qrtext.split(",");
    print("tag" + noOfBgs);
    if (noOfBgs == "1") {
      print("shipment");
      Identity = "Batch Number";
      amount = "Received Qty(Kg)";
    } else if (noOfBgs == "2") {
      print("Packing");
      Identity = "Lot Number";
      amount = "Packed Qty(Kg)";
    }
    countController.text ="1";
    super.initState();
    //countController.text = noOfBgs;
    //count = int.parse(countController.text);
    //if (count == 0) {
    // count = count + 1;
    //}
    //int noofbox = count;
    //print("Split " + arrOfStr.first);

    // countController.addListener(() {
    //   //here you have the changes of your textfield
    //
    //   String countentered = countController.text;
    //
    //   int CountEntered = int.parse(countentered);
    //
    //   if (CountEntered <=noofbox ) {
    //
    //   } else {
    //     toast('Maximum Box is '+count.toString());
    //     countController.text = '';
    //   }
    //   //use setState to rebuild the widget
    //   setState(() {});
    // });
    translate();
    zebraprinterinti();
  }

  Future<void> zebraprinterinti() async {
    try {
      zebraPrinter = await Zebrautility.getPrinterInstance(
          onPrinterFound: (name, ipAddress, isWifiPrinter) {
            // toast("PrinterFound :" + name +'\n'+ ipAddress+'\n'+isWifiPrinter.toString());
            // print("ipAddress :" + ipAddress);
            connectPrinter(ipAddress);
          },
          //onDiscoveryError: onDiscoveryError,
          onPrinterDiscoveryDone: onPrinterDiscoveryDone,
          //onChangePrinterStatus: onChangePrinterStatus,
          onPermissionDenied: onPermissionDenied);

      zebraPrinter!.discoveryPrinters();
    } catch (e) {
      // toast(e.toString());
    }

    //connectPrinter('A4:DA:32:86:33:A6');
  }

  connectPrinter(String ip) {
    zebraPrinter!.connectToPrinter(ip);
    toast('Printer Connected');
  }

  Function onPrinterFound = (name, ipAddress, isWifiPrinter) {
    print("PrinterFound :" + name + ipAddress);
    print("ipAddress :" + ipAddress);
  };
  Function onPrinterDiscoveryDone = () {
    print("Discovery Done");
  };
  Function onChangePrinterStatus = (status, color) {
    print("change printer status: " + status + color);
  };
  Function onPermissionDenied = () {
    print("Permission Deny.");
  };
  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: Color(0xff000000),
        emptyColor: Color(0xffffffff),
      ).toImage(250);
      final a = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = a!.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      throw e;
    }
  }

  void translate() async {
    String Lang = '';
    try {
      Lang =await SecureStorage().readSecureData("langCode")!;
      print("CHECK_LANGUAGE 2: " + Lang);
    } catch (e) {
      Lang = 'en';
    }
    String qry =
        'select * from labelNamechange where tenantID =  \'greenpath\' and lang = \'' +
            Lang +
            '\'';
    print('transList2 ' + qry);
    List transList = await db.RawQuery(qry);
    print('transList2 ' + transList.toString());
    for (int i = 0; i < transList.length; i++) {
      String classname = transList[i]['className'];
      String labelName = transList[i]['labelName'];

      switch (classname) {
        case "qrCode":
          setState(() {
            qrCode = labelName;
          });
          break;
        case "boxprnt":
          setState(() {
            boxprnt = labelName;
          });
          break;
        case "prnt":
          setState(() {
            prnt = labelName;
          });
          break;
        case "close":
          setState(() {
            close = labelName;
          });
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }),
            title: Text(
              qrCode,
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: appDatas.appcolor,
            brightness: Brightness.light,
          ),
          body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  //txtfield_digitss(boxprnt, countController, true),
                  Container(
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            color: appDatas.appcolor,
                            child: Text(prnt,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            onPressed: () {
                              setState(() async {
                                // print('CHECK_QR_COUNT1: '+countController.value.text);
                                int qrcount =
                                    int.parse(countController.value.text);
                                //print('CHECK_QR_COUNT2: '+qrcount.toString());
                                count = qrcount;
                                zebraPrinter!
                                    .print(appDatas.appname + '\r' + qrtext);
                                Uint8List img = await toQrImageData(qrtext);
                                var bs64 = base64Encode(img);
                                // print('Imagebase64 '+bs64.toString());
                                //zebraPrinter!.printImage(bs64.toString(), "");
                                zebraPrinter!.print( "kirubha");

                                //print('CHECK_QR_COUNT3: '+count.toString());
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            color: appDatas.appcolor,
                            child: Text(close,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ),
                      )
                    ]),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: arrOfStr.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> firstdata = arrOfStr[index].split('~');
                          String ID = firstdata[0];
                          String blockid = firstdata[3];
                          String productName = firstdata[6];
                          //String blockid= arrOfStr[2];
                          String variety = firstdata[8];
                          String quantity = firstdata[9];

                          return Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 15),
                                  alignment: Alignment.center,
                                  child: QrImage(
                                    data: arrOfStr[index],
                                    version: QrVersions.auto,
                                    size: 250,
                                    gapless: false,
                                    embeddedImage: AssetImage(
                                        'assets/images/my_embedded_image.png'),
                                    embeddedImageStyle: QrEmbeddedImageStyle(
                                      size: Size(100, 100),
                                    ),
                                  )),
                              Container(
                                child: Text(
                                  "\n" +
                                      Identity +
                                      "          : " +
                                      ID +
                                      "\nBlock ID                 : " +
                                      blockid +
                                      "\nProduct Name      : " +
                                      productName +
                                      "\nVariety                   : " +
                                      variety +
                                      "\n" +
                                      amount +
                                      "   : " +
                                      quantity,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),

                              /* Container(
                             padding: EdgeInsets.only(top: 5),
                             child: Text(qrtext,
                                 style: TextStyle(fontSize: 14.0, color: Colors.black87,fontWeight: FontWeight.bold)),
                           ), */
                            ],
                          );
                        }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}
