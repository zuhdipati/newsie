import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/domain/entities/news_category.dart';
import 'package:newsapp/features/news/domain/usecases/get_search_news.dart';

part 'search_news_event.dart';
part 'search_news_state.dart';

class SearchNewsBloc extends Bloc<SearchEvent, SearchNewsState> {
  GetSearchNews getSearchNews;

  SearchNewsBloc({required this.getSearchNews}) : super(SearchNewsInitial()) {
    on<SearchNewsEvent>((event, emit) async {
      emit(SearchNewsLoading());
      try {
        Either<Failure, List<NewsEntity>> searchData =
            await getSearchNews.call(event.query, event.page, event.pageSize);

        searchData.fold(
          (l) => emit(SearchNewsError(errorMsg: "ERROR SEARCH NEWS")),
          (r) => emit(SearchNewsLoaded(searchNews: r)),
        );
      } catch (e) {
        emit(SearchNewsError(errorMsg: e.toString()));
      }
    });
  }
}
