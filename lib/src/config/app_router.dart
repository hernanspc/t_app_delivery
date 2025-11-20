import 'package:delivery_app/src/pages/home/home_screen.dart';
import 'package:delivery_app/src/pages/login/login_screen.dart';
import 'package:go_router/go_router.dart';
import '../pages/loading/loading_screen.dart';

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
      path: '/home_screen',
      name: 'home_screen',
      builder: (context, state) => HomeScreen(),
    ),
  ],
  redirect: (context, state) {
    final uri = state.uri;
    print('🟡 screen: $uri');
    return null;
  },
);
