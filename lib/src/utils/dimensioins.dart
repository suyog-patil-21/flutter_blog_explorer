import 'package:flutter/material.dart';

double getViewportHeight(BuildContext context) {
  final MediaQueryData mediaQuery = MediaQuery.of(context);
  return mediaQuery.size.height -
      mediaQuery.padding.top -
      mediaQuery.padding.bottom;
}

double getViewportWidth(BuildContext context) {
  final MediaQueryData mediaQuery = MediaQuery.of(context);
  return mediaQuery.size.width -
      mediaQuery.padding.left -
      mediaQuery.padding.right;
}
