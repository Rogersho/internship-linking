import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/company/presentation/company_dashboard.dart';
import '../../features/company/presentation/internship_form_screen.dart';
import '../../features/student/presentation/student_home_screen.dart';
import '../../features/student/presentation/internship_detail_screen.dart';
import '../../features/common/domain/models.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/student/home',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.toString();

      // Company routes require authentication
      if (path.startsWith('/company')) {
        if (!isLoggedIn) {
          return '/login';
        }
        // Verify user is actually a company
        final isCompany =
            authRepository.currentUser?.userMetadata?['is_company'] == true;
        if (!isCompany) {
          return '/student/home'; // Redirect students trying to access company routes
        }
      }

      // If logged in and on login/register page, redirect based on role
      if (isLoggedIn && (path == '/login' || path == '/register')) {
        final isCompany =
            authRepository.currentUser?.userMetadata?['is_company'] == true;
        if (isCompany) {
          return '/company/dashboard';
        } else {
          return '/student/home';
        }
      }

      return null; // Allow access to student routes without login
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/student/home',
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/company/dashboard',
        builder: (context, state) => const CompanyDashboard(),
      ),
      GoRoute(
        path: '/company/internship/new',
        builder: (context, state) => const InternshipFormScreen(),
      ),
      GoRoute(
        path: '/student/home',
        builder: (context, state) => const StudentHomeScreen(),
      ),
      GoRoute(
        path: '/student/internship/:id',
        builder: (context, state) {
          final internship = state.extra as Internship;
          return InternshipDetailScreen(internship: internship);
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
