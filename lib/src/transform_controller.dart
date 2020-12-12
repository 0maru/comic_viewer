import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class TransformController extends ValueNotifier<Matrix4> {
  TransformController([Matrix4 value]) : super(value ?? Matrix4.identity());
}
