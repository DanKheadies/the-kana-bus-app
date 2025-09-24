import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final bool isWorking;
  final BuildContext context;
  final Function() onTap;
  final String? message;
  final Widget child;

  const CustomModal({
    super.key,
    required this.context,
    required this.isWorking,
    required this.onTap,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          isWorking
              ? () {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        message ?? 'Please wait while we transfer data.',
                      ),
                    ),
                  );
              }
              : onTap,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isWorking ? 150 : 20),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: GestureDetector(
            onTap: () {}, // Avoid clicking the modal to dismiss it.
            child: Container(
              width: isWorking ? null : 450,
              constraints:
                  isWorking ? BoxConstraints.tight(Size(275, 275)) : null,
              padding:
                  isWorking
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isWorking ? 150 : 20),
              ),
              child: Container(
                decoration:
                    isWorking
                        ? BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                        )
                        : BoxDecoration(),
                child: isWorking ? Center(child: child) : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
