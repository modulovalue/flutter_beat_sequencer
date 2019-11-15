import 'dart:js' as js;

import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Iterable<Widget> modulovalueTitle(String title, String repo) {
  return [
    Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 42.0,
      ),
      textAlign: TextAlign.center,
    ),
    const SizedBox(height: 6.0),
    GestureDetector(
      onTap: () =>
          js.context.callMethod("open", <dynamic>["https://twitter.com/modulovalue"]),
      child: opacity(0.7) > Text(
        "by @modulovalue",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    const SizedBox(height: 4.0),
    GestureDetector(
      onTap: () => js.context
          .callMethod("open", <dynamic>["https://github.com/modulovalue/$repo"]),
      child: opacity(0.7) >Text(
        "GitHub",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
