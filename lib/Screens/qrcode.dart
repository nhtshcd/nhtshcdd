import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nhts/Screens/printQRCode.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zebrautility/ZebraPrinter.dart';
import 'package:zebrautility/zebrautility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imgDart;

import '../Model/UIModel.dart';
import '../main.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
//import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

class QrReader extends StatefulWidget {
  String qrString = "";
  String title = "";
  String recentQr = "";
  List<PrintModel> printLists = [];
  List<MultiplePrintModel> multipleprintLists = [];
  //QrReader(this.qrString, this.printLists);
  QrReader(this.multipleprintLists, this.title, this.recentQr);

  @override
  QrReaderScreeen createState() => QrReaderScreeen(multipleprintLists, title,recentQr);
}

class MultiplePrintModel {
  List<PrintModel>? printLists;
  String? qrString;

  MultiplePrintModel(this.printLists, this.qrString);
}

class QrReaderScreeen extends State<QrReader> with TickerProviderStateMixin {
  ZebraPrinter? zebraPrinter;

  bool qrScanner = false;
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String title = '';
  String recentQA = '';
  String no = 'No', yes = 'Yes';
  bool copiesenabled = true;

  List<MultiplePrintModel> multipleprintLists = [];
  QrReaderScreeen(this.multipleprintLists, this.title ,this.recentQA);
  List<String> arrOfStr = [];
  TextEditingController copiesController = new TextEditingController();
  int copies = 1;
  bool printerConnected = false;
  bool _progress = false;
  String _msjprogress = "";
  bool connected = false;
  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];
  List<Widget> listings = [];
  List<DropdownMenuItem> printerItem = [];
  DropdownModel? printerSelect;
  String slctPrinter="";
  String valPrinter="";
  List<UImodel> printUIModel = [];
  //QRCodePrinter qRCodePrinter = QRCodePrinter();
  @override
  void initState() {
    super.initState();
    // toast(multipleprintLists.length.toString());
    //zebraprinterinti();
    //connect();
    copiesController.addListener(() {
      String texts = copiesController.text;
      if (texts == "") {
        copies = 1;
      } else {
        copies = int.parse(copiesController.text);
      }
    });

    List printerList = [
      {"property_value": "Zebra Printer", "DISP_SEQ": "0"},
      {"property_value": "Bixolon Printer", "DISP_SEQ": "1"},
    ];
    printerItem = [];
    printUIModel=[];

    for (int i = 0; i < printerList.length; i++) {
      String regStatName = printerList[i]["property_value"].toString();
      String regStatCode = printerList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(regStatName, regStatCode);
      printUIModel.add(uimodel);

      setState(() {
        printerItem.add(DropdownMenuItem(
          child: Text(regStatName),
          value: regStatName,
        ));
      });
    }

  }

  Future<void> connect() async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    try{
      //0000FE79-0000-1000-8000-00805F9B34FB
      //40:19:20:5B:A2:BB
      final bool result =
      await PrintBluetoothThermal.connect(macPrinterAddress: "40:19:20:5B:A2:BB");
      print("state conected $result");
      if (result) {
        connected = true;
        printerConnected = true;
      }
      setState(() {
        _progress = false;
        printerConnected = true;
      });
    }catch(e){
      print("printer connection status:$e");
    }

  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> zebraprinterinti() async {
    print('test print');
    try {

      zebraPrinter = await Zebrautility.getPrinterInstance(
          onPrinterFound: (name, ipAddress, isWifiPrinter) {
            toast("PrinterFound :" +
                name +
                '\n' +
                ipAddress +
                '\n' +
                isWifiPrinter.toString());
            print("ipAddress :" + ipAddress);
            connectPrinter(ipAddress);
          },
          onDiscoveryError: onDiscoveryError,
          onPrinterDiscoveryDone: onPrinterDiscoveryDone,
          onChangePrinterStatus: onChangePrinterStatus,
          onPermissionDenied: onPermissionDenied);

      zebraPrinter!.discoveryPrinters();
    } catch (e) {
      // toast(e.toString());
    }

    //connectPrinter('A4:DA:32:86:33:A6');
  }

  connectPrinter(String ip) {
// String printerstatus =zebraPrinter.isPrinterConnected();
    toast("printer connected to ip :  " + ip.toString());
    EasyLoading.show(
      status: 'Connecting to printer',
      maskType: EasyLoadingMaskType.black,
    );
    zebraPrinter!.connectToPrinter(ip);

    setState(() {
      printerConnected = true;
    });
  }

  Function onPrinterFound = (name, ipAddress, isWifiPrinter) {
    // toast("PrinterFound :" + name + ipAddress);
    toast("ipAddress :" + ipAddress);
  };
  Function onPrinterDiscoveryDone = () {
    toast("Discovery Done");
    EasyLoading.dismiss();
  };
  Function(int errorCode, String errorText)? onDiscoveryError =
      (errorCode, errorText) {
    toast("Discovery Error " + ' ' + errorText);
  };
  Function(String status, String color)? onChangePrinterStatus =
      (status, color) {
    toast("change printer status: " + status + color);
  };
  Function onPermissionDenied = () {
    // toast("Permission Deny.");
  };
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _onBackPressed();
              },
            ),
            title: Text(
              'Qr Code',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child:
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: txt_label_mandatory("Select a printer", Colors.black, 14.0, false)),
                          Expanded(child:singlesearchDropdown(
                            itemlist: printerItem,
                            selecteditem: slctPrinter,
                            hint: "Select Printer",
                            onChanged: (value) {
                              setState(() {
                                slctPrinter = value!;
                                for (int i = 0; i < printUIModel.length; i++) {
                                  if (value == printUIModel[i].name) {
                                    valPrinter = printUIModel[i].value;
                                  }
                                }
                              });
                            },
                          ) /*DropDownWithModel(
                            itemlist: printerItem,
                            selecteditem: printerSelect,
                            hint: "Select a printer",
                            onChanged: (value) {
                              setState(() {
                                valPrinter = printerSelect!.value;
                                slctPrinter = printerSelect!.name;
                                print("valprintervalue:"+valPrinter);
                              });
                            },
                          )*/)
                        ],
                      ),
                    ),
                  ),
                  copiesenabled
                      ? Expanded(
                    child: txtfield_digits_integer(
                        "No of Copies", copiesController, true, 20),
                    flex: 1,
                  )
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: multipleprintLists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(top: 15),
                                  //alignment: Alignment.center,
                                  child: Center(
                                    child: QrImage(
                                      data: multipleprintLists[index].qrString!,
                                      version: QrVersions.auto,
                                      size: 250,
                                      gapless: false,
                                      embeddedImage: const AssetImage(
                                          'assets/images/my_embedded_image.png'),
                                      embeddedImageStyle: QrEmbeddedImageStyle(
                                        size: const Size(100, 100),
                                      ),
                                    ),
                                  )),
                              Container(
                                height: 170,
                                child: ListView(
                                  padding: const EdgeInsets.all(10.0),
                                  children: _getListings(context,
                                      index), // <<<<< Note this change for the return type
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
                    flex: 10,
                  ),


                  /* Container(
                    alignment: Alignment.center,
                    child: QrImage(
                      data: qrtext,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                      embeddedImage:
                      AssetImage('assets/images/my_embedded_image.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(80, 80),
                      ),
                    )), */
                 /*zebra printer integration*/
                  valPrinter =="0"?Container(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            width: 50,
                            child: RaisedButton(
                              child: Text(
                                printerConnected ? 'Print' : 'Connect',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (printerConnected) {
                                  if (copies == 0) {
                                    EasyLoading.showError(
                                        "Number of copies should be greater than 0");
                                  } else {
                                    EasyLoading.show(
                                      status: 'Printing...',
                                      maskType: EasyLoadingMaskType.black,
                                    );
                                    for (int i = 0; i < copies; i++) {
                                      setState(() {
                                        copiesenabled = false;
                                      });

                                      int delayseconds = 10;
                                      if (Platform.isAndroid) {
                                        delayseconds = 10;
                                      } else if (Platform.isIOS) {
                                        delayseconds = 25;
                                      }
                                      for (int k = 0;
                                      k < multipleprintLists.length;
                                      k++) {
                                        Uint8List img = await toQrImageData(
                                            multipleprintLists[k].qrString!);
                                        var bs64 = base64Encode(img);
                                        int nocopy = 1;
                                        int lines = 6;
                                        int emptylines = lines -
                                            multipleprintLists[k]
                                                .printLists!
                                                .length;

                                        String printingcontent = '\r\r';
                                        printingcontent =
                                            '                  ! U1 SETLP 5 2 46' +
                                                appDatas.appname;
                                        printingcontent = printingcontent +
                                            '\r! U1 SETLP 7 0 30                ' +
                                            widget.title;
                                        //printingcontent = printingcontent + '\r ';
                                        printingcontent = printingcontent +
                                            '\r---------------------------------------- ';
                                        printingcontent = printingcontent +
                                            '\r ! U1 SETLP 7 0 40';
                                        for (int i = 0;
                                        i <
                                            multipleprintLists[k]
                                                .printLists!
                                                .length;
                                        i++) {
                                          printingcontent = printingcontent +
                                              '\r ' +
                                              multipleprintLists[k]
                                                  .printLists![i]
                                                  .name +
                                              " : " +
                                              multipleprintLists[k]
                                                  .printLists![i]
                                                  .value;
                                        }
                                        for (int i = 0; i < emptylines; i++) {
                                          printingcontent =
                                              printingcontent + '\r ';
                                        }

                                        bool flag = true;
                                        var count = 0.0;
                                        var futureThatStopsIt = Future.delayed(
                                            Duration(
                                                seconds: (nocopy *
                                                    delayseconds)), () {
                                          flag = false;
                                        });

                                        var futureWithTheLoop = () async {
                                          while (flag) {
                                            count++;
                                            print("going on: $count");
                                            Uint8List img = await toQrImageData(
                                                multipleprintLists[k]
                                                    .qrString!);
                                            var bs64 = base64Encode(img);

                                            print("bs64--: $bs64");
                                            print("printingcontent--: $printingcontent");
                                            //
                                            zebraPrinter!.printImage(
                                                bs64, printingcontent);
                                            await Future.delayed(Duration(
                                                seconds: delayseconds));
                                          }
                                        }();
                                        await Future.wait([
                                          futureThatStopsIt,
                                          futureWithTheLoop
                                        ]);
                                        if (k + 1 ==
                                            multipleprintLists.length) {}
                                      }
                                    }
                                    setState(() {
                                      copiesenabled = true;
                                    });
                                    EasyLoading.dismiss();
                                  }
                                } else {
                                  zebraprinterinti();
                                }

                                //zebraPrinter!.printImage(bs64.toString(), "");
                              },
                              color: printerConnected
                                  ? Colors.redAccent
                                  : Colors.orange,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: RaisedButton(
                              child: Text(
                                'Close',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                _onBackPressed();
                              },
                              color: Colors.green,
                            ),
                          ),
                        ),
                        //
                      ],
                    ),
                  ):Container(),
                  /*bixolon printer integration*/
                  valPrinter =="1"?Container(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            width: 50,
                            child: RaisedButton(
                              child: Text(
                                printerConnected ? 'Print' : 'Connect',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {

                                if (printerConnected) {
                                  if (copies == 0) {
                                    EasyLoading.showError(
                                        "Number of copies should be greater than 0");
                                  } else {
                                    EasyLoading.show(
                                      status: 'Printing...',
                                      maskType: EasyLoadingMaskType.black,
                                    );
                                    for (int i = 0; i < copies; i++) {
                                      setState(() {
                                        copiesenabled = false;
                                      });


                                      await printWithoutPackage();
                                    }
                                    setState(() {
                                      copiesenabled = true;
                                    });
                                    EasyLoading.dismiss();
                                  }
                                } else {
                                  connect();
                                  //qRCodePrinter.getPairedBluetoothList();

                                }


                              },
                              color: printerConnected
                                  ? Colors.redAccent
                                  : Colors.orange,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: RaisedButton(
                              child: Text(
                                'Close',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                _onBackPressed();
                              },
                              color: Colors.green,
                            ),
                          ),
                        ),
                        //
                      ],
                    ),
                  ):Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<int>> testTicket() async {

    const double qrSize = 300;


    List<int> bytes = [];




    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    // setState(() {
    //   bytes = generator.reset();
    // });


    /* //Using `ESC *`
    bytes += generator.image(image!);*/



    for(int k=0;k<multipleprintLists.length;k++){

      bytes += generator.emptyLines(2);

      bytes += generator.text(
         "Ke-HTS",styles: PosStyles(
          bold: true,
              align: PosAlign.center,
        fontType: PosFontType.fontA
      ));

      bytes += generator.text(
          widget.title,styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          fontType: PosFontType.fontA
      ));

      bytes += generator.text(
          "------------------------------------------------",styles: PosStyles(
        bold: true,
        align: PosAlign.center,
      ));

      for(int i=0;i<multipleprintLists[k].printLists!.length;i++){
        bytes += generator.text(
            multipleprintLists[k].printLists![i].name + ":" + multipleprintLists[k].printLists![i].value,styles: PosStyles(
          bold: true
        ));


      }

      final uiImg = await  QrPainter(
        data: multipleprintLists[k].qrString!,
        version: QrVersions.auto,
        gapless: false,
          color: const Color(0xff000000),
          emptyColor: const Color(0xffffffff)
      ).toImageData(390);
      final dir = await getTemporaryDirectory();
      final pathName = '${dir.path}/qr_tmp.png';
      final qrFile = File(pathName);
      final imgFile = await qrFile.writeAsBytes(uiImg!.buffer.asUint8List());
      final img = imgDart.decodeImage(imgFile.readAsBytesSync());

      print("multipleprintLists[k].qrString!"+multipleprintLists[k].qrString!);
      bytes += generator.emptyLines(2);
      bytes += generator.image(img!);
      // setState(() {
      //   bytes = generator.reset();
      // });

    }



    //bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      // bool result = await PrintBluetoothThermal.writeString(
      //     printText: PrintTextSize(size: int.parse(_selectSize), text: text));
      //  final bytes = File('images/qr.png').readAsBytesSync();
      //bool result = await PrintBluetoothThermal.writeBytes(bytes);
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("status print result: $result");
      setState(() {

      });
    } else {
      //no conectado, reconecte
      setState(() {

      });
      print("no conectado");
    }
  }







  printConnect()async{
    String imagePath = 'images/calendar.png';

    ByteData data = await rootBundle.load(imagePath);
    List<int> imageData = data.buffer.asUint8List();

    int imageWidth = 200; // Set the desired width
    int imageHeight = 200;

    int bytesPerRow = (imageWidth + 7) ~/ 8;

// Start building CPCL commands
    List<String> cpclCommands = [];

// Set the label width and length (adjust as needed)
    cpclCommands.add("! 0 200 200 200 1\r\n");

// Set the position for printing the image
    cpclCommands.add("POSITION 50 50\r\n");

// Start the image printing command
    cpclCommands.add("BITMAP $imageWidth $imageHeight $bytesPerRow\r\n");

// Add the image data as hex bytes
    for (int i = 0; i < imageData.length; i += 8) {
      List<int> chunk = imageData.sublist(i, i + 8);
      cpclCommands.add(chunk.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' '));
      cpclCommands.add("\r\n");
    }

