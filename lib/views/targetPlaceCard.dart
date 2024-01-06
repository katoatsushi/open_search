import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:open_search/env/env.dart';

/// Flutter code sample for [Card].

class TargetPlaceCard extends StatefulWidget {
  final SearchResult searchedTarget;
  const TargetPlaceCard({super.key, required this.searchedTarget});

  @override
  State<TargetPlaceCard> createState() => TargetPlaceCardState();
}

class TargetPlaceCardState extends State<TargetPlaceCard> {
  final String apiKey = Env.key;

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
                    Text(widget.searchedTarget.vicinity ?? 'No Description')),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[100],
                      side: const BorderSide(color: Colors.grey, width: 1),
                      onPrimary: Colors.black,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.bookmark_border),
                        SizedBox(width: 5),
                        Text(
                          "保存する",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
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
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
