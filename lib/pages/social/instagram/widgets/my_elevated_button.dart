import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool disable;

  const MyElevatedButton(
      {required this.text,
      required this.onPressed,
      this.disable = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disable ? null : () => onPressed(),
      style: ButtonStyle(
        shadowColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.background),
        enableFeedback: false,
        elevation: WidgetStateProperty.all(15),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.background),
        fixedSize: WidgetStateProperty.all(
          Size.fromWidth(MediaQuery.of(context).size.width * 0.30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
