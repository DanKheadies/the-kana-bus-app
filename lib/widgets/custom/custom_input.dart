import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final TextEditingController? cont;
  final bool? clearText;
  final bool? isDisabled;
  final bool? isMulti;
  final bool? obscureText;
  final Function(String)? onChanged;
  final Function(String)? onEnter;

  const CustomInput({
    super.key,
    required this.labelText,
    required this.onChanged,
    required this.onEnter,
    this.clearText = false,
    this.cont,
    this.isDisabled = false,
    this.initialValue,
    this.isMulti = false,
    this.obscureText = false,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void clearText() {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clearText! && controller.text.isNotEmpty) {
      clearText();
    }

    return TextField(
      controller: widget.cont ?? controller,
      readOnly: widget.isDisabled ?? false,
      onChanged: widget.onChanged,
      onSubmitted: widget.onEnter,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
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
      obscureText: widget.obscureText ?? false,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.surface,
      ),
      maxLines: widget.isMulti! ? null : 1,
      minLines: widget.isMulti! ? 3 : 1,
    );
  }
}
