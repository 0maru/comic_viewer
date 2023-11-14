import 'package:flutter/material.dart';

/// [PageView]
class CustomPageView extends StatefulWidget {
  ///
  const CustomPageView({
    required this.builder,
    required this.itemCount,
    required this.controller,
    required this.scrollDirection,
    required this.onPageChanged,
    super.key,
  });

  ///
  final PageController controller;

  ///
  final Widget Function(BuildContext, int) builder;

  ///
  final int itemCount;

  ///
  final ValueChanged<int> onPageChanged;

  ///
  final Axis scrollDirection;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  ///
  int _lastReportedPage = 0;

  ///
  bool isZoomIn = false;

  ///
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _lastReportedPage = widget.controller.initialPage;
    _transformationController = TransformationController()
      ..addListener(() {
        final scale = _transformationController.value.getMaxScaleOnAxis();
        if (scale > 1.0 != isZoomIn) {
          setState(() {
            isZoomIn = scale > 1.0;
          });
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.scrollDirection == Axis.vertical;
    final axisDirection = isVertical ? AxisDirection.down : AxisDirection.left;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0 && notification is ScrollUpdateNotification) {
          final metrics = notification.metrics as PageMetrics;
          final currentPage = metrics.page!.round();
          if (currentPage != _lastReportedPage) {
            _lastReportedPage = currentPage;
            widget.onPageChanged(currentPage);
          }
        }
        return false;
      },
      child: Scrollable(
        axisDirection: axisDirection,
        controller: widget.controller,
        physics: isZoomIn
            ? const NeverScrollableScrollPhysics()
            : isVertical
                ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
                : const PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        viewportBuilder: (context, position) {
          return Viewport(
            axisDirection: axisDirection,
            offset: position,
            slivers: [
              SliverFillViewport(
                delegate: SliverChildBuilderDelegate(
                  (ctx, idx) {
                    return GestureDetector(
                      onDoubleTapDown: (details) {
                        if (isZoomIn) {
                          _transformationController.value = Matrix4.identity();
                          return;
                        }
                        const zoomScale = 3.0;
                        _transformationController.value = Matrix4.identity()
                          ..translate(
                            -(details.localPosition.dx * (zoomScale - 1)),
                            -(details.localPosition.dy * (zoomScale - 1)),
                          )
                          ..scale(zoomScale);
                      },
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: 1,
                        maxScale: 3,
                        child: widget.builder(ctx, idx),
                      ),
                    );
                  },
                  childCount: widget.itemCount,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
