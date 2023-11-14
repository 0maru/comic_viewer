import 'package:flutter/material.dart';

///
const indicatorSize = 104.0;

///
class PageScrollProgressIndicator extends StatelessWidget {
  ///
  const PageScrollProgressIndicator({
    required this.visible,
    required this.currentPage,
    required this.totalPage,
    super.key,
  });

  ///
  final bool visible;

  ///
  final int currentPage;

  ///
  final int totalPage;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Align(
        child: Center(
          child: Container(
            height: indicatorSize,
            width: indicatorSize,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Builder(
                        builder: (context) {
                          return Text(
                            currentPage.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    child: CustomPaint(
                      painter: Line(),
                      child: const SizedBox(
                        width: indicatorSize,
                        height: indicatorSize,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: Text(
                        totalPage.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///
class Line extends CustomPainter {
  ///
  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(65, 25);
    const p2 = Offset(25, 65);
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
