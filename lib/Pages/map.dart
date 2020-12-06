import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker_app/helper/LOCKERS_data.dart';
import 'package:locker_app/Widget/BottomSheet.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/helper/helper_lists.dart';

class MapView extends StatefulWidget {
  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController controller;
  Position currentPosition;
  String lock;
  Struct locker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor myIcon;

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    print(position);
    currentPosition = position;
  }

  void _currentLocation() async {
    LocationData currentLocation;
    final GoogleMapController _controller = controller;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 12.0,
      ),
    ));
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        icon: myIcon,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(
            title: specify['name'],
            snippet: specify['available locker'].toString()),
        onTap: () {
          print(specifyId);
          setState(() {
            lock = specify['name'].toString();
            for (int i = 0; i < recentList.length; i++) {
              if (recentList[i].title == lock) locker = recentList[i];
            }

            _showBottomSheet();
          });
        });
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    Firestore.instance.collection('Locker').getDocuments().then((myMockDoc) {
      if (myMockDoc.documents.isNotEmpty) {
        for (int i = 0; i < myMockDoc.documents.length; i++) {
          initMarker(
              myMockDoc.documents[i].data, myMockDoc.documents[i].documentID);
        }
      }
    });
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'image/download.png')
        .then((onValue) {
      myIcon = onValue;
    });
    _getCurrentLocation();
    getMarkerData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null)
      currentPosition = new Position(latitude: 19.85, longitude: 75.25);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black.withOpacity(0.6),
              size: 20,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GoogleMap(
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentPosition.latitude, currentPosition.longitude),
                  zoom: 12.0),
              onMapCreated: (GoogleMapController _controller) {
                setState(() {
                  controller = _controller;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28, top: 100, right: 28, bottom: 10),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  title: TextField(
                    enabled: true,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Search for a locker nearby',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            letterSpacing: 0.2)),
                  ),
                  trailing: Icon(
                    Icons.search,
                    size: 27,
                    color: Colors.orange[400],
                  ),
                ),
              ),
            ),
          ),
          Visibility(visible: _visibility, child: DraggableSheet(locker)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _currentLocation,
        label: Text(''),
        isExtended: false,
        splashColor: Colors.transparent,
        icon: Icon(Icons.location_on),
      ),
    );
  }

  bool _visibility = false;
  _showBottomSheet() {
    setState(() {
      if (!_visibility) _visibility = _visibility ? false : true;
    });
  }
}
