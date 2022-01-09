import 'package:flutter/material.dart';
import 'package:healmob/components/text_field_container.dart';
import 'package:healmob/constants.dart';

class RoundedFormInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Color backColor;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  const RoundedFormInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.backColor = appPrimaryColor,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: backColor,
            ),
            hintText: hintText,
            border: InputBorder.none),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}