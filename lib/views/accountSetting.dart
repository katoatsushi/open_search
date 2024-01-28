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
    print(currentUser?.displayName);

    if (currentUser?.email == null) {
      return Center(
        child: Text("アカウント読み込み中にエラーが起きました"),
      );
    }
    print(currentUser);
    return SafeArea(
        bottom: false,
        child: Container(
            margin: EdgeInsets.all(40),
            child: Column(
              children: [
                Row(children: [
                  const Text(
                    "メールアドレス",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(currentUser?.email as String),
                ]),
                Row(children: [
                  const Text(
                    "名前",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(currentUser?.displayName as String),
                ]),
                Expanded(child: SizedBox()),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: const Text('ログアウトする'),
                    style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        shape: const StadiumBorder(),
                        side: const BorderSide(color: Colors.green),
                        backgroundColor:
                            Color(int.parse("FFCCFFCC", radix: 16))),
                    onPressed: () async {
                      try {
                        // メール/パスワードでログイン
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signOut();
                        await Navigator.pushReplacementNamed(context, '/login');
                      } catch (e) {
                        // ログインに失敗した場合
                        // setState(() {
                        //   infoText = "ログインに失敗しました：${e.toString()}";
                        // });
                      }
                    },
                  ),
                )
              ],
            )));
  }
}
