import 'dart:async';
import 'dart:collection';

import 'package:nhts/Model/Geoareascalculate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class landscreen extends StatefulWidget {
  List<Geoareascalculate> polygonLatLngs = [];
  landscreen(this.polygonLatLngs);
  @override
  State<landscreen> createState() => landscreenState();
}

class landscreenState extends State<landscreen> {

  Completer<GoogleMapController>? controller1;

  static LatLng? _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition!;

  Set<Polygon> _polygons = HashSet<Polygon>();
  List<LatLng> polygonLatLngs = [];

  double radius=0;
  int _polygonIdCounter = 1;
  bool _isPolygon = true; //Default
  double EARTH_RADIUS = 6371000;// meters

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  void _setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.yellow.withOpacity(0.15),
    ));
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1!.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget mapButton(VoidCallback? function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const  EdgeInsets.all(7.0),
    );
  }
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        //position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      //print('${placemark[0].name}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? Container(child: Center(child: Text('loading map..',
        style: TextStyle(
            fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),)
          : Container(
        child: Stack(children: <Widget>[
          GoogleMap(
              markers: _markers,
              polygons: _polygons,
              mapType: _currentMapType,
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  controller1!.complete(controller);
                });
              },
              zoomGesturesEnabled: false,
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: false,
              onTap: (point) {
                if (_isPolygon) {
                  setState(() {
                    polygonLatLngs.add(point);
                    _setPolygon();
                  });
                }
              }
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    /*mapButton(onAddMarkerButtonPressed,
                        Icon(
                            Icons.add_location
                        ), Colors.blue),*/
                    mapButton(
                        _onMapTypeButtonPressed,
                        Icon(
                          IconData(0xf473,
                              fontFamily: CupertinoIcons.iconFont,
                              fontPackage: CupertinoIcons.iconFontPackage),
                        ),
                        Colors.green),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}