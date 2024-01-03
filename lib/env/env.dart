import 'package:envied/envied.dart';

// part 'env.g.dart';
part 'env.g.dart';

// EXECUTE BY 'flutter pub run build_runner build'
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_PLACE_API_KEY', obfuscate: true)
  static String key = _Env.key;
}
