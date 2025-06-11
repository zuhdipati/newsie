import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/domain/usecases/get_all_news.dart';
import 'package:newsapp/features/news/domain/usecases/get_news_by_category.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  GetAllNews getAllNews;
  GetNewsByCategory getNewsByCategory;

  List<NewsEntity> _cachedForYouNews = [];
  Map<String, List<NewsEntity>> _cachedCategoryNews = {};

  NewsBloc({
    required this.getNewsByCategory,
    required this.getAllNews,
  }) : super(NewsInitial()) {
    on<GetForYouEvent>(_getForYouEvent);
    on<ChangeTabEvent>(_onChangeTabEvent);
    on<RefreshEvent>(_onRefresh);
  }

  FutureOr<void> _getForYouEvent(GetForYouEvent event, emit) async {
    final String category = event.category;

    if (_cachedCategoryNews.containsKey(category)) {
      emit(NewsTabLoaded(
          categoryNews: _cachedCategoryNews, forYouNews: _cachedForYouNews));
      return;
    }

    emit(NewsTabLoading());
    try {
      Either<Failure, List<NewsEntity>> dataNewsByCategory =
          await getAllNews.call();
      dataNewsByCategory.fold(
        (l) {
          emit(NewsTabError(errorMsg: "an error occured"));
        },
        (r) {
          _cachedForYouNews = r;
          emit(NewsTabLoaded(
              categoryNews: _cachedCategoryNews,
              forYouNews: _cachedForYouNews));
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _onChangeTabEvent(ChangeTabEvent event, emit) async {
    final String category = event.category;

    if (_cachedCategoryNews.containsKey(category)) {
      emit(NewsTabLoaded(
        categoryNews: _cachedCategoryNews,
        forYouNews: _cachedForYouNews,
      ));
      return;
    }

    emit(NewsTabLoading());
    try {
      Either<Failure, List<NewsEntity>> dataNewsByCategory =
          await getNewsByCategory.call(event.category.toLowerCase());
      dataNewsByCategory.fold(
        (l) {
          emit(NewsTabError(errorMsg: "an error occured"));
        },
        (r) {
          _cachedCategoryNews[category] = r;
          emit(NewsTabLoaded(
            categoryNews: Map.from(_cachedCategoryNews),
            forYouNews: _cachedForYouNews,
          ));
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _onRefresh(RefreshEvent event, emit) {
    _cachedCategoryNews = {};
    add(ChangeTabEvent(category: event.category));
    add(GetForYouEvent(category: event.category));
  }
}
