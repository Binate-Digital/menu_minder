import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:menu_minder/services/location_service.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/network_strings.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/map/repository/map_repo.dart';
import 'package:menu_minder/view/restraunt_info/data/restaurant_model.dart';

import 'package:menu_minder/view/restraunt_info/data/single_place_detail.dart';
import 'dart:ui' as ui;

enum LocationState { loading, enabled, disabled, permantlydisabled }

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

class MapProvider extends ChangeNotifier {
  final MapRepo _mapRepo;

  MapProvider(this._mapRepo);
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  LocationState _locationState = LocationState.loading;
  LocationState get getLocationState => _locationState;

  updateLocationState(LocationState locationState) {
    _locationState = locationState;
    notifyListeners();
  }

  RestaurantResultData? currentSelectedRestaurant;
  // final List<Restaurant>

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  bool locationEnabled = false;

  updateLocationStates(bool state) {
    locationEnabled = state;
    notifyListeners();
  }

  List<RestaurantResultData> restaurants = [];
  getNearbyRestaurants(
      BuildContext context, double latitude, double longitude) async {
    final queryParams = {
      'keyword': 'cuisine',
      'radius': 32186,
      'type': 'restaurant',
      'location': '$latitude,$longitude',
      'key': MapConstants.mapKey
    };

    try {
      final res = await _mapRepo.searchNearbyResult(context, queryParams, () {
        ///------------onSuccess---------------\\\\\
      }, () {
        ///---------------onFailure------------\\\\\\
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      });

      final data = NearbyRestaurantModel.fromJson(res?.data);

      if (data.results != null) {
        restaurants = data.results!;
        final myIcon =
            await getBytesFromAsset('assets/icons/location_marker.png', 64);
        restaurants.forEach((element) {
          final marker = Marker(
              onTap: () {
                updateRestaurant(element);
              },
              icon: BitmapDescriptor.fromBytes(myIcon),
              markerId: MarkerId(element.name!),
              position: LatLng(
                element.geometry!.location!.lat!,
                element.geometry!.location!.lng!,
              ),
              infoWindow: InfoWindow(
                title: element.name,
              ));
          _markers.add(marker);
        });
      }

      if (restaurants.isNotEmpty) {
        updateRestaurant(restaurants.first);
      }

      notifyListeners();
      print("Response Done ${data.results!.length}");
    } on DioException catch (e) {}
  }

  initState() {
    _placeLoadState = States.init;
  }

  SinglePlaceDetail? _singlePlaceDetail;
  States _placeLoadState = States.init;

  SinglePlaceDetail? get placeDetail => _singlePlaceDetail;

  States get placeLoadState => _placeLoadState;

  updatePlaceLoadState(States loadState) {
    _placeLoadState = loadState;
    notifyListeners();
  }

  getPlaceDetails(BuildContext context, String placeID) async {
    final queryParams = {'place_id': placeID, 'key': MapConstants.mapKey};

    try {
      updatePlaceLoadState(States.loading);
      final res = await _mapRepo.getPlaceDetails(
        context,
        queryParams,
      );

      _singlePlaceDetail = SinglePlaceDetail.fromJson(res?.data);
      updatePlaceLoadState(States.success);
      // print("Sinfle Place ${_singlePlaceDetail!.result!.name}");
      notifyListeners();
    } on DioException catch (e) {
      updatePlaceLoadState(States.failure);
      initState();
    }
  }

  updateRestaurant(RestaurantResultData restaurantResultData) {
    currentSelectedRestaurant = restaurantResultData;
    notifyListeners();
  }

  checkLocation(BuildContext context) async {
    final currentLocation = await LocationService().getCurrentPosition();
    if (currentLocation != null) {}
  }

  void onMapCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }
}
