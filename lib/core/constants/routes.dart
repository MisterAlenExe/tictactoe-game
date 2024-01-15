import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const authNamedPage = '/auth';

  static const homeNamedPage = '/home';
  static const homeGameNamedPage = 'game/:uid';

  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      );
}
