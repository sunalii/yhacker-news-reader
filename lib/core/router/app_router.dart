import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';
import '../../screens/user_detail_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/user/:username',
      builder: (context, state) {
        final username = state.pathParameters['username']!;
        return UserDetailScreen(username: username);
      },
    ),
  ],
);
