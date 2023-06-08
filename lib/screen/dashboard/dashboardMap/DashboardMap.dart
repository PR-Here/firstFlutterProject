import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyImages.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';
import 'package:interview_prep_flutter/utils/constant/MyString.dart';

import '../../../utils/ApiCall/ApiCall.dart';

class DashBoardMap extends StatefulWidget {
  const DashBoardMap({Key? key}) : super(key: key);

  @override
  State<DashBoardMap> createState() => _DashBoardMapState();
}

class _DashBoardMapState extends State<DashBoardMap> {
  final _searchController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Circle> circles = {};
  num currLatitude = 0;
  num currLongitude = 0;
  bool isMounted = false;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  //Get LocalKing List Api
  getLocalKingListApi(context) async {
    try {
      AppLoader.showLoader(context);
      final getLocalData = await MyLocalStorage().getObject();
      final response = await ApiCall.showLocalKingListApi(currLatitude,
          currLongitude, getLocalData!['token'], 'currentLocation');

      if (response.statusCode == 200) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, jsonDecode(response.body)['status'], 3, Colors.green);
      } else {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, jsonDecode(response.body)['message'], 3, Colors.red);
      }
    } catch (err) {
      AppLoader.hideLoader(context);
      AppLoader.showSnackbar(context, err.toString(), 3, Colors.red);
    }
  }

  //Handle Location Permission here
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions. Please enable from device setting.')));
      return false;
    }
    return true;
  }

  //Animate Google map and circle here after click on current location button
  Future<void> _getCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    if (isMounted) {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        final circle = Circle(
          circleId: const CircleId('circle_id'),
          center: LatLng(position.latitude, position.longitude),
          radius: 5000,
          strokeWidth: 1,
          strokeColor: Colors.black,
          fillColor: Colors.transparent,
        );
        setState(() {
          circles.add(circle);
        });
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 12,
              tilt: 0.0,
            ),
          ),
        );
      }).catchError((e) {
        debugPrint(e);
      });
    }
  }

  // To get Current Latitude and Longitude
  getCurrentLatLng() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      if (isMounted) {
        getLocalKingListApi(context);
        setState(() {
          currLatitude = position.latitude;
          currLongitude = position.longitude;
        });
      }
    });
  }

  @override
  void initState() {
    isMounted = true;
    getCurrentLatLng();
    _handleLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(

        child: Stack(alignment: Alignment.topCenter, children: [
          GoogleMap(
            mapType: MapType.normal,
            compassEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            rotateGesturesEnabled: false,
            buildingsEnabled: false,
            circles: circles,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          //Top bar :- Drawer button, search bar and notification Icon
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:2.0,vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Drawer Button
                  InkWell(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100/2)
                      ),
                      child: Image.asset(MyImages.DRAWER),
                    ),
                  ),
                  //Search bar
                  Container(
                    height: 50,
                    width: width * .65,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100/2)
                    ),
                    child: GooglePlaceAutoCompleteTextField(
                        textEditingController: _searchController,
                        googleAPIKey: MyString.MAP_KEY,
                        inputDecoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black,fontSize: 13),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                            hintText: "Search..."),
                        debounceTime: 600,
                        countries: const ["in", "IN"],
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {
                          print("placeDetails" + prediction.lng.toString());
                        },
                        itmClick: (Prediction prediction) {
                          _searchController.text = prediction.description!;
                          _searchController.selection = TextSelection.fromPosition(
                              TextPosition(offset: prediction.description!.length));
                        }
                        // default 600 ms ,
                        ),
                  ),
                //  Notification Button
                  InkWell(
                    onTap: (){},
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100/2)
                      ),
                      child: Image.asset(MyImages.NOTIFICATION),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //My Current Location Button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0, right: 20.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  _getCurrentPosition();
                },
                child: Image.asset(MyImages.LOCATION),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            width: width * .90,
            child: InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                constraints:
                    BoxConstraints(minHeight: 55, minWidth: width),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(100 / 2)),
                child: const Text(
                  "Tap to click active",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
      ),
      drawer: const Drawer(),
    );
  }
}
