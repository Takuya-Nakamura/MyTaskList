import 'package:flutter/material.dart';

class CommonStyle {
  /* form text */

}

class Border {
  static const OutlineInputBorder enableFormBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    ),
  );

  static const OutlineInputBorder focusFormBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
    ),
  );
}

class Thema {
  static final normal = ThemeData.light()
      .copyWith(primaryColor: Colors.blue, accentColor: Colors.red);
}
