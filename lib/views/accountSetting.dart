// ログイン画面用Widget
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key? key}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;

    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    print(currentUser);

    if (currentUser?.email == null) {
      return Center(
        child: Text("アカウント読み込み中にエラーが起きました"),
      );
    }
    return Container(
        child: Column(
      children: [
        Row(children: [
          Text("メールアドレス"),
          Expanded(child: SizedBox()),
          Text(currentUser?.email as String),
        ]),
        // Row(children: [
        //   Text("名前"),
        //   Expanded(child: SizedBox()),
        //   Text(currentUser?.displayName),
        // ])
      ],
    ));
  }
}
