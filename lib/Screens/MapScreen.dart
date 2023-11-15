import 'dart:async';
import 'dart:collection';
import 'package:nhts/Screens/geoplottingfarm.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

//import 'SowingNewScreen.dart';

class MapScreen extends StatefulWidget {
  List<LatLng> polyponsList;

  MapScreen(this.polyponsList);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  String farmhectare = '';

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition? _kGooglePlex;
  var _sides = 3.0;
  var _radius = 100.0;
  var _radians = 0.0;

  CameraPosition? _kLake;
  int _polygonIdCounter = 1;
  List<LatLng> polyganLatlngs = [];
  Set<Polygon> _polygons = HashSet<Polygon>();
  bool maps = false;
  @override
  void initState() {
    _kLake = CameraPosition(
        bearing: widget.polyponsList[0].latitude,
        target: LatLng(
            widget.polyponsList[0].latitude, widget.polyponsList[0].longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    _kGooglePlex = CameraPosition(
      target: LatLng(
          widget.polyponsList[0].latitude, widget.polyponsList[0].longitude),
      zoom: 14.4746,
    );
    polyganLatlngs = widget.polyponsList;
    _setPolygon();
    _goToTheLake();
  }

  void _setPolygon() {
    print("polyponsList_map" + polyganLatlngs.toString());
    for (int i = 0; i < polyganLatlngs.length; i++) {
      print(polyganLatlngs[i].latitude.toString() +
          "  " +
          polyganLatlngs[i].longitude.toString());
    }
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polyganLatlngs,
        strokeWidth: 2,
        strokeColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.25)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: maps
          ? GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.polyponsList[0].latitude,
              widget.polyponsList[0].longitude),
          zoom: 14.4746,
        ),
        polygons: _polygons,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      )
          : CustomPaint(
        painter: ShapePainter(_sides, _radius, _radians, polyganLatlngs),
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _OK,
        label: Text('OK'),
        icon: Icon(Icons.done),
      ),
    );
  }

  Future<void> _OK() async {
    Navigator.pop(context, true); // map

    //Navigator.pop(context); //geoplotting

    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => sowingScreenNew(farmhectare)));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake!));
  }
}

class ShapePainter extends CustomPainter {
  final double sides;
  final double radius;
  final double radians;
  List<LatLng> polyganLatlngs;
  ShapePainter(this.sides, this.radius, this.radians, this.polyganLatlngs);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();

    var angle = (math.pi * 2) / polyganLatlngs.length;

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset startPoint =
    Offset(polyganLatlngs[0].latitude, polyganLatlngs[0].longitude);

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 0; i < polyganLatlngs.length; i++) {
      double x = polyganLatlngs[i].latitude * math.cos(radians + angle * i) +
          center.dx;
      double y = polyganLatlngs[i].longitude * math.sin(radians + angle * i) +
          center.dy;
      print('x ' +
          polyganLatlngs[i].latitude.toString() +
          ' y ' +
          polyganLatlngs[i].longitude.toString());
      path.lineTo(x, y);
      print("path_pathlatitude" + polyganLatlngs[i].latitude.toString());
      print("path_pathlongitude" + polyganLatlngs[i].longitude.toString());
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
