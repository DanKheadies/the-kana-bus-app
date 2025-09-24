import 'package:flutter/material.dart';

class CustomBlockHeader extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CustomBlockHeader({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text.toUpperCase(),
        style:
            style ??
            Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
