import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/profile/practitioners_profile_screen.dart';
import 'package:makhosi_app/ui_components/app_status_components.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/utils/app_keys.dart';
import 'package:makhosi_app/utils/app_toast.dart';
import 'package:makhosi_app/utils/navigation_controller.dart';
import 'package:makhosi_app/utils/others.dart';
import 'package:makhosi_app/main_ui/business_card/businessCard.dart';

class NearbyPractitionersTab extends StatefulWidget {
  @override
  _NearbyPractitionersTabState createState() => _NearbyPractitionersTabState();
}

class _NearbyPractitionersTabState extends State<NearbyPractitionersTab> {
  List<dynamic> _practitioners = null;
  String _userCity, _mapStyle;
  bool _isLoading = true;
  static CameraPosition _initialCameraPosition;
  GoogleMapController _controller;
  Set<Marker> _markers = Set();
  var _customMarker;
  String _error;

  @override
  void initState() {
    _practitioners=new List();


  _getLocation();
    super.initState();
  }

  Future<void> _getLocation() async {
    try {
      Location location = Location();
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus == PermissionStatus.denied) {
          return;
        }
      }
      LocationData locationData = await location.getLocation();
      _initialCameraPosition = CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: 10,
      );
      List<Address> addressList = await Geocoder.local
          .findAddressesFromCoordinates(
              Coordinates(locationData.latitude, locationData.longitude));
      if (addressList.isNotEmpty) {
        _userCity = addressList[0].subAdminArea;
        await _loadMapStyle();
        _getPractitioners();
      } else {
        await Future.delayed(
          Duration(seconds: 1),
        );
        _getLocation();
      }
    } catch (exc) {
      setState(() {
        _isLoading = false;
        _error = 'Error accessing your location, please try again later';
      });
    }
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.txt');
    _customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          size: Size(32, 32),
        ),
        'images/location_marker.png');
  }

  Future<void> _getPractitioners() async {

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(AppKeys.PRACTITIONERS)
          .where(AppKeys.PRACTICE_CITY, isEqualTo: _userCity)
          .get();
      if (snapshot.size == 0) {
        setState(() {
          _isLoading = false;
          AppToast.showToast(message: 'No practitioner found in your area');
        });
      } else {
        snapshot.docs.forEach((doc) {
          _practitioners.add(doc.data());
          Marker marker = Marker(
            markerId: MarkerId(doc.id),
            icon: _customMarker,
            infoWindow: InfoWindow(
                title:
                    '${doc[AppKeys.FIRST_NAME]} ${doc[AppKeys.LAST_NAME]}'),
            position: LatLng(
              doc[AppKeys.COORDINATES][AppKeys.LATITUDE],
              doc[AppKeys.COORDINATES][AppKeys.LONGITUDE],
            ),
          );
          _markers.add(marker);
        });
        setState(() {
          _isLoading = false;
        });
      }
    } catch (exc) {
      if (mounted)
        setState(() {
          _isLoading = false;
          AppToast.showToast(message: exc.toString());
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? AppStatusComponents.loadingContainer(AppColors.COLOR_PRIMARY)
        : _error != null
            ? AppStatusComponents.errorBody(message: _error)
            : _practitioners.isEmpty
                ? AppStatusComponents.errorBody(
                    message: 'No practitioner in your area')
                : _getBody();
  }

  Widget _getBody() {
    return Stack(
      children: [
        GoogleMap(
          markers: _markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            _controller.setMapStyle(_mapStyle);
          },
        ),
        _getPractitionersList(),
        _practitioners.isNotEmpty ? _getPractitionersCount() : Container(),
      ],
    );
  }

  Widget _getPractitionersCount() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 120,
        width: 150,
        margin: EdgeInsets.only(left: 16, top: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      _practitioners.length.toString(),
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Others.getSizedBox(boxHeight: 0, boxWidth: 8),
                    Text(
                      '${_practitioners.length == 1 ? 'Practitioner' : 'Practitioners'}\nFound',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Others.getSizedBox(boxHeight: 8, boxWidth: 0),
                Text(
                  'Around You',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPractitionersList() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _practitioners.map((practitionerDoc) {
            return _getPractitionerRow(practitionerDoc);
          }).toList(),
        ),
      ),
    );
  }

  Widget _getPractitionerRow(dynamic snapshot) {
    bool isOnline=false;
    if(snapshot[AppKeys.ONLINE]!=null) {
      isOnline= snapshot[AppKeys.ONLINE];
    }
    String name =
        '${snapshot[AppKeys.FIRST_NAME]} ${snapshot[AppKeys.SECOND_NAME]}';
    if (name.length > 30) {
      name = '${name.substring(0, 27)}...';
    }
    return Container(
      padding: EdgeInsets.all(16),
      width: 250,
      margin: EdgeInsets.only(bottom: 32),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  snapshot[AppKeys.PROFILE_IMAGE] != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(snapshot[AppKeys.PROFILE_IMAGE]),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            color: Colors.black12,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                  Others.getSizedBox(boxHeight: 0, boxWidth: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              Others.getSizedBox(boxHeight: 12, boxWidth: 0),
              Row(
                children: [
                  Others.getSizedBox(boxHeight: 0, boxWidth: 8),
                  GestureDetector(
                    onTap: () {
                      //TODO: take user to chat screen
                    },
                    child: Icon(
                      Icons.mail_outline,
                      color: Colors.blue,
                    ),
                  ),
                  Others.getSizedBox(boxHeight: 0, boxWidth: 8),
                  SizedBox(
                    width: 100,
                    height: 25,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      color: AppColors.COLOR_PRIMARY,
                      onPressed: () {
                        NavigationController.push(
                          context,
                          BusinessCard(),
                        );
                      },
                      child: Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Others.getSizedBox(boxHeight: 8, boxWidth: 0),
              Row(
                children: [
                  Others.getSizedBox(boxHeight: 0, boxWidth: 8),
                  Icon(
                    Icons.brightness_1,
                    color: isOnline ? Colors.green : Colors.red,
                    size: 12,
                  ),
                  Others.getSizedBox(boxHeight: 0, boxWidth: 4),
                  Text(isOnline ? 'Online' : 'Offline'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
