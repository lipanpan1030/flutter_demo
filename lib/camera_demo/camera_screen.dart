import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;

  CameraScreen(this.cameras);

  @override
  CameraScreenState createState() {
    return new CameraScreenState();
  }
}

class CameraScreenState extends State<CameraScreen> {
  late final CameraController controller;

  @override
  void initState() {
    super.initState();
    if (widget.cameras!.length > 0) {
      controller =
          new CameraController(widget.cameras![0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: controller.value.aspectRatio / deviceRatio,
      child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Container(
              color: Colors.black,
              child: Center(child: new CameraPreview(controller)))),
    );
  }
}
