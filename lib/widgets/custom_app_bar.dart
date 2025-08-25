import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus_app/barrel.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Kana Hero'),
      actions: [
        BlocBuilder<BusmCubit, BusmState>(
          builder: (context, state) {
            if (state.kanaBusms.isNotEmpty) {
              return IconButton(
                tooltip: 'Delete',
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<BusmCubit>().clear();
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        IconButton(
          tooltip: 'Info',
          icon: Icon(Icons.info),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return InfoDialog();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
