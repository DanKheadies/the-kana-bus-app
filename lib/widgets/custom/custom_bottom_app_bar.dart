import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus_app/barrel.dart';

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
            tooltip: 'Menu',
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            onPressed: () {
              // ScaffoldMessenger.of(context)
              //   ..clearSnackBars()
              //   ..showSnackBar(SnackBar(content: Text('Not working yet.')));
              Scaffold.of(context).openEndDrawer();
            },
          ),
          const SizedBox(),
          const SizedBox(),
          IconButton(
            tooltip: 'Save',
            icon: Icon(
              Icons.save,
              color: Theme.of(context).primaryColor.withAlpha(
                context.read<BusmCubit>().state.kanaBusms.isEmpty ? 100 : 255,
              ),
              size: 30,
            ),
            onPressed:
                context.read<BusmCubit>().state.kanaBusms.isEmpty
                    ? null
                    : () {
                      // TODO: save input to a specified list
                      // select all to start; can toggle to (de)select all
                      // tap to unselect
                      // save with a list name
                      // N2H: must be logged in (?); will save locally but also in
                      // Firebase if logged in
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          SnackBar(content: Text('Not working yet.')),
                        );
                    },
          ),
        ],
      ),
    );
  }
}
