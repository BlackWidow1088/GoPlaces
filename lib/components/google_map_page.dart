import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import '../main.dart';
import './data.service.dart';

// TODO: key
const kGoogleApiKey = "GOOGLE_KEY";

GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: kGoogleApiKey);

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => GoogleMapState();
}

class GoogleMapState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId placeMarker = MarkerId("marker_id_place");
  int _markerIdCounter = 1;
  String title = 'Kothrud, Pune';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.5073958, 73.7871019),
    zoom: 14.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text(title,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                fontSize: 13.0,
                fontFamily: 'Roboto',
                color: new Color(0xFF212121),
                fontWeight: FontWeight.bold,
              )),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () async {
            //     // show input autocomplete with selected mode
            //     // then get the Prediction selected
            //     Prediction p = await PlacesAutocomplete.show(
            //         mode: Mode.overlay,
            //         context: context,
            //         apiKey: kGoogleApiKey);
            //     displayPrediction(p, 'origin');
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.navigation),
              onPressed: () async {
                // show input autocomplete with selected mode
                // then get the Prediction selected
                markers.clear();
                Prediction origin = await PlacesAutocomplete.show(
                  hint: 'Origin',
                    mode: Mode.overlay,
                    context: context,
                    apiKey: kGoogleApiKey);
                Prediction destination = await PlacesAutocomplete.show(
                  hint: 'Destination',
                    mode: Mode.overlay,
                    context: context,
                    apiKey: kGoogleApiKey);
                displayPrediction(destination, 'destination');
                displayPrediction(origin, 'origin');
              },
            ),
          ]),
      body: Container(
          color: Colors.white,
          child: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _addPlaceMarker(18.5073958, 73.7871019);
            },
            markers: Set<Marker>.of(markers.values),
          )),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToLocation(),
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToLocation(double lat, double lng) async {
    final _kGooglePlex = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  Future<Null> displayPrediction(Prediction p, String type) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      print('details---------------------------------------');
      print(detail);
      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      setState(() {
        title = detail.result.name;
      });
      _goToLocation(lat, lng);
      _addPlaceMarker(lat, lng);
      if(type == 'origin')
      dataService.origin = detail.result.name;
      else
      dataService.destination = detail.result.name;
    }
  }

  void _addPlaceMarker(double lat, double lng) {
    final int markerCount = markers.length;

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

// TODO: use inheritedwidget to access methods.
  void _onMarkerTapped(MarkerId id) {
    pageController.jumpToPage(1);
  }

  void _removePlaceMarker() {
    if (markers.containsKey(placeMarker))
      setState(() {
        markers.remove(placeMarker);
      });
  }
}
