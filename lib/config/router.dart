import 'package:agritechv2/views/calcu/calculator.dart';
import 'package:agritechv2/views/home.dart';
import 'package:agritechv2/views/products/view_product_page.dart';

import 'package:agritechv2/views/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../views/auth/login.dart';
import '../views/auth/signup.dart';
import '../views/products/search_product_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/verification',
        builder: (BuildContext context, GoRouterState state) {
          return const VerificationPage();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'product/:id', 
            builder: (BuildContext context, GoRouterState state) {
              return ViewProductPage(productID: state.pathParameters['id']!);
            },
          ),
          GoRoute(
            path: 'calculator',
            builder: (BuildContext context, GoRouterState state) {
              return const CalulatorPage();
            },
          ),
          GoRoute(
            path: 'search',
            builder: (BuildContext context, GoRouterState state) {
              return const SearchProductPage();
            },
          ),
        ],
        redirect: (BuildContext context, GoRouterState state) {
          final authBloc = context.read<AuthBloc>();
          final authState = authBloc.state;
          print("current state:  $authState");

          final bool matchedLocation = state.matchedLocation == '/login';
          if (authState is UnAthenticatedState) {
            return matchedLocation ? null : '/login';
          }
          if (matchedLocation) {
            if (authState is AuthenticatedButNotVerified) {
              return '/verification';
            } else if (authState is UnAthenticatedState) {
              return '/login';
            } else {
              return '/';
            }
          }
          return null;
        },
      ),
    ],
  );
}
