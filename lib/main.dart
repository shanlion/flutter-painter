import 'package:flutter/material.dart';

const colorMap = [Colors.black, Colors.red, Colors.blue, Colors.yellow, Colors.green];

void main() {
  runApp(const MaterialApp(title: '画板', home: SafeArea(child: CanvasPage())));
}

class CanvasPage extends StatefulWidget {
  const CanvasPage({Key? key}) : super(key: key);

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  Path path = Path();
  Color color = Colors.black;

  changeColor(color) {
    setState(() {
      this.color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('画板')),
        body: Column(
          children: [
            Expanded(
                child: Listener(
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
                        foregroundPainter: CanvasPaint(path: path, color: color),
                        child: Container(color: Colors.transparent)))),
            ToolsContainer(onChangeColor: changeColor, color: color)
          ],
        ));
  }
}

class ToolsContainer extends StatefulWidget {
  const ToolsContainer({Key? key, required this.onChangeColor, required this.color}) : super(key: key);
  final Function onChangeColor;
  final Color color;

  @override
  State<ToolsContainer> createState() => _ToolsContainerState();
}

class _ToolsContainerState extends State<ToolsContainer> {
  List<Widget> buildButtonList() {
    List<Widget> lists = [];
    for (var i = 0; i < colorMap.length; i++) {
      lists.add(ColorButton(
        color: colorMap[i],
        onChangeColor: widget.onChangeColor,
      ));
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 10),
      child: Flex(
          direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: buildButtonList()),
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({Key? key, required this.onChangeColor, required this.color}) : super(key: key);

  final Function onChangeColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChangeColor(color);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
    canvas.drawPath(path!, paint);
  }

  // 是否需要重新绘制
  @override
  bool shouldRepaint(covariant CanvasPaint oldDelegate) {
    // return oldDelegate.path != path;
    return true;
  }
}
