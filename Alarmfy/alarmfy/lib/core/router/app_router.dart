import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/add_alarm_screen.dart';
import '../../presentation/screens/stats_screen.dart';
import '../services/navigation_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final navigationService = NavigationService();

  return GoRouter(
    navigatorKey: navigationService.navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-alarm',
        builder: (context, state) => const AddAlarmScreen(),
      ),
      GoRoute(
        path: '/stats',
        builder: (context, state) => const StatsScreen(),
      ),
    ],
  );
}); 