import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

//current Location
  String currentLocationLatitude="";
  String currentLocationLongitude="";
  String address="";

//new location
  String newLocationLatitude="";
  String newLocationLongitude="";
  String newAddress="";


  //get location
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocationLatitude = position.latitude.toStringAsFixed(3);
        log("current Latitude---$currentLocationLatitude");
        currentLocationLongitude = position.longitude.toStringAsFixed(3);
        log("current Longitude---$currentLocationLongitude");

      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          address = placemarks.first.name.toString(); // You can customize the address format as needed
          log("address--$address");
        });
      } else {
        setState(() {
          address = "Address not found";
        });
      }
    } catch (e) {
      setState(() {
        currentLocationLatitude = "Error getting location";
        currentLocationLongitude = "Error getting location";
        address = "Error getting location";
      });
    }
  }

  // get location after 5 minutes

  Future<void> _getLocationAfter5Minutes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        newLocationLatitude = position.latitude.toStringAsFixed(3);
        log("new Latitude---$newLocationLatitude");
        newLocationLongitude = position.longitude.toStringAsFixed(3);
        log("new longitude---$newLocationLongitude");
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          newAddress = placemarks.first.name.toString(); // You can customize the address format as needed
          log("new address---$newAddress");
        });
      } else {
        setState(() {
          newAddress = "Address not found";
        });
      }
      log("Worked inside the method >>");
      if(newLocationLatitude==currentLocationLatitude || newLocationLongitude==currentLocationLongitude){
        log("No Changes in Location ");

        EasyLoading.showToast("No Change");


      }else{
        log(">>>>>>1111");

        EasyLoading.showToast("Location Changed");
        log("Location Changed");
      }



    } catch (e) {
      setState(() {
        newLocationLatitude = "Error getting location";
        newLocationLongitude = "Error getting location";
        newAddress = "Error getting location";
      });
    }
  }

Timer? timer;
  @override
  void initState() {
    super.initState();
    _getLocation();
    timer=Timer.periodic(const Duration(seconds: 10), (Timer t)=>_getLocationAfter5Minutes());
  }

@override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("LAT :$currentLocationLatitude"),
          Text("LNG :$currentLocationLongitude"),
          Text("ADDRESS :$address")

        ],
      ),
    );
  }
}
