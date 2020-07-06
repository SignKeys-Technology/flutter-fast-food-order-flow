import 'package:flutter/material.dart';

class CircleContainer extends Container {
  CircleContainer({
    Key key,
    AlignmentGeometry alignment,
    EdgeInsetsGeometry padding,
    Color color,
    Decoration foregroundDecoration,
    double size,
    BoxConstraints constraints,
    EdgeInsetsGeometry margin,
    Matrix4 transform,
    Widget child,
    Clip clipBehavior = Clip.none,
  }) : super(
            key: key,
            alignment: alignment,
            padding: padding,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            foregroundDecoration: foregroundDecoration,
            width: size,
            height: size,
            constraints: constraints,
            margin: margin,
            transform: transform,
            child: child,
            clipBehavior: clipBehavior);
}