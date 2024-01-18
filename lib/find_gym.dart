import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FindGym extends StatefulWidget {
  const FindGym({Key? key}) : super(key: key);
  @override
  _FindGymState createState() => _FindGymState();
}

class _FindGymState extends State<FindGym> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  late Future<LatLng> currentLocationFuture;

  @override
  void initState() {
    super.initState();
    currentLocationFuture = _determinePosition();
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getNearbyGyms(LatLng currentLocation) async {
    final String baseUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    final String apiKey =
        "AIzaSyDxbnWe4KdzM5R-u_2yBAYEWTR7QRvhvXI"; // Replace with your actual API key
    final String request =
        "$baseUrl?key=$apiKey&location=${currentLocation.latitude},${currentLocation.longitude}&radius=1000&type=gym";

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _updateMarkers(data['results']);
    } else {
      throw Exception('Failed to load nearby gyms');
    }
  }

  void _updateMarkers(dynamic gyms) {
    gyms.forEach((gym) {
      final marker = Marker(
        markerId: MarkerId(gym['place_id']),
        position: LatLng(gym['geometry']['location']['lat'],
            gym['geometry']['location']['lng']),
        infoWindow: InfoWindow(
          title: gym['name'],
          snippet: gym['vicinity'],
        ),
      );

      setState(() {
        markers.add(marker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LatLng>(
        future: currentLocationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Fetch nearby gyms when we have the location
          _getNearbyGyms(snapshot.data!);

          // When we have the data, build the map
          return GoogleMap(
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: snapshot.data!,
              zoom: 12.0,
            ),
            markers: markers,
          );
        },
      ),
    );
  }
}
