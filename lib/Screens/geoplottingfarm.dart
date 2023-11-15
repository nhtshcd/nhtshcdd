import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nhts/Model/GeoAreacalculateFarm.dart';
import 'package:nhts/Model/GeoPloattingModel.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../main.dart';
import 'MapScreen.dart';

List<GeoPloattingModel> Geoploattingfarmlist = [];
List<GeoPloattingModel> GeoploattingBlockArealist = [];
List<GeoPloattingModel> GeoploattingBlockMenuArealist = [];
List<GeoareascalculateFarm> Geoareascalculatefarm = [];
List<GeoareascalculateFarm> Geoareascalculatefarmcrop = [];
List<GeoareascalculateFarm> GeoareascalculateBlockArea = [];
GeoareascalculateFarm? Farmdata;
GeoareascalculateFarm? Blockdata;
GeoareascalculateFarm? blockMenuAreaData;
bool intermediateonlick = false;
bool endonclick = false;
bool startClick = false;
bool calculatearea = false;
bool intialend = false;
bool editlatlng = false;
bool deletelatlng = false;
bool areacalculatesuccess = false;

class geoploattingFarm extends StatefulWidget {
  int type;

  geoploattingFarm(this.type);
  @override
  geoploattingScreen createState() => geoploattingScreen();
}

class geoploattingScreen extends State<geoploattingFarm> {
  @override
  void initState() {
    super.initState();

    //geoareascalculatefarm.clear();

    intermediateonlick = false;
    endonclick = false;
    startClick = false;
    calculatearea = false;
    areacalculatesuccess = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String Hectare = '';

  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

  Future<bool> _onBackPressed() async {
    return (await Alert(
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
        ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _onBackPressed();
                  });
                }),
            title: Text(
              'Area Calculation',
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
//              Tab(icon: Icon(Icons.directions_car), text: "Car",),
                Tab(
                  text: "Manual Mode GPS",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Manualmodegps(widget.type),
            ],
          ),
        ),
      ),
    ));
  }
}

class Manualmodegps extends StatelessWidget {
  int type;

  Manualmodegps(this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ManualmodegpsTabBar(type),
      ),
    );
  }
}

class ManualmodegpsTabBar extends StatefulWidget {
  int type;

  ManualmodegpsTabBar(this.type);
  @override
  _ManualmodegpsTabBarState createState() => _ManualmodegpsTabBarState(type);
}

class _ManualmodegpsTabBarState extends State<ManualmodegpsTabBar> {
  String Lat = '0', Lng = '0';
  List<GeoPloattingModel> geoploattingfarmlist = [];
  List<GeoareascalculateFarm> geoareascalculatefarm = [];
  GeoareascalculateFarm? farmdata;
  //List<Geoareascalculate> objarealist = List<Geoareascalculate>();
  bool visibilityTag = false;
  bool visibilityareaTag = false;
  int orderofGps = 0;
  int onpressCount = 0;
  int intermediatelistcount = 0;

  List<LatLng> polygonLatLngs = [];
  List<LatLng> streamLocation = [];
  int type;
  String formatAcre = "", formatHectare = "", formatSquare = "";

  _ManualmodegpsTabBarState(this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    GetStreamLocation();
  }

