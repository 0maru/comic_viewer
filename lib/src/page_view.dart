import 'package:flutter/material.dart';

/// [PageView]
class CustomPageView extends StatefulWidget {
  ///
  const CustomPageView({
    required this.builder,
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
  final ValueChanged<int> onPageChanged;

  ///
  final Axis scrollDirection;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  ///
  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    _lastReportedPage = widget.controller.initialPage;
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
        physics: isVertical
            ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
            : const PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        viewportBuilder: (context, position) {
          return Viewport(
            axisDirection: axisDirection,
            offset: position,
            slivers: [
              SliverFillViewport(
                delegate: SliverChildBuilderDelegate(widget.builder),
              ),
            ],
          );
        },
      ),
    );
  }
}
