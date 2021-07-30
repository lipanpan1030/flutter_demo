import 'package:flutter/material.dart';

class PaintSampleDemo extends StatefulWidget {
  const PaintSampleDemo({Key? key}) : super(key: key);
  static const String routeName = '/basics/paint_sample';
  _PaintSampleDemoState createState() => _PaintSampleDemoState();
}

class _PaintSampleDemoState extends State<PaintSampleDemo> {
  List<Offset> _points = <Offset>[];

  late int appBarHeight;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("draw"), toolbarHeight: kToolbarHeight,),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox referenceBox = context.findRenderObject() as RenderBox;
            Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
            _points = List.from(_points)..add(localPosition.translate(0, -MediaQuery.of(context).padding.top - kToolbarHeight));
          });
        },
        onPanEnd: (DragEndDetails details) => _points.add(Offset.zero),
        child: CustomPaint(
          painter: SignaturePainter(_points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);
  final List<Offset> points;
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}
