import 'package:delivery_app/src/pages/client/home/client_home_screen.dart';
import 'package:delivery_app/src/pages/pages.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login_screen',
  routes: [
    GoRoute(
      path: '/loading_screen',
      name: 'loading_screen',
      builder: (context, state) => LoadingScreen(),
    ),
    GoRoute(
      path: '/login_screen',
      name: 'login_screen',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/client_home_screen',
      name: 'client_home_screen',
      builder: (context, state) => ClientHomePage(),
    ),
    GoRoute(
      path: '/rol_screen',
      name: 'rol_screen',
      builder: (context, state) => RolScreen(),
    ),
  ],
  redirect: (context, state) {
    final uri = state.uri;
    print('🟡 screen: $uri');
    return null;
  },
);
