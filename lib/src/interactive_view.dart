import 'package:comic_viewer/src/transform_controller.dart';
import 'package:flutter/widgets.dart';

class InteractiveView extends StatefulWidget {
  /// The Widget to perform the transformations on,
  final Widget child;

  ///
  final bool panEnable;

  ///
  final bool scaleEnable;

  ///
  final double maxScale;

  ///
  final double minScale;

  ///
  final GestureScaleStartCallback onInteractionStart;

  ///
  final GestureScaleUpdateCallback onInteractionUpdate;

  ///
  final GestureScaleEndCallback onInteractionEnd;

  ///
  final TransformController transformController;

  ///
  InteractiveView({
    Key key,
    @required this.child,
    this.panEnable = true,
    this.scaleEnable = true,
    this.maxScale = 2.5,
    this.minScale = 0.8,
    this.onInteractionStart,
    this.onInteractionUpdate,
    this.onInteractionEnd,
    this.transformController,
  })  : assert(minScale != null),
        assert(minScale > 0),
        assert(minScale.isFinite),
        assert(maxScale != null),
        assert(maxScale > 0),
        assert(!maxScale.isNaN),
        assert(maxScale >= minScale),
        assert(panEnable != null),
        assert(scaleEnable != null),
        super(key: key);

  @override
  _InteractiveViewState createState() => _InteractiveViewState();
}

class _InteractiveViewState extends State<InteractiveView> with TickerProviderStateMixin {
  final GlobalKey _parentKey = GlobalKey();
  final GlobalKey _childKey = GlobalKey();
  TransformController _transformController;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _transformController = widget.transformController ?? TransformController();
    _transformController.addListener(_onTransformControllerChange);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant InteractiveView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle all cases of needing to dispose and initialize
    // transformationControllers.
    if (oldWidget.transformController == null) {
      if (widget.transformController != null) {
        _transformController.removeListener(_onTransformControllerChange);
        _transformController.dispose();
        _transformController = widget.transformController;
        _transformController.addListener(_onTransformControllerChange);
      }
    } else {
      if (widget.transformController != null) {
        _transformController.removeListener(_onTransformControllerChange);
        _transformController = TransformController();
        _transformController.addListener(_onTransformControllerChange);
      } else if (widget.transformController != oldWidget.transformController) {
        _transformController.removeListener(_onTransformControllerChange);
        _transformController = widget.transformController;
        _transformController.addListener(_onTransformControllerChange);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformController.removeListener(_onTransformControllerChange);
    if (widget.transformController == null) {
      _transformController.dispose();
    }
    super.dispose();
  }

  void _onTransformControllerChange() {}

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: _parentKey,
      onPointerSignal: (event) {
        // Handle mousewheel scroll events.
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (details) {},
        onScaleUpdate: (details) {},
        onScaleEnd: (details) {},
        child: Transform(
          transform: _transformController.value,
          child: KeyedSubtree(
            key: _childKey,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
