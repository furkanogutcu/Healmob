import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color backColor;

  const TextFieldContainer({
    Key? key,
    required this.child,
    this.backColor = appPrimaryLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: backColor, borderRadius: BorderRadius.circular(29)),
      child: child,
    );
  }
}
