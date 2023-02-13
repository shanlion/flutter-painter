import 'package:flutter/material.dart';

//可选的画板颜色
Map<String, Color> pintColor = {
  'default': Color(0xFFB275F5),
  'black': Colors.black,
  'brown': Colors.brown,
  'gray': Colors.grey,
  'blueGrey': Colors.blueGrey,
  'blue': Colors.blue,
  'cyan': Colors.cyan,
  'deepPurple': Colors.deepPurple,
  'orange': Colors.orange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'pink': Colors.pink,
  'teal': Colors.teal,
  'red': Colors.red,
  'purple': Colors.purple,
  'blueAccent': Colors.blueAccent,
  'white': Colors.white,
};

void main() {
  runApp(const MaterialApp(title: '画板',home: SafeArea(child: CanvasPage())));
}

class CanvasPage extends StatefulWidget {
  const CanvasPage({Key? key}): super(key: key);

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  Path path = Path();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('画板')),
      body: Listener(
        // 落下
        onPointerDown: (e) {
          path.moveTo(e.localPosition.dx, e.localPosition.dy);
          setState(() {});
        },
        // 移动
        onPointerMove: (e) {
          path.lineTo(e.localPosition.dx, e.localPosition.dy);
          setState(() {});
        },
        // 离开
        onPointerUp: (e) {
          path.moveTo(e.localPosition.dx, e.localPosition.dy);
          path.close();
          setState(() {});
        },
        child: CustomPaint(
          foregroundPainter: CanvasPaint(path: path),
          child: Container(
            color: Colors.transparent
          )
        )
      ),
    );
  }
}

class CanvasPaint extends CustomPainter {
  Path? path;
  Color? color; // 画笔颜色
  double? width;

  CanvasPaint({required this.path, this.color = Colors.black, this.width = 5});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..color = color!
    ..strokeWidth = width!
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
    print("path: $path");
    canvas.drawPath(path!, paint);
  }

  // 是否需要重新绘制
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // print("oldDelegate: ${other.color}");
    return true;
  }
}