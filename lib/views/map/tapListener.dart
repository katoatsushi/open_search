import 'package:flutter/material.dart';
import 'dart:math';

class MountainPainter extends CustomPainter {
  final double rightFrom;
  final double topFrom;

  MountainPainter({required this.rightFrom, required this.topFrom});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width; // 393.0
    double height = size.height; // 566.0
    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(width, 0)
      // ..quadraticBezierTo(min(50.0, width - rightFrom), height - topFrom, width, height)
      ..quadraticBezierTo(width - rightFrom, height - topFrom, width, height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// map.dart から関数をコピペ。あとで消す
// Future<Uint8List> getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//       targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();

//   // // 画像を円形に切り抜く
//   // final double radius = width / 2;
//   // final paint = Paint()
//   //   ..color = Colors.transparent
//   //   ..blendMode = BlendMode.src
//   //   ..isAntiAlias = true;
//   // final recorder = ui.PictureRecorder();
//   // final canvas = Canvas(recorder,
//   //     Rect.fromCircle(center: Offset(radius, radius), radius: radius));
//   // canvas.drawCircle(Offset(radius, radius), radius, paint);
//   // canvas.drawImage(frameInfo.image, Offset(0, 0), Paint());
//   // final picture = recorder.endRecording();
//   // final img = await picture.toImage(width.toInt(), width.toInt());
//   // final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

//   // // 外周にボーダーを追加する
//   // final paintBorder = Paint()
//   //   ..color = 'red'
//   //   ..style = PaintingStyle.stroke
//   //   ..strokeWidth = 5.0; // ボーダーの太さを設定
//   // final recorderWithBorder = ui.PictureRecorder();
//   // final canvasWithBorder = Canvas(recorderWithBorder,
//   //     Rect.fromCircle(center: Offset(radius, radius), radius: radius));
//   // canvasWithBorder.drawCircle(Offset(radius, radius), radius, paintBorder);
//   // canvasWithBorder.drawImage(frameInfo.image, Offset(0, 0), Paint());
//   // final pictureWithBorder = recorderWithBorder.endRecording();
//   // final imgWithBorder =
//   //     await pictureWithBorder.toImage(width.toInt(), width.toInt());

//   // final byteDataWithBorder =
//   //     await imgWithBorder.toByteData(format: ui.ImageByteFormat.png);

//   ByteData byteData =
//       await fi.image.toByteData(format: ui.ImageByteFormat.png) as ByteData;

//   return byteData.buffer.asUint8List();
// }
