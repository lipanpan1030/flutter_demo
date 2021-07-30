import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DrawPictureDemo extends StatefulWidget {
  const DrawPictureDemo({Key? key}) : super(key: key);
  static const String routeName = '/basics/draw_picture';

  @override
  _DrawPictureDemoState createState() => _DrawPictureDemoState();
}

class _DrawPictureDemoState extends State<DrawPictureDemo> {
  bool showPic = false;
  final GlobalKey shareImgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("绘制图片"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              ElevatedButton(onPressed: _onDrawPressed, child: Text("绘制图片")),
              showPic ? RepaintBoundary(
                  key: shareImgKey,
                  child: Image.asset("assets/imgs/img_usage_share_to_bg.png")) : Container()
              // showPic ? CustomPaint(
              //   painter: PicturePainter(),
              // ) : Container()
            ],
          ),
        ),
      ),
    );
  }

  void _onDrawPressed() {
    _capturePng();
  }

  void _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      (shareImgKey.currentContext!.findRenderObject())! as RenderRepaintBoundary;
      var dpr = ui.window.devicePixelRatio;
      var image = await boundary.toImage(pixelRatio: dpr);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      // Directory? documentsDir = await getExternalStorageDirectory();
      // File file = new File('${documentsDir!.path}/share_lipro_use1.png');
      // file.writeAsBytes(pngBytes);

      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 100,
          name: "hello1.png");
      print(result);

    } catch (e) {
      print(e);
    }
  }
}

class PicturePainter extends CustomPainter {
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    print("paint");
    _paint.color = Colors.green;
    _paint.isAntiAlias = true;

    canvas.drawCircle(Offset(100, 100), 50, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw false;
  }
}
