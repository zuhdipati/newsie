import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/configs/adapter/adapter_conf.dart';
import 'package:newsapp/core/themes/app_theme.dart';
import 'package:newsapp/core/routes/app_routes.dart';
import 'package:newsapp/features/news/presentation/bloc/news-bloc/news_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/search-news-bloc/search_news_bloc.dart';
import 'package:newsapp/configs/injector/injector_conf.dart';
import 'package:newsapp/observer.dart';

void main() async {
  await Hive.initFlutter();
  configureAdapter();
  await configureInjector();

  Bloc.observer = AppObserver();
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<NewsBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<SearchNewsBloc>(),
          )
        ],
        child: MaterialApp.router(
          routerConfig: AppRoutes().router,
          theme: AppTheme.appTheme,
        ));
  }
}
