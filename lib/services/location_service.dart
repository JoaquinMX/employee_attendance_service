import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
class LocationService {
  Location location = Location();
  late LocationData _locData;

  Future<Map<String,double?>?> initializeAndGetLocation(BuildContext context) async {
    bool servicedEnabled;
    PermissionStatus permissionGranted;

    //Check if location is enabled on the device.
    servicedEnabled = await location.serviceEnabled();
    if (!servicedEnabled) {
      servicedEnabled = await location.requestService();
      if (!servicedEnabled) {
        Utils.showSnackBar("Please Enable Location Service", context);
        return null;
      }
    }
    // Ask for permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Utils.showSnackBar("Please Allow Location Access", context);
      }
    }
    //Permission is granted
    _locData = await location.getLocation();
    return {
      'latitude': _locData.latitude,
      'longitude': _locData.longitude
    };
  }
}