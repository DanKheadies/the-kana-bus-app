import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      height: 45,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: 'Settings',
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            onPressed: () {
              // TODO: log in
              // TODO: load a list
              // TODO: share a list (?)
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text('Not working yet.')));
            },
          ),
          const SizedBox(),
          const SizedBox(),
          IconButton(
            tooltip: 'Save',
            icon: Icon(
              Icons.save,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            onPressed: () {
              // TODO: save input to a specified list
              // select all to start; can toggle to (de)select all
              // tap to unselect
              // save with a list name
              // N2H: must be logged in (?); will save locally but also in
              // Firebase if logged in
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text('Not working yet.')));
            },
          ),
        ],
      ),
    );
  }
}
