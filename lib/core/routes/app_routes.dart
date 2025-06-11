import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/features/news/presentation/pages/detail.dart';
import 'package:newsapp/features/news/presentation/pages/home.dart';
import 'package:newsapp/features/news/presentation/pages/search.dart';

class AppRoutes {
  get router => GoRouter(
        initialLocation: "/",
        routes: [
          GoRoute(
            path: "/",
            name: "home",
            pageBuilder: (context, state) => CupertinoPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/detail',
            name: 'detail',
            pageBuilder: (context, state) {
              final url = state.uri.queryParameters['url'] ?? '';
              final title = state.uri.queryParameters['title'] ?? '';
              return CupertinoPage(
                child: NewsDetailPage(url: url, title: title),
              );
            },
          ),
          GoRoute(
            path: "/search",
            name: "search",
            pageBuilder: (context, state) => CupertinoPage(
              child: SearchPage(),
            ),
          ),
        ],
      );
}
