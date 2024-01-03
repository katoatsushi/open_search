import 'package:firebase_storage/firebase_storage.dart';

class GCSModel {
  final storage = FirebaseStorage.instance;

// Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

  Future<String?> fetchPhotoFromGCS() async {
    try {
      // final storageRef = FirebaseStorage.instance.ref().child("files/uid");
      // final listResult = await storageRef.listAll();
      // Create a reference with an initial file path and name
      // final pathReference = storageRef.child("images/stars.jpg");

      // Create a reference to a file from a Google Cloud Storage URI
      final gsReference =
          FirebaseStorage.instance.refFromURL("gs://icon-img-raw/");
      print(gsReference);
      final fileList = await gsReference.listAll();
      print(fileList);
      for (var prefix in fileList.prefixes) {
        // The prefixes under storageRef.
        // You can call listAll() recursively on them.
        print(prefix);
      }
      for (var item in fileList.items) {
        // The items under storageRef.
        print(item);
      }
      // // Create a reference from an HTTPS URL
      // // Note that in the URL, characters are URL escaped!
      // final httpsReference = FirebaseStorage.instance.refFromURL(
      //     "https://firebasestorage.googleapis.com/b/YOUR_BUCKET/o/images%20stars.jpg");
    } catch (e) {
      print(e);
      // 通信エラーなどの例外ハンドリング
      return null;
    }
  }
}
