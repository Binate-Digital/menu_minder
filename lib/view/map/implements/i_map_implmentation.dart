import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class IMap {
  Future<Response<dynamic>?> searchNearbyResult(
      BuildContext context,
      Map<String, dynamic> queryParams,
      Function()? onSuccess,
      Function()? onFailure);

  Future<Response<dynamic>?> getPlaceDetails(
    BuildContext context,
    Map<String, dynamic> queryParams,
  );
}
