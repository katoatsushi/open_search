import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:open_search/views/map/modal/uiParts/cardDefault.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyProfileCard extends StatelessWidget {
  MyProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerCards = [
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext newContext) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 40,
                            ),
                          ),
                          Expanded(child: SizedBox())
                        ],
                      ),
                      Text("Hello"),
                      Center(
                        child: QrImageView(
                          data: 'https://kirickp.com',
                          size: 300,
                        ),
                      ),
                    ],
                  ));
            },
          );
        },
        child: Container(
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
      ),
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
              "ID ouqoqOUg19u",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )
    ];
    return CardDefaultPart(title: "友達を追加する", innerCards: innerCards);
  }
}
