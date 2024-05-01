// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:menu_minder/providers/map_provider.dart';
import 'package:provider/provider.dart';

import '../../../services/location_service.dart';

class MapScreen extends StatefulWidget {
  final bool? absorbPointer;
  final Set<Marker> markers;
  final CameraPosition? inittialPosition;
  const MapScreen({
    Key? key,
    required this.markers,
    this.absorbPointer = true,
    this.inittialPosition,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  final CameraPosition currentPosition = CameraPosition(
    target: LatLng(LocationService().currentPosition!.latitude,
        LocationService().currentPosition!.longitude),
    zoom: 14.4746,
  );
  String mapStyle = "";

  @override
  void initState() {
    setMap();
    super.initState();
  }

  setMap() async {
    mapStyle =
        await rootBundle.loadString('assets/map_style/custom_map_style.json');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Current Latitude ${currentPosition.target.latitude}");
    log("Current Longitude ${currentPosition.target.longitude}");
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: widget.inittialPosition ?? currentPosition,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      markers: widget.markers,
      rotateGesturesEnabled: widget.absorbPointer!,
      zoomGesturesEnabled: widget.absorbPointer!,
      scrollGesturesEnabled: widget.absorbPointer!,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        // _controller.complete(controller);
        context.read<MapProvider>().onMapCreate(controller);

        // context.read<MapProvider>().mapController = controller;

        controller.setMapStyle(mapStyle);
      },
    );
  }
}
