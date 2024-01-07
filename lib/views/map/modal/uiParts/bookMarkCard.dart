import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:open_search/views/map/modal/uiParts/cardDefault.dart';

class BookMarkCard extends StatelessWidget {
  BookMarkCard({Key? key}) : super(key: key);

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
    return CardDefaultPart(title: "最近保存した場所", innerCards: innerCards);
  }
}
