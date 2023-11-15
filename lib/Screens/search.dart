import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/Geoareascalculate.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Model/imageproductsaleModel.dart';
import 'package:nhts/Model/weatherModel.dart';
import 'package:nhts/Model/weatherinfo.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
// import 'package:progress_hud/progress_hud.dart';
//import 'package:record_mp3/record_mp3.dart';
import 'dart:io' show File;

import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../main.dart';
import 'geoplottingfarm.dart';
import 'dart:ui' as ui;
import 'package:email_validator/email_validator.dart';


class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  var db = DatabaseHelper();
  List<DropdownMenuItem> statusItems = [];
  String slctStatus = "",valStatus = "";
  List<UImodel> statuslistUIModel = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
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
              'Beneficiary Search',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Container(
              child: Column(children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(10.0),
                    children: _getListings(context), // <<<<< Note this change for the return type
                  ),
                  flex: 8,
                ),
              ])),
        ),
      ),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];

    listings
        .add(txt_label_mandatory("Search Type", Colors.black, 14.0, false));

    listings.add(singlesearchDropdown(
        itemlist: statusItems,
        selecteditem: slctStatus,
        hint: "Select Type",
        onChanged: (value) {
          setState(() {
            slctStatus = value!;
            valStatus = value;
          });
        },
        onClear: () {
          setState(() {
            slctStatus = '';
            valStatus = '';
          });
        }));




    return listings;
  }

  @override
  void initState() {
    super.initState();
    initvalues();
  }
  Future<void> initvalues() async {
    List cropstagelist = await db.RawQuery(
        'select distinct regNo,comNam from exporter');
    print('cropstagelist ' + cropstagelist.toString());
    statuslistUIModel = [];

    statusItems.clear();
    for (int i = 0; i < cropstagelist.length; i++) {
      String property_value = cropstagelist[i]["regNo"].toString();
      String DISP_SEQ = cropstagelist[i]["comNam"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      statuslistUIModel.add(uimodel);
      setState(() {
        statusItems.add(DropdownMenuItem(
          child: Text(DISP_SEQ),
          value: property_value,
        ));
      });
    }
  }
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
}
