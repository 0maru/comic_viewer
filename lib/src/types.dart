import 'package:flutter/gestures.dart';

///
typedef GestureScaleStartCallback = void Function(ScaleStartDetails details);

///
typedef GestureScaleUpdateCallback = void Function(ScaleUpdateDetails details);

///
typedef GestureScaleEndCallback = void Function(ScaleEndDetails details);

typedef onPageChangeCallback = void Function(int page);

typedef onLastPageCallback = void Function(bool isFirst);