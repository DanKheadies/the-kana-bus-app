import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus_app/barrel.dart';

final GoRouter goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder:
          (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
    ),
    GoRoute(
      path: '/bus-list',
      name: 'busList',
      pageBuilder:
          (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BusListScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
    ),
    GoRoute(
      path: '/kana-bus',
      name: 'kanaBus',
      pageBuilder:
          (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const KanaBusScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder:
          (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
    ),
  ],
  errorPageBuilder:
      (context, state) => CustomTransitionPage(
        key: state.pageKey,
        name: 'error',
        child: const ErrorScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
      ),
  redirect: (context, state) => _redirect(context, state),
);

String _redirect(BuildContext context, GoRouterState state) {
  // print('go to: ${state.uri}');
  return state.uri.toString();
}
