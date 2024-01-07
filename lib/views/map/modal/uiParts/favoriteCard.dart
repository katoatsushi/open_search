import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:open_search/views/map/modal/uiParts/cardDefault.dart';

class FavoriteCard extends StatelessWidget {
  FavoriteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerCards = [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.ios_share),
            SizedBox(width: 5),
            Text(
              "QRコード",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ];
    return CardDefaultPart(title: "最近お気に入りした場所", innerCards: innerCards);
  }
}
