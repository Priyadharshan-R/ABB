import 'package:genix_auctions/routes/routes_list.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [...routesList],
);
