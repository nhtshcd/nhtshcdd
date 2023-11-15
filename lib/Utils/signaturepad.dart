import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;

import 'package:rflutter_alert/rflutter_alert.dart';

class SignaturePad extends StatefulWidget {
  @override
  SignaturePadScreeen createState() => SignaturePadScreeen();
}

class SignaturePadScreeen extends State<SignaturePad>
    with TickerProviderStateMixin {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 2.0;
  final _sign = GlobalKey<SignatureState>();

 _onBackPressed() {
    return Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: "Are you sure want to cancel?",
          buttons: [
            DialogButton(
              child: Text(
                "Yes",
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
                "No",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show() ;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _onBackPressed();
              }),
          title: Text(
            'Signature',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Signature(
                    color: color,
                    key: _sign,
                    onSign: () {
                      final sign = _sign.currentState;
                      debugPrint(
                          '${sign!.points.length} points in the signature');
                    },
                    //  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                    strokeWidth: strokeWidth,
                  ),
                ),
                color: Colors.black12,
              ),
            ),
            _img.buffer.lengthInBytes == 0
                ? Container()
                : LimitedBox(
                    maxHeight: 200.0,
                    child: Image.memory(_img.buffer.asUint8List())),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        color: Colors.green,
                        onPressed: () async {
                          final sign = _sign.currentState;
                          //retrieve image data, do whatever you want with it (send to server, save locally...)
                          final image = await sign!.getData();
                          var data = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          sign!.clear();
                          final encoded =
                              base64.encode(data!.buffer.asUint8List());
                          setState(() {
                            _img = data;
                          });
                          debugPrint("onPressed " + encoded);
                          },
                        child: Text("Save")),
                    MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          final sign = _sign.currentState;
                          sign!.clear();
                          setState(() {
                            _img = ByteData(0);
                          });
                          debugPrint("cleared");
                        },
                        child: Text("Clear")),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
