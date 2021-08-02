import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class DrawPictureDemo extends StatefulWidget {
  const DrawPictureDemo({Key? key}) : super(key: key);
  static const String routeName = '/basics/draw_picture';

  @override
  _DrawPictureDemoState createState() => _DrawPictureDemoState();
}

class _DrawPictureDemoState extends State<DrawPictureDemo> {
  bool showPic = false;
  final GlobalKey shareImgKey = GlobalKey();

  Uint8List? imageMemory;

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
              // showPic ? RepaintBoundary(
              //     key: shareImgKey,
              //     child: Image.asset("assets/imgs/img_usage_share_to_bg.png")) : Container()
              // showPic ? CustomPaint(
              //   painter: PicturePainter(),
              // ) : Container()
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: imageMemory != null ? Image.memory(imageMemory!) : Text('loading...'),
              ),
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
    // try {
    //   RenderRepaintBoundary boundary =
    //   (shareImgKey.currentContext!.findRenderObject())! as RenderRepaintBoundary;
    //   var dpr = ui.window.devicePixelRatio;
    //   var image = await boundary.toImage(pixelRatio: dpr);
    //   ByteData? byteData =
    //       await image.toByteData(format: ui.ImageByteFormat.png);
    //   Uint8List pngBytes = byteData!.buffer.asUint8List();
    //   // Directory? documentsDir = await getExternalStorageDirectory();
    //   // File file = new File('${documentsDir!.path}/share_lipro_use1.png');
    //   // file.writeAsBytes(pngBytes);
    //
    //   final result = await ImageGallerySaver.saveImage(
    //       Uint8List.fromList(pngBytes),
    //       quality: 100,
    //       name: "hello1.png");
    //   print(result);
    //
    // } catch (e) {
    //   print(e);
    // }

    final ui.PictureRecorder pictureRecorder = new ui.PictureRecorder();
    final canvas = new Canvas(pictureRecorder);

    Paint _linePaint = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true//抗锯齿
      ..strokeCap = StrokeCap.round//线条末端的处理方式
      ..strokeWidth =20.0;

    ///绘制背景图片
    ui.Image images = await getAssetImage("assets/imgs/img_usage_share_to_bg.png");
    // 绘制图片
    canvas.drawImage(images, Offset(0, 0), _linePaint); // 直接画图

    int width = 519 * 3;
    int height = 788 * 3;
    ParagraphBuilder _pb = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left, fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal, maxLines: 1,
        ellipsis: '...', fontSize: 54))
      ..pushStyle(ui.TextStyle(color: Color(0xFF717171)))
      ..addText("Lipro 智能家居");

    ParagraphConstraints pc = ParagraphConstraints(width: 800);
    Paragraph paragraph = _pb.build()..layout(pc);

    canvas.drawParagraph(paragraph, Offset(56 * 3,height - 350));

    ParagraphBuilder _pb1 = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left, fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal, maxLines: 1,
        ellipsis: '...', fontSize: 54))
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText("成 就 美 好 生 活");
    Paragraph paragraph1 = _pb1.build()..layout(pc);

    canvas.drawParagraph(paragraph1, Offset(56 * 3,height - 250));

    // 绘制图片
    ui.Image images1 = await getAssetImage("assets/imgs/img_gray_round_bg.png");
    canvas.drawImage(images1, Offset(56 * 3,height - 150), _linePaint); // 直接画图

    ParagraphBuilder _pb2 = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left, fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal, maxLines: 1,
        ellipsis: '...', fontSize: 33))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText("长按识别二维码");
    Paragraph paragraph2 = _pb2.build()..layout(pc);

    canvas.drawParagraph(paragraph2, Offset(56 * 3 + 10 * 3 ,height - 146));

    // 绘制图片
    ui.Image images2 = await getAssetImage("assets/imgs/img_lipro_wx_qrcode.jpeg", width: 312, height: 312);
    canvas.drawImage(images2, Offset(width - 28 * 3 - 104 * 3 - 2 * 8 * 3, height - 124 * 3), _linePaint); // 直接画图

    //第二个 ui.Image对象 由pictureRecorder结束记录后返回  toImage裁剪图片
    ui.Image picture = await pictureRecorder.endRecording().toImage(width, height);//设置生成图片的宽和高
    //ByteData对象 转成 Uint8List对象 给 Image.memory() 使用来显示
    ByteData? pngImageBytes = await picture.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = pngImageBytes!.buffer.asUint8List();

    Directory documentsDir = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDir.path}/share.png';
    File file = File(filePath);
    await file.writeAsBytes(pngBytes);
    Share.shareFiles([filePath]);

    // final result = await ImageGallerySaver.saveImage(
    //     pngBytes,
    //     quality: 100,
    //     name: new DateTime.now().millisecondsSinceEpoch.toString() + "_share");
    // print(result);
    // if (result["isSuccess"]) {
    //   Share.shareFiles([result["filePath"]]);
    // }
  }

  //返回ui.Image
  Future<ui.Image> getAssetImage(String asset,{width,height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth:width,targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
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
