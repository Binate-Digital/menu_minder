import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/services/network/dio_client.dart';
import 'package:menu_minder/view/map/implements/i_map_implmentation.dart';

class MapRepo implements IMap {
  @override
  Future<Response?> searchNearbyResult(
          BuildContext context,
          Map<String, dynamic> queryParams,
          Function()? onSuccess,
          Function()? onFailure) async =>
      DioClient().getMapRequest(
          context: context,
          onSuccess: onSuccess,
          onFailure: onFailure,
          queryParameters: queryParams,
          endPoint:
              "https://maps.googleapis.com/maps/api/place/nearbysearch/json");

  @override
  Future<Response?> getPlaceDetails(
          BuildContext context, Map<String, dynamic> queryParams) async =>
      DioClient().getMapRequest(
          context: context,
          queryParameters: queryParams,
          endPoint: "https://maps.googleapis.com/maps/api/place/details/json");
}