  Widget _showForm() {
    return new Container(
        child: new Form(
      child: new ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          showLabelwidget(),
          showStartButton(),
          showIntermediateButton(),
          showEndButton(),
          showCalulateareaButton(),
          showanotherLabelwidget(),
          showareaTable(),
          showButtons(context),
          showTable(geoploattingfarmlist),
        ],
      ),
    ));
  }

  Widget showLabelwidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
      child: new Text(
        "Calculate Area",
        style: new TextStyle(
            color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget showStartButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            child: new Text('Start',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              setState(() {
                // if (geoploattingfarmlist.length > 0) {
                //  for (int i = 0; i < geoploattingfarmlist.length; i++) {
                // String State = geoploattingfarmlist[i].State;
                if (endonclick || startClick) {
                  // showAlertDialog(context, State);
                  clearLocationAlert(context);
                } else {
                  int orderofgps = orderofGps + 1;
                  orderofGps = orderofgps;
                  visibilityTag = true;
                  getLocation("Start", orderofGps);
                  startClick = true;
                }
                // }
                // }

                // else {
                //   int orderofgps = orderofGps + 1;
                //   orderofGps = orderofgps;
                //   visibilityTag = true;
                //   getLocation("Start", orderofGps);
                //   startClick = true;
                //   print("Start22" + orderofGps.toString());
                // }
              });
            },
          ),
        ));
  }

  Widget showIntermediateButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.blue,
              child: new Text('Intermediate ',
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () async {
                setState(() {
                  int intermediatelist = 0;
                  intermediateonlick = true;

                  if (!endonclick) {
                    if (!intermediateonlick) {
                      int orderofgps = orderofGps + 1;
                      orderofGps = orderofgps;
                      intermediateonlick = true;
                    } else {
                      int ordergps = orderofGps + 1;
                      orderofGps = ordergps;
                    }
                    if (startClick) {
                      print("intermediate33");
                      visibilityTag = true;
                      getLocation("Intermediate", orderofGps);
                    } else {
                      errordialog(context, "Information",
                          "Please Initiate Using 'Start' button and then Proceed for Intermediate points");
                    }
                  }
                  if (endonclick) {
                    errordialog(context, "Information",
                        "Please Initiate Using 'Start' button and then Proceed for Intermediate points");
                  }
                });
              }),
        ));
  }

  Widget showEndButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            child: new Text('End',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              setState(() {
                if (startClick == true && intermediateonlick == true) {
                  int incrementonpresscount = onpressCount + 1;
                  onpressCount++;
                  if (geoploattingfarmlist.length > 0) {
                    if (!endonclick) {
                      Endcalculation(context);
                    }
                  } else {
                    visibilityTag = true;
                  }
                  /* if (incrementonpresscount == 1) {
                    Endcalculation(context);
                  } else if (incrementonpresscount > 1) {
                    visibilityTag = true;
                  }*/
                } else {
                  errordialog(context, "Information",
                      "Please Initiate Using 'intermediate' button and then Proceed for End points");
                  //Endalert(context);
                }
              });
            },
          ),
        ));
  }

  Widget showCalulateareaButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            child: new Text('Calulate Area',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              print("Calulate area clicked");
              calculatearea = true;

              setState(() {
                if (startClick == true &&
                    intermediateonlick == true &&
                    endonclick == true) {
                  confirmcalculateareapopup(context);
                } else {
                  start_endpopup(context);
                }
              });
            },
          ),
        ));
  }

  Widget showanotherLabelwidget() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
        child: new Text(
          "Calculated Area:",
          style: new TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ));
  }

  Widget showButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        // this will take space as minimum as posible(to center)
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new MaterialButton(
              height: 40.0,
              minWidth: 70.0,
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text("SUBMIT"),
              onPressed: () {
                if (calculatearea == false) {
                  print("calculatearea1");
                  calculateareapopup(context);
                } else if (calculatearea == true &&
                    startClick == true &&
                    endonclick == true &&
                    intermediateonlick == true) {
                  confirmcalculatearea(context);
                  // Navigator.pop(context, farmdata.Hectare);
                  print("calculatearea2");
                }
              },
              splashColor: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.green,
              textColor: Colors.white,
              child: new Text("CANCEL"),
              onPressed: () {
                confirmationPopup(context);
                /* setState(() {
                  intermediateonlick = false;
                  endonclick = false;
                  startClick = false;
                  orderofGps = 0;
                  onpressCount = 0;
                  geoploattingfarmlist.clear();
                });
                clearList();*/
              },
              splashColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  confirmationPopup(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc: "Are you sure want to cancel? ",
        buttons: [
          DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.green,
          )
        ]).show();
  }

  GetStreamLocation() {
    print('positionStream started');
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      streamLocation.add(LatLng(position!.latitude, position.longitude));
      print('positionStream ' + position.toString() == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  getLocation(String State, int OrderofGps) async {
    print("getLocationFunction");
    /*Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );*/

    LatLng? position1 = streamLocation!.last!;

    print("latitude_A:" +
        position1.latitude.toString() +
        " longitude_B" +
        position1.longitude.toString());
    setState(() {
      Lat = position1.latitude.toString();
      Lng = position1.longitude.toString();
      addListItems(Lat, Lng, State, OrderofGps);
    });
  }

  clearLocationAlert(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc:
            "Previously captured location(s) will be removed .Do you want to proceed?",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                geoploattingfarmlist.clear();
                intermediateonlick = false;
                endonclick = false;
                orderofGps = 0;
                onpressCount = 0;
                Navigator.pop(dialogContext);
                getLocation("Start", orderofGps);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  Endcalculation(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc: "Do you Want to end and proceed to Area calculation?",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
                int orderofgps = orderofGps + 1;
                orderofGps = orderofgps;
                getLocation("End", orderofGps);
                setState(() {
                  endonclick = true;
                });
                calculateAreaUsingCoordinates();
                //}
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                onpressCount = 0;
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  confirmcalculateareapopup(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Area Calculated Successfully \n Calculated Area : \n" +
            farmdata!.Acre +
            " " +
            "Acre(s)",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
                areacalculatesuccess = true;
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  confirmcalculatearea(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Do you want to confirm the calculated Area ?",
        buttons: [
          DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () async {
              // setState(() async {
              Navigator.pop(context);
              bool returnedMap = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MapScreen(polygonLatLngs)));
              if (returnedMap) {
                switch (type) {
                  case 1:
                    Geoploattingfarmlist = geoploattingfarmlist;
                    Farmdata = farmdata;
                    break;
                  case 2:
                    GeoploattingBlockArealist = geoploattingfarmlist;
                    Blockdata = farmdata;
                    break;
                  case 3:
                    GeoploattingBlockMenuArealist = geoploattingfarmlist;
                    blockMenuAreaData = farmdata;
                    break;
                }
                Navigator.pop(context, returnedMap);
              }
              // });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  doyouwantConfirmarea(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc: "Do yoy want to confirm the Calculated area",
        buttons: [
          DialogButton(
            child: Text(
              "yes",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  calculateareapopup(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc: "Calculated area should not be Empty or Zero",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  start_endpopup(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc:
            "Please mark the Coordinates for all 3 Stages ( Start, Intermediate, End)",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  // showAlertDialog(BuildContext context, String text) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context, false);
  //     },
  //   );
  //   Widget continueButton = FlatButton(
  //     child: Text("Ok"),
  //     onPressed: () {
  //       Navigator.pop(context, false);
  //       geoploattingfarmlist.removeWhere((item) => item.State == text);
  //       visibilityTag = true;
  //       getLocation(text, orderofGps);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Geo Ploat"),
  //     content: Text("Would you like to reset $text yes or no"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  Widget showTable(List<GeoPloattingModel> geoploattingfarmlist) {
    return visibilityTag
        ? SizedBox(
            child: Container(
                child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
            child: new SizedBox(
                height: 300,
                child: new Column(children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new Expanded(
                          child: Container(
                              //padding: EdgeInsets.all(4.0),
                              margin: const EdgeInsets.only(
                                left: 15.0,
                                right: 0.0,
                                top: 10.0,
                              ),
                              //width: 100.0,
                              child: Text(
                                "State",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "Latitude",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "Longitude",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "Edit/ delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: geoploattingfarmlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ObjectKey(geoploattingfarmlist[index]),
                            background: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerStart,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              var item = geoploattingfarmlist.elementAt(index);
                              //To delete
                              deleteItem(index);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Item deleted"),
                                  action: SnackBarAction(
                                      label: "UNDO",
                                      onPressed: () {
                                        //To undo deletion
                                        undoDeletion(index, item);
                                      })));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              // this will take space as minimum as posible(to center)
                              children: <Widget>[
                                geoploattingfarmlist[index].State ==
                                        "Intermediate"
                                    ? new Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 0.0,
                                            top: 10.0,
                                          ),
                                          child: Text(
                                            geoploattingfarmlist[index].State +
                                                index.toString(),
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        flex: 2,
                                      )
                                    : new Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 0.0,
                                            top: 10.0,
                                          ),
                                          child: Text(
                                            geoploattingfarmlist[index].State,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      geoploattingfarmlist[index].Latitude,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      geoploattingfarmlist[index].Longitude,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 2,
                                ),

                                Expanded(
                                  child: Container(
                                    child: IconButton(
                                      icon: Icon(Icons.border_color,
                                          color: Colors.black26),
                                      onPressed: () {
                                        setState(() {
                                          editlatlngpopup(context, index);

                                          // getLocation("", orderofGps);
                                        });
                                      },
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  flex: 1,
                                ),

                                geoploattingfarmlist[index].State != "Start" &&
                                        geoploattingfarmlist[index].State !=
                                            "End"
                                    ? Expanded(
                                        child: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.black26),
                                            onPressed: () {
                                              latlngdelete(context, index);
                                            },
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        flex: 1,
                                      )
                                    : Expanded(
                                        child: Container(),
                                        flex: 1,
                                      ),
                                // new Expanded(
                                //   child: Container(
                                //     margin: const EdgeInsets.only(
                                //       left: 15.0,
                                //       right: 0.0,
                                //       top: 10.0,
                                //     ),
                                //     child: Text(
                                //       geoploattingfarmlist[index]
                                //           .orderofGps
                                //           .toString(),
                                //       style: TextStyle(fontSize: 18),
                                //     ),
                                //   ),
                                //   flex: 1,
                                // )
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                ])),
          )))
        : new Container();
  }

  intermediateAlert(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title:
            "Please Initiate Using 'Start' button and then Proceed for intermediate points",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  Endalert(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title:
            "Please Initiate Using 'intermediate' button and then Proceed for End points",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  editlatlngpopup(dialogContext, int index) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Are you sure want to edit the GPS value",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              print("indexindex" + index.toString());
              setState(() {
                Navigator.pop(dialogContext);
                if (geoploattingfarmlist[index].State == "Start") {
                  geoploattingfarmlist
                      .removeWhere((item) => item.State == "Start");
                  visibilityTag = true;
                  getLocation("Start", orderofGps);
                } else if (geoploattingfarmlist[index].State ==
                    "Intermediate") {
                  /*  geoploattingfarmlist
                      .removeWhere((item) => item.State == "Intermediate");*/
                  geoploattingfarmlist.removeAt(index);
                  visibilityTag = true;
                  getLocation("Intermediate", orderofGps);
                } else if (geoploattingfarmlist[index].State == "End") {
                  geoploattingfarmlist
                      .removeWhere((item) => item.State == "End");
                  visibilityTag = true;
                  getLocation("End", orderofGps);
                }
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  latlngdelete(dialogContext, int index) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Are you sure want to Delete ?",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                //  deletelatlng = true;
                Navigator.pop(dialogContext);
                geoploattingfarmlist.removeAt(index);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  addListItems(String Lat, String Lng, String State, int OrderofGps) async {
    setState(() {
      GeoPloattingModel data;
      //data = new GeoPloattingModel(Lat, Lng, State);
      data = new GeoPloattingModel(Lat, Lng, State, OrderofGps);
      polygonLatLngs.add(LatLng(double.parse(Lat), double.parse(Lng)));
      print("polygonLatLngs1245" + Lat.toString());
      print("polygonLatLngs1234" + Lng.toString());
      geoploattingfarmlist.add(data);
      print("objlocateListCHECK111 " + geoploattingfarmlist.length.toString());
      print("polygonLatLngs1111 " + polygonLatLngs.toString());
    });
  }

  clearList() {
    setState(() {
      geoploattingfarmlist.clear();
      visibilityTag = false;
      visibilityareaTag = false;
    });
  }

  void undoDeletion(int index, GeoPloattingModel item) {
    setState(() {
      geoploattingfarmlist.insert(index, item);
      visibilityTag = false;
      //_isVisible = false;
      if (geoploattingfarmlist.length > 0) {
        visibilityTag = true;
        //   _isVisible = true;
      }
    });
  }

  void deleteItem(int index) {
    setState(() {
      geoploattingfarmlist.removeAt(index);
      visibilityTag = false;
      // _isVisible = false;
      if (geoploattingfarmlist.length > 0) {
        visibilityTag = true;
        //  _isVisible = true;
      }
    });
  }

  // calculateYSegment(latitudeRef, latitude, circumference) {
  //   var value = double.parse(latitude) -
  //       double.parse(latitudeRef) * circumference / 360.0;
  //   return value;
  // }

  // calculateXSegment(longitudeRef, longitude, latitude, circumference) {
  //   return double.parse(longitude) -
  //       double.parse(longitudeRef) *
  //           circumference *
  //           cos(0.017453292519943295769236907684886 *
  //               (double.parse(latitude))) /
  //           360.0;
  // }

  // calculateAreaInSquareMeters(x1, x2, y1, y2) {
  //   return ((y1 * x2) - (x1 * y2)) / 2;
  // }

  void calculateAreaUsingCoordinates() {
    var latit = geoploattingfarmlist[0].Latitude;
    var longit = geoploattingfarmlist[0].Longitude;

    var intText = "";

    for (var j = geoploattingfarmlist.length - 2; j >= 1; j--) {
      print("decrementlistvalue");
      latit = geoploattingfarmlist[j].Latitude;
      longit = geoploattingfarmlist[j].Longitude;
      intText = intText + " " + latit + "," + longit;
    }
    //$("#interLoc").text("Intermediate:"+intText);

    latit = geoploattingfarmlist[geoploattingfarmlist.length - 1].Latitude;
    longit = geoploattingfarmlist[geoploattingfarmlist.length - 1].Longitude;

    print("latit_latit" + latit.toString());
    print("longit_longit" + longit.toString());

    var radius = 6378137;
    var diameter = radius * 2;

    var circumference = diameter * pi;
    print("circumference12" + circumference.toString());
    List<double> listY = [];
    List<double> listX = [];
    List<double> listArea = [];

    var latitudeRef = geoploattingfarmlist[0].Latitude;
    var longitudeRef = geoploattingfarmlist[0].Longitude;

    print("longitudeRef12" + longitudeRef);
    print("latitudeRef12" + latitudeRef);

    for (var i = 1; i < geoploattingfarmlist.length; i++) {
      print("geoploattingfarmlist_location");
      var latitude = geoploattingfarmlist[i].Latitude;
      var longitude = geoploattingfarmlist[i].Longitude;

      print("latitude_list" + latitude);
      print("longitude_list" + latitude);

      var value = (double.parse(latitude) - double.parse(latitudeRef)) *
          circumference /
          360.0;
      print("geoploattingfarmlist_lat_value" + value.toString());
      var vY = value;
      print("vY_vY_value" + vY.toString());

      listY.add(vY);

      print("double.parse(longitude)" + longitude);
      print("double.parse(longitude)" + longitudeRef);

      var valuevX = (double.parse(longitude) - double.parse(longitudeRef)) *
          circumference *
          cos(0.017453292519943295769236907684886 * (double.parse(latitude))) /
          360.0;
      print("valuevX_valuevX" + valuevX.toString());

      var vX = valuevX;
      listX.add(vX);
    }
    for (var j = 1; j < listX.length; j++) {
      print("Xlistvalue");
      var x1 = listX[j - 1];
      var y1 = listY[j - 1];

      var x2 = listX[j];
      var y2 = listY[j];

      var areavalue = ((y1 * x2) - (x1 * y2)) / 2;
      print("areavalue_areavalue" + areavalue.toString());
      var area = areavalue;
      print("area_area" + area.toString());
      listArea.add(area);
    }
    // sum areas of all triangle segments
    var areasSum = 0.0;
    for (var i = 0; i < listArea.length; i++) {
      print("areasumcalculation");
      var areaCal = listArea[i];
      areasSum = areasSum + areaCal;
      print("CHECKVALUE_areasSum" + areasSum.toString());
    }
    var msqr = areasSum;
    areasSum = (msqr * 0.000247104393);
    print("CHECKVALUE_areasSum_msqr" + areasSum.toString());

    areasSum = areasSum.abs();
    print("CHECKVALUE_areasSum_abs" + areasSum.toString());

    var sqftArea = (areasSum / 0.00024711);
    var hectAcre = areasSum / 2.4711;

    var detHect = ChangeDecimalThree(areasSum.toString());

    var areaFarmCalc = areasSum;
    var sqftAreaCalc = sqftArea;
    var hectareVal = hectAcre;
    var sqftdetHectCalc = detHect;

    print("sqftAreaCalc_sqftAreaCalc" + sqftAreaCalc.toString());
    print("hectareVal_hectareVal" + hectareVal.toString());
    print("sqftdetHectCalc_sqftdetHectCalc" + sqftdetHectCalc.toString());

    addAreaItems(sqftdetHectCalc.toString(), hectareVal.toString(),
        sqftAreaCalc.toString());
  }

  // void calculateAreaUsingCoordinates() {
  //   print("calculateareafunction");
  //   var latit = geoploattingfarmlist[0].Latitude;
  //   var longit = geoploattingfarmlist[0].Longitude;
  //
  //   print("zeropostionlat" + latit.toString());
  //   print("zeropostionlng" + longit.toString());
  //
  //   var intText = "";
  //   //$("#startLoc").text("Start:"+latit+","+longit);
  //   for (var j = geoploattingfarmlist.length - 2; j >= 1; j--) {
  //     latit = geoploattingfarmlist[j].Latitude;
  //     longit = geoploattingfarmlist[j].Longitude;
  //     intText = intText + " " + latit + "," + longit;
  //   }
  //   //$("#interLoc").text("Intermediate:"+intText);
  //
  //   latit = geoploattingfarmlist[geoploattingfarmlist.length - 1].Latitude;
  //   longit = geoploattingfarmlist[geoploattingfarmlist.length - 1].Longitude;
  //   //$("#endLoc").text("End:"+latit+","+longit);
  //   var radius = 6378137;
  //   var diameter = radius * 2;
  //   //alert("Diameter:" + diameter);
  //   var circumference = diameter * pi;
  //   //alert("circumference:" + circumference);
  //   List<double> listY = List<double>();
  //   List<double> listX = List<double>();
  //   List<double> listArea = List<double>();
  //   /* var listY = new Array();
  //   var listX = new Array();
  //   var listArea = new Array();*/
  //   var latitudeRef = geoploattingfarmlist[0].Latitude;
  //   var longitudeRef = geoploattingfarmlist[0].Longitude;
  //
  //   for (var i = 1; i < geoploattingfarmlist.length; i++) {
  //     var latitude = geoploattingfarmlist[i].Latitude;
  //     var longitude = geoploattingfarmlist[i].Longitude;
  //     var vY = calculateYSegment(latitudeRef, latitude, circumference);
  //
  //     print("latitude_forloop" + latitude);
  //     print("longitude_forloop" + longitude);
  //     print("longitude_vY_vY" + vY);
  //
  //     /* listY.push({
  //       'vY' : vY
  //     });*/
  //
  //     /*var listYMap = {
  //       'vY': vY,
  //     };
  //     listY.add(listYMap);*/
  //     listY.add(vY);
  //
  //     var vX =
  //         calculateXSegment(longitudeRef, longitude, latitude, circumference);
  //     print("longitude_vX_vX" + vX);
  //
  //     /*listX.push({
  //       'vX' : vX
  //     });
  //   }*/
  //     /* var listXMap = {
  //       'vX': vX,
  //     };
  //     listX.add(listXMap);*/
  //     listX.add(vX);
  //   }
  //
  //   for (var j = 1; j < listX.length; j++) {
  //     print("listXXXXX");
  //     var x1 = listX[j - 1];
  //     var y1 = listY[j - 1];
  //
  //     var x2 = listX[j];
  //     var y2 = listY[j];
  //
  //     var area = calculateAreaInSquareMeters(x1, x2, y1, y2);
  //     print("CHECKVALUE_Area" + area.toString());
  //
  //     /* listArea.push({
  //       'area' : area
  //     });*/
  //     /* var listareaMap = {
  //         'area': area,
  //       };
  //       listArea.add(listareaMap);*/
  //     listArea.add(area);
  //   }
  //
  //   // sum areas of all triangle segments
  //   var areasSum = 0.0;
  //   for (var i = 0; i < listArea.length; i++) {
  //     print("listArea_listArea");
  //     var areaCal = listArea[i];
  //     print("areaCal_areaCal" + areaCal.toString());
  //     areasSum = areasSum + areaCal;
  //     print("AcregeoplottingAreasum" + areasSum.toString());
  //   }
  //   var msqr = areasSum;
  //   areasSum = (msqr * 0.000247104393);
  //
  //   areasSum = areasSum.abs();
  //   print("AcregeoplottingSum" + areasSum.toString());
  //
  //   var sqftArea = (areasSum / 0.00024711); // square
  //   var hectAcre = areasSum / 2.4711; // hec
  //   var detHect = areasSum.toStringAsFixed(2);
  //
  //   print("Area_area_area" + sqftArea.toString());
  //   print("hectAcre_hectAcre_hectAcre" + hectAcre.toString());
  //   var areaFarmCalc = areasSum;
  //   var sqftAreaCalc = sqftArea;
  //   var hectareVal = hectAcre;
  //   var sqftdetHectCalc = detHect;
  //   geoareascalculatefarm.clear();
  //
  //   addAreaItems(sqftdetHectCalc.toString(), hectareVal.toString(),
  //       sqftAreaCalc.toString());
  // }

  addAreaItems(String Acrea, String Hectare, String Squaremeter) async {
    setState(() {
      visibilityareaTag = true;
      geoareascalculatefarm.clear();
      farmdata = new GeoareascalculateFarm(Acrea, Hectare, Squaremeter);
      geoareascalculatefarm.add(farmdata!);

      setState(() {
        String totalAcre = farmdata!.Acre;
        double num1 = double.parse((totalAcre));
        formatAcre = num1.toStringAsFixed(3).toString();

        String totalHectare = farmdata!.Hectare;
        double num2 = double.parse((totalHectare));
        formatHectare = num2.toStringAsFixed(3).toString();

        String totalSquare = farmdata!.Squaremeters;
        double num3 = double.parse((totalSquare));
        formatSquare = num3.toStringAsFixed(3).toString();
      });
      print("formatAcre_formatAcre" + formatAcre.toString());
    });
  }

  Widget showareaTable() {
    return areacalculatesuccess
        ? SizedBox(
            child: Container(
                child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: new SizedBox(
                height: 100,
                child: new Column(children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new Expanded(
                          child: Container(
                              //padding: EdgeInsets.all(4.0),
                              margin: const EdgeInsets.only(
                                left: 15.0,
                                right: 0.0,
                                top: 10.0,
                              ),
                              //width: 100.0,
                              child: Text(
                                "Acre",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 0.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "Hectare(s)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "Square Meters",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    // ignore: missing_required_param
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ObjectKey("1"),
                            background: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerStart,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              // this will take space as minimum as posible(to center)
                              children: <Widget>[
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      formatAcre,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      formatHectare,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      formatSquare,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                ])),
          )))
        : new Container();
  }
}

// class Mapmodule extends StatefulWidget {
//   @override
//   State<Mapmodule> createState() => MapmoduleState();
// }
//
// class MapmoduleState extends State<Mapmodule> {
//   Completer<GoogleMapController> controller1;
//
//   static LatLng _initialPosition;
//   final Set<Marker> _markers = {};
//   static LatLng _lastMapPosition = _initialPosition;
//
//   Set<Polygon> _polygons = HashSet<Polygon>();
//   List<LatLng> polygonLatLngs = List<LatLng>();
//
//   double radius;
//   int _polygonIdCounter = 1;
//   int _circleIdCounter = 1;
//   int _markerIdCounter = 1;
//   bool _isPolygon = true; //Default
//   double EARTH_RADIUS = 6371000; // meters
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//     geoploattingfarmlist.clear();
//     geoareascalculatefarm.clear();
//     intermediateonlick = false;
//     endonclick = false;
//     startClick = false;
//     calculatearea = false;
//   }
//
//   void _setPolygon() {
//     final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
//     _polygons.add(Polygon(
//       polygonId: PolygonId(polygonIdVal),
//       points: polygonLatLngs,
//       strokeWidth: 2,
//       strokeColor: Colors.blue,
//       fillColor: Colors.yellow.withOpacity(0.15),
//     ));
//   }
//
//   void _getUserLocation() async {
//     Position position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     List<Placemark> placemark = await Geolocator()
//         .placemarkFromCoordinates(position.latitude, position.longitude);
//     setState(() {
//       _initialPosition = LatLng(position.latitude, position.longitude);
//       print('${placemark[0].name}');
//     });
//   }
//
//   _onMapCreated(GoogleMapController controller) {
//     setState(() {
//       controller1.complete(controller);
//     });
//   }
//
//   MapType _currentMapType = MapType.normal;
//
//   void _onMapTypeButtonPressed() {
//     setState(() {
//       _currentMapType = _currentMapType == MapType.normal
//           ? MapType.satellite
//           : MapType.normal;
//     });
//   }
//
//   _onCameraMove(CameraPosition position) {
//     _lastMapPosition = position.target;
//   }
//
//   Widget mapButton(Function function, Icon icon, Color color) {
//     return RawMaterialButton(
//       onPressed: function,
//       child: icon,
//       shape: new CircleBorder(),
//       elevation: 2.0,
//       fillColor: color,
//       padding: const EdgeInsets.all(7.0),
//     );
//   }
//
//   Future<bool> _onBackPressed() {
//     return Alert(
//           context: context,
//           type: AlertType.warning,
//           title: "Cancel",
//           desc: "Are you sure want to cancel?",
//           buttons: [
//             DialogButton(
//               child: Text(
//                 "Yes",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               width: 120,
//             ),
//             DialogButton(
//               child: Text(
//                 "No",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               width: 120,
//             )
//           ],
//         ).show() ??
//         false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Scaffold(
//         body: _initialPosition == null
//             ? Container(
//                 child: Center(
//                   child: Text(
//                     'loading map..',
//                     style: TextStyle(
//                         fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
//                   ),
//                 ),
//               )
//             : Container(
//                 child: Stack(children: <Widget>[
//                   GoogleMap(
//                       markers: _markers,
//                       polygons: _polygons,
//                       mapType: _currentMapType,
//                       initialCameraPosition: CameraPosition(
//                         target: _initialPosition,
//                         zoom: 14.4746,
//                       ),
//                       onMapCreated: (GoogleMapController controller) {
//                         setState(() {
//                           controller1.complete(controller);
//                         });
//                       },
//                       zoomGesturesEnabled: false,
//                       onCameraMove: _onCameraMove,
//                       myLocationEnabled: true,
//                       compassEnabled: true,
//                       myLocationButtonEnabled: false,
//                       onTap: (point) {
//                         if (_isPolygon) {
//                           setState(() {
//                             polygonLatLngs.add(point);
//                             _setPolygon();
//                             calculatemapAreaUsingCoordinates();
//                           });
//                         }
//                       }),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                         margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
//                         child: Column(
//                           children: <Widget>[
//                             /*mapButton(onAddMarkerButtonPressed,
//                           Icon(
//                               Icons.add_location
//                           ), Colors.blue),*/
//                             mapButton(_onMapTypeButtonPressed,
//                                 Icon(Icons.location_on), Colors.green),
//                           ],
//                         )),
//                   )
//                 ]),
//               ),
//       ),
//     );
//   }
//
//   void calculatemapAreaUsingCoordinates() {
//     var latit = polygonLatLngs[0].latitude;
//     var longit = polygonLatLngs[0].longitude;
//     var intText = "";
//
//     //$("#startLoc").text("Start:"+latit+","+longit);
//     for (var j = polygonLatLngs.length - 2; j >= 1; j--) {
//       latit = polygonLatLngs[j].latitude;
//       longit = polygonLatLngs[j].longitude;
//       intText = intText + " " + latit.toString() + "," + longit.toString();
//       print("CHECKSUMMMM " + intText);
//     }
//     //$("#interLoc").text("Intermediate:"+intText);
//
//     latit = polygonLatLngs[polygonLatLngs.length - 1].latitude;
//     longit = polygonLatLngs[polygonLatLngs.length - 1].longitude;
//     //$("#endLoc").text("End:"+latit+","+longit);
//     var radius = 6378137;
//     var diameter = radius * 2;
//     //alert("Diameter:" + diameter);
//     var circumference = diameter * pi;
//     //alert("circumference:" + circumference);
//     List<double> listY = List<double>();
//     List<double> listX = List<double>();
//     List<double> listArea = List<double>();
//     //List listArea = [];
//     /* var listY = new Array();
//     var listX = new Array();
//     var listArea = new Array();*/
//     var latitudeRef = polygonLatLngs[0].latitude;
//     var longitudeRef = polygonLatLngs[0].longitude;
//
//     for (var i = 1; i < polygonLatLngs.length; i++) {
//       var latitude = polygonLatLngs[i].latitude;
//       //alert("latitude:" + latitude);
//       var longitude = polygonLatLngs[i].longitude;
//       //  var latitudeRef = polygonLatLngs[i].latitude;
//       // var longitudeRef = polygonLatLngs[0].longitude;
//
//       var vY = calculateYSegment(latitudeRef, latitude, circumference);
//
//       listY.add(vY);
//
//       var vX =
//           calculateXSegment(longitudeRef, longitude, latitude, circumference);
//
//       listX.add(vX);
//
//       for (int j = 1; j < listX.length; j++) {
//         var x1 = listX[j - 1];
//         var y1 = listY[j - 1];
//
//         var x2 = listX[j];
//         var y2 = listY[j];
//
//         var area = calculateAreaInSquareMeters(x1, x2, y1, y2);
//         print("CHECKAREAAAAA " + area.toString());
//         listArea.add(area);
//       }
//
//       // sum areas of all triangle segments
//       var areasSum = 0.0;
//       for (var i = 0; i < listArea.length; i++) {
//         var areaCal = listArea[i];
//         areasSum = areasSum + areaCal;
//       }
//       var msqr = areasSum;
//       areasSum = (msqr * 0.000247104393);
//
//       areasSum = areasSum.abs();
//
//       var sqftArea = (areasSum / 0.00024711);
//       var hectAcre = areasSum / 2.4711;
//       var detHect = areasSum.toStringAsFixed(2);
//
//       var areaFarmCalc = areasSum;
//       var sqftAreaCalc = sqftArea;
//       var hectareVal = hectAcre;
//       var sqftdetHectCalc = detHect;
//
//       print("CHECKSUMS " +
//           areaFarmCalc.toString() +
//           " " +
//           sqftAreaCalc.toString() +
//           " " +
//           sqftdetHectCalc.toString() +
//           " " +
//           hectareVal.toString());
//       Fluttertoast.showToast(
//         msg: "Area " + hectareVal.toString(),
//         toastLength: Toast.LENGTH_LONG,
//       );
//       //  var detHectVal = detHect;
//     }
//   }
//
//   calculateYSegment(latitudeRef, latitude, circumference) {
//     return (latitude - latitudeRef) * circumference / 360.0;
//   }
//
//   calculateXSegment(longitudeRef, longitude, latitude, circumference) {
//     /* var value = (longitude) - (longitudeRef) * circumference *
//      cos(0.017453292519943295769236907684886 * (latitude)) / 360.0;
//      print("CHECKOBJECTValue "+value.toString());*/
//     return (longitude) -
//         (longitudeRef) *
//             circumference *
//             cos(0.017453292519943295769236907684886 * (latitude)) /
//             360.0;
//   }
//
//   calculateAreaInSquareMeters(x1, x2, y1, y2) {
//     var value = ((y1 * x2) - (x1 * y2)) / 2;
//     print("CHECKMAPAREAA " + value.toString());
//     return value;
//   }
// }
