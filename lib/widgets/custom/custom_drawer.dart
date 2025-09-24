import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus_app/barrel.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              InkWell(
                mouseCursor: SystemMouseCursors.click,
                onTap: () => context.read<BrightnessCubit>().toggleBrightness(),
                child: BlocBuilder<BrightnessCubit, Brightness>(
                  builder: (context, cubit) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 40),
                      height: 225,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Image(
                        image: AssetImage(
                          'assets/images/splash/launch.png',
                          // cubit == Brightness.dark
                          //     ? 'assets/images/bollard-og-teal.png'
                          //     : 'assets/images/ship-teal.png',
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state.authUser != null) ...[
                ListTile(
                  title: Text(
                    'Kana Bus',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => context.goNamed('kanaBus'),
                  hoverColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(30),
                ),
                ListTile(
                  title: Text(
                    'Bus List',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.list,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => context.goNamed('busList'),
                  hoverColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(30),
                ),
                const SizedBox(height: 35),
                ListTile(
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => context.goNamed('profile'),
                  hoverColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(30),
                ),
                const SizedBox(height: 35),
              ],
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ListTile(
                    title: Text(
                      state.authUser != null ? 'Logout' : 'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    leading: Icon(
                      state.authUser != null ? Icons.logout : Icons.login,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap:
                        state.authUser != null
                            ? () {
                              Navigator.pop(context);
                              context.read<AuthBloc>().add(SignOut());
                            }
                            : () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                useSafeArea: false,
                                builder: (context) {
                                  return LoginModal(context: context);
                                },
                              );
                            },

                    hoverColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(30),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Help',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                leading: Icon(
                  Icons.help_outline_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    useSafeArea: false,
                    builder: (context) {
                      return HelpModal(context: context);
                    },
                  );
                },
                hoverColor: Theme.of(context).colorScheme.primary.withAlpha(30),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
