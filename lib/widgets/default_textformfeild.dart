import 'package:flutter/material.dart';

import '../global/constants.dart';

class DefaultTextFormField extends StatelessWidget {
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? onChange , onSubmitted;
  final bool? enabled;
  final Widget? suffixIcon , prefixIcon;
  final Color? suffixIconColor , prefixIconColor , fillColor;
  final String? label , hint ;
  final bool? password ;
  final TextInputAction inputAction ;
  final TextInputType inputType ;
  final TextEditingController? controller;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enableBorder;
  final OutlineInputBorder? disableBorder;
  const DefaultTextFormField({
    Key? key,
    required this.validator ,
    required this.inputType ,
    required this.inputAction ,
    this.onChange ,
    this.controller ,
    this.border ,
    this.disableBorder,
    this.enableBorder,
    this.focusedBorder,
    this.onSubmitted ,
    this.password ,
    this.suffixIcon ,
    this.prefixIcon ,
    this.suffixIconColor ,
    this.prefixIconColor ,
    this.fillColor ,
    this.label ,
    this.hint,
    this.onTap,
    this.focusNode,
    this.enabled
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap ,
      validator: validator,
      onChanged: onChange,
      controller: controller,
      keyboardType: inputType ,
      textInputAction: inputAction ,
      onFieldSubmitted: onSubmitted ,
      focusNode: focusNode,
      enabled: enabled ?? true,
      obscureText: password ?? false ,
      decoration: InputDecoration(
        filled: true,
        fillColor: lightFillColor,
        border: border ,
          disabledBorder: disableBorder ?? border,
          enabledBorder: enableBorder ?? border,
          focusedBorder: focusedBorder ?? border,
          suffixIconColor: suffixIconColor ,
          prefixIconColor: prefixIconColor ,
          suffixIcon: suffixIcon ,
          prefixIcon: prefixIcon ,
          labelText: label ,
          hintText: hint ,
      ),
    );
  }
}
