import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final String? label;
  final bool? obscure;
  final List<TextInputFormatter>? formatters;
  final Widget? prefix;
  final TextStyle? errorStyle;
  final String? errorText;
  const CustomTextFormField(
      {Key? key,
      required this.controller,
      this.errorText,
      this.errorStyle,
      this.hint,
      this.label,
      this.prefix,
      this.formatters,
      this.obscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure!,
      controller: controller,
      decoration: InputDecoration(
          errorText: errorText ?? null,
          errorStyle: errorStyle ?? null,
          hintText: hint ?? '',
          labelText: label ?? '',
          prefix: prefix ?? null,
          labelStyle: TextStyle(color: Colors.black),
          focusColor: Colors.black,
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.black))),
      cursorColor: Colors.black,
      inputFormatters: formatters ?? [],
    );
  }
}
