import "package:flutter/material.dart";
import "package:genix_auctions/product_page.dart";
import "package:genix_auctions/home_page.dart";
import "package:genix_auctions/login_page.dart";
import "package:genix_auctions/signup_page.dart";
import "package:genix_auctions/successful_page.dart";
import "package:go_router/go_router.dart";

List<RouteBase> routesList = [
  GoRoute(
    path: "/",
    builder: (context, state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: "/home",
    builder: (context, state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: "/auctions",
    builder: (context, state) {
      return const Scaffold();
    },
  ),
  GoRoute(
    path: "/bidding",
    builder: (context, state) {
      return const Scaffold();
    },
  ),
  GoRoute(
    path: "/aboutus",
    builder: (context, state) {
      return const Scaffold();
    },
  ),
  GoRoute(
    path: "/signup",
    builder: (context, state) {
      return SignUpPage();
    },
  ),
  GoRoute(
    path: "/success",
    builder: (context, state) {
      return const SuccessfulPage();
    },
  ),
  GoRoute(
    path: "/login",
    builder: (context, state) {
      return LoginPage();
    },
  ),
  GoRoute(
    path: "/get_started",
    builder: (context, state) {
      return const Scaffold();
    },
  ),
  GoRoute(
    path: "/product/:id",
    builder: (context, state) {
      final String id = state.pathParameters['id']!;
      return CProduct(id: id);
    },
  ),
  // GoRoute(
  //   path: "/",
  //   builder: (context, state) {
  //     return const HomePage();
  //   },
  // ),

  // GoRoute(
  //   path: "/",
  //   builder: (context, state) {
  //     return BlocConsumer<UserSessionBloc, UserSessionState>(
  //       listener: (context, state) {
  //         if (state is UserSessionDisconnetedState) {
  //           context.go('/login');
  //         } else if (state is UserSessionConnetedState) {
  //           context.go('/home');
  //         }
  //       },
  //       builder: (context, state) {
  //         return const Center(child: CircularProgressIndicator());
  //       },
  //     );
  //   },
  // ),
];
