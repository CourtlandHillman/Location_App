import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GeolocationApp(),
    );
  }
}

class GeolocationApp extends StatefulWidget {
  const GeolocationApp({super.key});

  @override
  State<GeolocationApp> createState() => _GeolocationAppState();
}

class _GeolocationAppState extends State<GeolocationApp> {
// FIRST OF ALL ADD DEPENDECIES  THAN WE NEED
//ADD PERMISSION IN ANDROID MANIFEST
// first start app
  Position? _currentLocation;
  late bool servisePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";

  Future<Position> _getCurrentLocation() async {
    servisePermission = await Geolocator.isLocationServiceEnabled();
    if (!servisePermission) {
      print("service disable");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCode() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality} , ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //let's start creating ui
    // creating of apps logic

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 245, 234),
      appBar: AppBar(
        title: Text("True Device Location"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 241, 16, 241),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Location Coordinates",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
                "Latitude: ${_currentLocation?.latitude} ; Longtitude = ${_currentLocation?.longitude}"),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "Local Address ",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("${_currentAddress}"),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              
              style: ButtonStyle(
                foregroundColor: 
                MaterialStateProperty.all<Color>( Color.fromARGB(255, 32, 245, 234)),
                backgroundColor: 
                MaterialStateProperty.all<Color>(Color.fromARGB(255, 241, 16, 241)),
              ),
              onPressed: () async {
                //get current locatio
                _currentLocation = await _getCurrentLocation();
                await _getAddressFromCode();
                print("${_currentLocation}");
                print("${_currentAddress}");
              },
              child: Text("Get Location" ),
              
              
            ),
          ],
        ),
      ),
    );
  }
}
