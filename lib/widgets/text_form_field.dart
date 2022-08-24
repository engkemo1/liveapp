import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textField({
  TextAlignVertical? alignVertical = TextAlignVertical.top,
  TextAlign textAlign = TextAlign.start,
  required TextInputAction textInputAction,
  required String hint,
  required int maxCharacters,
  required void Function(String)? onSubmit,
  TextEditingController? controller,
}) {
  return TextFormField(
    textAlignVertical: alignVertical,
    textAlign: textAlign,
    controller: controller,
    style: TextStyle(fontSize: 15.0),
    textInputAction: textInputAction,
    onFieldSubmitted: onSubmit,
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxCharacters),
    ],
    decoration: InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
      hintText: hint,
    ),
  );
}
