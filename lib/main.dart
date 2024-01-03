import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/index.dart';
import 'views/login.dart';
import 'firebase_options.dart';

void main() async {
  // 初期化処理を追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String initialRoute;

  @override
  void initState() {
    super.initState();
    print(_auth.currentUser);
    if (_auth.currentUser != null) {
      initialRoute = '/map';
    } else {
      initialRoute = '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenSearch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/map':
            return MaterialPageRoute(builder: (context) => IndexPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          default:
            return MaterialPageRoute(builder: (context) => LoginPage());
        }
      },
    );
  }
}
