// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapController extends GetxController {
  late LatLng selectedLocation;

  final markers = RxSet<Marker>();

  void selectLocation(LatLng location) async {
    selectedLocation = location;

    // Koordinatları kullanarak şehir ve ilçe bilgilerini al
    List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark place = placemarks[0];

    String city = place.locality ?? "";
    String district = place.subLocality ?? "";

    // Seçilen konumu konsola yazdır
    print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
    print("City: $city, District: $district");

    markers.add(Marker(
      markerId: const MarkerId("selected_location"),
      position: location,
      infoWindow: const InfoWindow(title: "Seçilen Konum"),
    ));
  }
}

class MapSample extends StatelessWidget {
  final MapController mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(38.4237, 27.1428),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {},
        onTap: (LatLng location) {
          mapController.selectLocation(location);
        },
        markers: mapController.markers(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showBottomSheet();
        },
        label: const Text('Konumu Seç'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }

  void _showBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: 200,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Konumu Seç'),
              onTap: () {
                Get.back();
                mapController.selectLocation(mapController.selectedLocation);
              },
            ),
          ],
        ),
      ),
    );
  }
}
