import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:open_search/views/map/modal/uiParts/myProfileCard.dart';
import 'package:open_search/views/map/modal/uiParts/friendsCard.dart';
import 'package:open_search/views/map/modal/uiParts/favoriteCard.dart';
import 'package:open_search/views/map/modal/uiParts/bookmarkCard.dart';

class AccountInfoModal extends StatelessWidget {
  AccountInfoModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 0),
          alignment: Alignment.topLeft,
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(children: [
            Container(
              width: 60,
              height: 8,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
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
                  Text(
                    "ホゲホゲ ふがふが",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://github.com/katoatsushi.png',
                        width: 70.0,
                        height: 70.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            MyProfileCard(),
            FriendsCard(),
            FavoriteCard(),
            BookMarkCard(),
          ]),
        ));
  }
}
