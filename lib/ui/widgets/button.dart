
import 'package:flutter/material.dart';
import 'package:flutter_advanced_testing/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.0,
        height: 45.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: primaryClr,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
