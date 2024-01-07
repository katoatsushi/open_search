import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class CardDefaultPart extends StatelessWidget {
  final String title;
  final List<Widget> innerCards;

  CardDefaultPart({Key? key, required this.title, required this.innerCards})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(child: SizedBox())
          ],
        ),
        ...innerCards
      ]),
    );
  }
}
