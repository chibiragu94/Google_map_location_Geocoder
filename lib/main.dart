import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Get Current Location'),
        icon: Icon(Icons.where_to_vote_sharp)
      ),
    );
  }


  Future<void> _goToTheLake() async {

    Position currentLocationPosition = await _determinePosition().catchError((e) => {
      log('Error : $e')
    });

    LatLng pinPosition = LatLng(currentLocationPosition.latitude, currentLocationPosition.longitude);

    String address = await _getAddressFromPosition(currentLocationPosition);
    log('Address : $address');

    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId('<MARKER_ID>'),
              position: pinPosition,
              infoWindow: InfoWindow(title: 'Address $address'),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Addess : $address",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 14.0
                );
              },
              icon: BitmapDescriptor.defaultMarker,

          )
      );
    });

    CameraPosition cameraPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(currentLocationPosition.latitude, currentLocationPosition.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


  }

  /// Get the address by location
  Future<String> _getAddressFromPosition(Position position) async {
    String address;
    final coordinates = new Coordinates(
        position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, '
        '${first.subAdminArea},${first.addressLine}, ${first.featureName},'
        '${first.thoroughfare}, ${first.subThoroughfare}');
    address = first.addressLine;
    return address;
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
