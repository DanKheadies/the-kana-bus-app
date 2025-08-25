import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final Function()? onTap;

  const InputButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'Enter Input',
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(Icons.text_fields, size: 30),
        onPressed: onTap,
      ),
    );
  }
}
