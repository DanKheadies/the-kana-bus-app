// TODO: view a list (load this, share this, duplicate this, delete this)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus_app/barrel.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                useSafeArea: false,
                context: context,
                builder: (context) {
                  return ScaffoldMessenger(
                    child: Builder(
                      builder: (context) {
                        return Scaffold(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface.withAlpha(30),
                          body: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: _buildDialog(context),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: Text('Show Help'),
          ),
          const SizedBox(width: double.infinity),
          TextButton(
            onPressed: () => context.goNamed('kanaBus'),
            child: Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
        child: GestureDetector(
          onTap: () {}, // Avoid clicking the modal to dismiss it.
          child: Container(
            width: 450,
            constraints: null,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text('Test.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                    },
                    child: Text(
                      'Contact Support',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(flex: 1),
                  Flexible(
                    flex: 5,
                    child: CustomInput(
                      // clearText: clearInput,
                      initialValue: 'email',
                      isMulti: false,
                      labelText: 'Email',
                      onChanged: (value) {},
                      onEnter: (_) {},
                    ),
                  ),
                  const Spacer(flex: 1),
                  Flexible(
                    flex: 5,
                    child: CustomInput(
                      // clearText: clearInput,
                      isMulti: true,
                      labelText: 'Message',
                      onChanged: (value) {},
                      onEnter: (_) {},
                    ),
                  ),
                  const Spacer(flex: 1),
                  Flexible(
                    flex: 5,
                    child: TextButton(
                      onPressed: null,
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
