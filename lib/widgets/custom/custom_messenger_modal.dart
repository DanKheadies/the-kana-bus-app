import 'package:flutter/material.dart';

class CustomMessengerModal extends StatelessWidget {
  final BuildContext context;
  final Widget child;

  const CustomMessengerModal({
    super.key,
    required this.context,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withAlpha(30),
            body: child,
          );
        },
      ),
    );
  }
}
