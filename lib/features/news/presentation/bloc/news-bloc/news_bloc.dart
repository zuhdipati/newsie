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
  Map<String, int> _categoryPages = {};
  Map<String, bool> _hasMoreData = {};

  static const int _pageSize = 5;

  NewsBloc({
    required this.getNewsByCategory,
    required this.getAllNews,
  }) : super(NewsInitial()) {
    on<GetForYouEvent>(_getForYouEvent);
    on<ChangeTabEvent>(_onChangeTabEvent);
    on<RefreshEvent>(_onRefresh);
    on<LoadMoreCategoryEvent>(_onLoadMoreCategory);
  }

  FutureOr<void> _getForYouEvent(GetForYouEvent event, emit) async {
    final String category = event.category;

    if (_cachedCategoryNews.containsKey(category)) {
      emit(NewsTabLoaded(
        categoryNews: _cachedCategoryNews,
        forYouNews: _cachedForYouNews,
        hasMoreData: _hasMoreData,
      ));
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
            forYouNews: _cachedForYouNews,
            hasMoreData: _hasMoreData,
          ));
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
        hasMoreData: _hasMoreData,
      ));
      return;
    }

    emit(NewsTabLoading());
    try {
      Either<Failure, List<NewsEntity>> dataNewsByCategory =
          await getNewsByCategory.call(category.toLowerCase(),
              page: 1, pageSize: _pageSize);
      dataNewsByCategory.fold(
        (l) {
          emit(NewsTabError(errorMsg: "an error occured"));
        },
        (r) {
          _cachedCategoryNews[category] = r;
          _categoryPages[category] = 1;
          _hasMoreData[category] = r.length >= _pageSize;
          emit(NewsTabLoaded(
            categoryNews: Map.from(_cachedCategoryNews),
            forYouNews: _cachedForYouNews,
            hasMoreData: Map.from(_hasMoreData),
          ));
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _onLoadMoreCategory(LoadMoreCategoryEvent event, emit) async {
    final String category = event.category;

    if (state is! NewsTabLoaded) return;
    final currentState = state as NewsTabLoaded;
    if (currentState.isLoadingMore) return;
    if (_hasMoreData[category] == false) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final currentPage = _categoryPages[category] ?? 1;
      final nextPage = currentPage + 1;

      Either<Failure, List<NewsEntity>> dataNewsByCategory =
          await getNewsByCategory.call(category.toLowerCase(),
              page: nextPage, pageSize: _pageSize);

      dataNewsByCategory.fold(
        (l) {
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (r) {
          final existingNews = _cachedCategoryNews[category] ?? [];
          _cachedCategoryNews[category] = [...existingNews, ...r];
          _categoryPages[category] = nextPage;
          _hasMoreData[category] = r.length >= _pageSize;

          emit(NewsTabLoaded(
            categoryNews: Map.from(_cachedCategoryNews),
            forYouNews: _cachedForYouNews,
            isLoadingMore: false,
            hasMoreData: Map.from(_hasMoreData),
          ));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  FutureOr<void> _onRefresh(RefreshEvent event, emit) {
    _cachedCategoryNews = {};
    _categoryPages = {};
    _hasMoreData = {};
    add(ChangeTabEvent(category: event.category));
    add(GetForYouEvent(category: event.category));
  }
}
