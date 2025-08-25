import 'package:flutter/material.dart';

class BusmPane extends StatelessWidget {
  final bool? isDisabled;
  final Color textColor;
  final FocusNode? focusInput;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String label;
  final TextEditingController controller;

  const BusmPane({
    super.key,
    required this.label,
    required this.onChanged,
    required this.controller,
    required this.onEditingComplete,
    required this.onSubmitted,
    required this.textColor,
    this.focusInput,
    this.isDisabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      focusNode: focusInput,
      readOnly: isDisabled!,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 2),
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
    );
  }
}