// End the image printing command
    cpclCommands.add("PRINT\r\n");

// Combine all CPCL commands into a single string
    String cpclString = cpclCommands.join();

// Send the CPCL commands to the printer using appropriate communication method
// For example, you might use a plugin like 'esc_pos_printer' to send commands to the printer

// Send the CPCL string to the printer
    await zebraPrinter!.printImage(cpclString, cpclString);
  }

  List<Widget> _getListings(BuildContext context, int index) {
    List<Widget> listings = [];

    for (int i = 0; i < multipleprintLists[index].printLists!.length; i++) {
      listings.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              multipleprintLists[index].printLists![i].name + " : ",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            flex: 1,
          ),
          Expanded(
            child: Text(
              multipleprintLists[index].printLists![i].value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            flex: 1,
          ),
        ],
      ));
    }

    return listings;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Cancel'),
        content: new Text('Are you want to cancel'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              try {
                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 1000), () {
                  zebraPrinter!.disconnect();
                });

                Navigator.pop(context);
              } catch (E) {
                toast(E.toString());
              }
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
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
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {


            print("zebraVal1");
            EasyLoading.show(
              status: 'Disconnecting printer...',
              maskType: EasyLoadingMaskType.black,
            );

            Future.delayed(const Duration(milliseconds: 1000), () {
              //zebraPrinter!.disconnect();
              print("zebraVal2" );
              EasyLoading.dismiss();

              if(recentQA.isEmpty){
                print("zebraVal3" );
                print(recentQA);

                if (title == "Shipment URL") {
                  print("shipment menu QR");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  print("other menu QR");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }else {
                print("zebraVal4" );
                print(recentQA);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            });
            // Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            no,
            style: const TextStyle(color: Colors.white, fontSize: 20),
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

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: const Color(0xff000000),
        emptyColor: const Color(0xffffffff),
      ).toImage(390);
      final a = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = a!.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      throw e;
    }
  }
}

class PrintModel {
  String name;
  String value;

  PrintModel(this.name, this.value);
}
