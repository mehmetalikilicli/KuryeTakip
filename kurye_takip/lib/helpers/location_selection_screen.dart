// ignore_for_file: invalid_use_of_protected_member, library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Controller
class MapController extends GetxController {
  final markers = RxSet<Marker>();

  void createRandomMarker() {
    markers.add(
      Marker(
        markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
        position: _generateRandomPosition(),
        infoWindow: const InfoWindow(title: "Random Marker"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  LatLng _generateRandomPosition() {
    Random random = Random();
    double lat = 38.0 + random.nextDouble() / 10 + 0.65;
    double lng = 35.0 + random.nextDouble() / 10 + 0.45;

    return LatLng(lat, lng);
  }

  void deleteRandomMarker() {
    Random random = Random();

    if (markers.isNotEmpty) {
      int willDeletedIndex = random.nextInt(markers.length);
      List<Marker> markerList = markers.toList();
      Marker markerToDelete = markerList[willDeletedIndex];
      markers.remove(markerToDelete);
    }
  }
}

//View
class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

double _originLatitude = 38.713902745153604;
double _originLongitude = 35.53200755185114;

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final MapController mapController = Get.put(MapController());
  GoogleMapController? _controller;

  static final CameraPosition _initalCameraPosition = CameraPosition(target: LatLng(_originLatitude, _originLongitude), zoom: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konumunuzu Seçin"),
      ),
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              //mapToolbarEnabled: true,
              markers: mapController.markers.value,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initalCameraPosition,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          ZoomInButton(controller: _controller),
          ZoomOutButton(controller: _controller),
          AddLocationButton(mapController: mapController),
          DeleteLocationButton(mapController: mapController),
        ],
      ),
    );
  }
}

class DeleteLocationButton extends StatelessWidget {
  const DeleteLocationButton({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 320.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          mapController.deleteRandomMarker();
        },
        child: const Icon(Icons.location_off_outlined),
      ),
    );
  }
}

class AddLocationButton extends StatelessWidget {
  const AddLocationButton({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 240.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          mapController.createRandomMarker();
        },
        child: const Icon(Icons.location_on_outlined),
      ),
    );
  }
}

class ZoomOutButton extends StatelessWidget {
  const ZoomOutButton({
    super.key,
    required GoogleMapController? controller,
  }) : _controller = controller;

  final GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 160.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          _controller?.animateCamera(CameraUpdate.zoomOut());
        },
        child: const Icon(Icons.remove),
      ),
    );
  }
}

class ZoomInButton extends StatelessWidget {
  const ZoomInButton({
    super.key,
    required GoogleMapController? controller,
  }) : _controller = controller;

  final GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          _controller?.animateCamera(CameraUpdate.zoomIn());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
