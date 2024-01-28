import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:open_search/env/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TargetPlaceCard extends StatefulWidget {
  final SearchResult searchedTarget;
  const TargetPlaceCard({super.key, required this.searchedTarget});

  @override
  State<TargetPlaceCard> createState() => TargetPlaceCardState();
}

class TargetPlaceCardState extends State<TargetPlaceCard> {
  final String apiKey = Env.key;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Image getTargetSampleImage() {
    final List<Photo>? photos = widget.searchedTarget.photos;
    if (photos != null) {
      var firstPhotoRef = photos[0].photoReference;
      final String endpoint =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${firstPhotoRef}&key=${apiKey}";
      return Image.network(endpoint);
    }
    return Image.asset('assets/no-image.jpeg');
  }

  Future<void> saveFavorite() async {
    final User? user = auth.currentUser;
    final db =
        FirebaseFirestore.instanceFor(app: Firebase.app(), databaseURL: "main");
    final favoDocRef = db
        .collection('users')
        .doc(user?.uid)
        .collection("favorites")
        .doc(widget.searchedTarget.placeId);
    await favoDocRef.set({
      "businessStatus": widget.searchedTarget.businessStatus ?? "",
      "name": widget.searchedTarget.name!,
      "rating": widget.searchedTarget.rating!,
      "priceLevel": widget.searchedTarget.priceLevel,
      "userRatingsTotal": widget.searchedTarget.userRatingsTotal!,
      "vicinity": widget.searchedTarget.vicinity!,
      "permanentlyClosed": widget.searchedTarget.permanentlyClosed,
      "location": {
        "lat": widget.searchedTarget.geometry?.location?.lat,
        "lng": widget.searchedTarget.geometry?.location?.lng
      }
    });
  }

  Future<void> fetchGetData(String placeId) async {
    final String endpoint =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${widget.searchedTarget.placeId}&key=${apiKey}";
    var url = Uri.parse(endpoint);
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data["result"]["photos"]);
        print(data["result"]["reviews"][-1]);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.96,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                leading: getTargetSampleImage(),
                title: Text(widget.searchedTarget.name ?? 'No Name'),
                subtitle:
                    Text(widget.searchedTarget.vicinity ?? 'No Description'),
                trailing: Text("⭐️ ${widget.searchedTarget.rating}")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // DBに保存する
                      // await saveFavorite()
                      await fetchGetData(widget.searchedTarget.placeId!);
                      // print(widget.searchedTarget);
                      // print(widget.searchedTarget.plusCode);
                      // print(widget.searchedTarget.id);
                      // print(widget.searchedTarget.placeId);
                      // print(widget.searchedTarget.geometry?.location?.lat);
                      // print(widget.searchedTarget.geometry?.location?.lng);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink[400],
                      side: const BorderSide(color: Colors.pink, width: 1),
                      onPrimary: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.favorite_border),
                        SizedBox(width: 5),
                        Text(
                          "お気に入りに登録",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.grey[100],
                //       side: const BorderSide(color: Colors.grey, width: 1),
                //       onPrimary: Colors.black,
                //     ),
                //     child: const Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: <Widget>[
                //         Icon(Icons.bookmark_border),
                //         SizedBox(width: 5),
                //         Text(
                //           "保存する",
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 10),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
