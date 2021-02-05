import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  final onSaved;
  final validator;
  final hintText;
  var suffixIcon;
  var obsecureText;
  var keyboardType;
  var maxLines;
  var initialValue;

  TextArea({
    this.onSaved,
    this.validator,
    this.hintText,
    this.suffixIcon,
    this.obsecureText,
    this.keyboardType,
    this.maxLines,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      onSaved: onSaved,
      initialValue: initialValue,
      validator: validator,
      obscureText: obsecureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03, vertical: size.width * 0.021),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffbdbdbd), width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade700),
      ),
    );
  }
}
