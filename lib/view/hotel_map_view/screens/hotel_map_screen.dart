import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:menu_minder/services/location_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/restraunt_info/data/single_place_detail.dart';

import '../../../providers/map_provider.dart';

class HotelMapScreen extends StatefulWidget {
  const HotelMapScreen({super.key, required this.placeDetail});
  final SinglePlaceDetail placeDetail;

  @override
  State<HotelMapScreen> createState() => _HotelMapScreenState();
}

class _HotelMapScreenState extends State<HotelMapScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  Position? currentPosition;

  Set<Marker>? _markers;
  double distance = 0.0;

  calculateDistance() async {
    currentPosition = await Geolocator.getCurrentPosition();
    LatLng myLocation =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    LatLng destinationLocation = LatLng(
        widget.placeDetail.result!.geometry!.location!.lat!,
        widget.placeDetail.result!.geometry!.location!.lng!);

    double distanceInMeters = await Geolocator.distanceBetween(
      myLocation.latitude,
      myLocation.longitude,
      destinationLocation.latitude,
      destinationLocation.longitude,
    );

    // Draw polyline on the map
    _polylines.add(Polyline(
      polylineId: const PolylineId('route1'),
      points: [myLocation, destinationLocation],
      color: Colors.red,
      patterns: [PatternItem.gap(20), PatternItem.dash(20)],
      width: 2,
    ));

    final myIcon =
        await getBytesFromAsset('assets/icons/location_marker.png', 64);
    // Add markers for starting (current) location and destination location
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('startMarker'),
        position: myLocation,
        infoWindow: const InfoWindow(title: 'Start Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('destinationMarker'),
        position: destinationLocation,
        infoWindow: InfoWindow(title: widget.placeDetail.result?.name),
        icon: BitmapDescriptor.fromBytes(myIcon),
      ),
    };

    Set<Marker> allMarkers = Set.from(markers);

    double minLat = myLocation.latitude < destinationLocation.latitude
        ? myLocation.latitude
        : destinationLocation.latitude;
    double maxLat = myLocation.latitude > destinationLocation.latitude
        ? myLocation.latitude
        : destinationLocation.latitude;
    double minLng = myLocation.longitude < destinationLocation.longitude
        ? myLocation.longitude
        : destinationLocation.longitude;
    double maxLng = myLocation.longitude > destinationLocation.longitude
        ? myLocation.longitude
        : destinationLocation.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    if (_mapController != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
        bounds,
        50, // padding
      ));
      setState(() {
        _markers = allMarkers;
        distance = distanceInMeters;
      });
    }
    // ignore: use_build_context_synchronously
    AppDialog.modalBottomSheet(
        context: context,
        isDismissible: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppStyles.subHeadingStyle(
                    "Distance ${(distanceInMeters / 1000).toStringAsFixed(1)} KM"),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  AssetPath.CAR,
                  scale: 4,
                )
              ],
            ),
            AppStyles.height8SizedBox(),
            AppStyles.contentStyle(widget.placeDetail.result?.name ?? '')
          ],
        ));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setMap();
      calculateDistance();
    });
  }

  String mapStyle = "";
  setMap() async {
    mapStyle =
        await rootBundle.loadString('assets/map_style/custom_map_style.json');
    if (mounted) {
      setState(() {});
    }
  }

  final CameraPosition cameraPosition = CameraPosition(
    target: LatLng(LocationService().currentPosition!.latitude,
        LocationService().currentPosition!.longitude),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppStyles.pinkAppBar(
          context,
          "Hotel Map View",
          trailing: InkWell(
            onTap: () {
              AppDialog.modalBottomSheet(
                  context: context,
                  isDismissible: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppStyles.subHeadingStyle(
                              "Distance ${(distance / 1000).toStringAsFixed(1)} KM"),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            AssetPath.CAR,
                            scale: 4,
                          )
                        ],
                      ),
                      AppStyles.height8SizedBox(),
                      AppStyles.contentStyle(
                          widget.placeDetail.result?.name ?? '')
                    ],
                  ));
            },
            child: Image.asset(
              AssetPath.DIRECTION,
              scale: 2,
            ),
          ),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: cameraPosition,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          markers: _markers ?? {},

          polylines: _polylines,
          // markers: ,
          rotateGesturesEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            controller.setMapStyle(mapStyle);
            // setState(() {});
            // _controller.complete(controller);
            // context.read<MapProvider>().onMapCreate(controller);

            // context.read<MapProvider>().mapController = controller;

            // controller.setMapStyle(mapStyle);
          },
        ));
  }
}
