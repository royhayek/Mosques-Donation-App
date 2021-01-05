import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:google_place/google_place.dart';

const kGoogleApiKey = "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw";

// to get places detail (lat/lng)
// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class MosquesScreen extends StatefulWidget {
  @override
  _MosquesScreenState createState() => _MosquesScreenState();
}

// final homeScaffoldKey = GlobalKey<ScaffoldState>();
// final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _MosquesScreenState extends State<MosquesScreen> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    googlePlace = GooglePlace(kGoogleApiKey);
    super.initState();
  }

  // Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'mosques').toUpperCase()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search here...",
                    alignLabelWithHint: false,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      print('we are here');
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.length > 0 && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(predictions[index].description),
                    onTap: () {
                      debugPrint(predictions[index].placeId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsListScreen(
                            placeId: predictions[index].placeId,
                            googlePlace: googlePlace,
                          ),
                        ),
                      );
                    },
                  );
                },
              )
                  // : Center(
                  //     child: Text(
                  //       'Start looking for mosques',
                  //       style: TextStyle(
                  //         fontSize: SizeConfig.safeBlockHorizontal * 5,
                  //       ),
                  //     ),
                  //   ),
                  ),
            ],
          ),
        ),
      ),
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: <Widget>[
      //       RaisedButton(
      //         onPressed: _handlePressButton,
      //         child: Text("Search for Mosque"),
      //       ),
      //       Expanded(
      //         child: ListView(
      //           shrinkWrap: true,
      //           children: [
      //             MosqueListItem(),
      //             MosqueListItem(),
      //             MosqueListItem(),
      //             MosqueListItem(),
      //             MosqueListItem(),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // void onError(PlacesAutocompleteResponse response) {
  //   homeScaffoldKey.currentState.showSnackBar(
  //     SnackBar(content: Text(response.errorMessage)),
  //   );
  // }

  // Future<void> _handlePressButton() async {
  //   // show input autocomplete with selected mode
  //   // then get the Prediction selected
  //   Prediction p = await PlacesAutocomplete.show(
  //     context: context,
  //     apiKey: kGoogleApiKey,
  //     onError: onError,
  //     mode: Mode.fullscreen,
  //     language: "en",
  //     components: [Component(Component.country, "kw")],
  //   );

  //   displayPrediction(p, homeScaffoldKey.currentState);
  // }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    // if (result != null && result.predictions != null && mounted) {
    setState(() {
      predictions = result.predictions;
    });
    print(predictions);
    // }
    setState(() {});
  }
}

// Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
//     final lat = detail.result.geometry.location.lat;
//     final lng = detail.result.geometry.location.lng;
//     final photoReference = detail.result.photos[0].photoReference;
//     print(
//         'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$kGoogleApiKey');
//     scaffold.showSnackBar(
//       SnackBar(content: Text("${p.description} - $lat/$lng")),
//     );
//   }

// }
