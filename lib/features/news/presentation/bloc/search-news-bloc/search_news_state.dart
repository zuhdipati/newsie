part of 'search_news_bloc.dart';

sealed class SearchNewsState extends Equatable {
  const SearchNewsState();

  @override
  List<Object> get props => [];
}

final class SearchNewsInitial extends SearchNewsState {}

final class SearchNewsLoading extends SearchNewsState {}

final class SearchNewsError extends SearchNewsState {
  final String errorMsg;

  const SearchNewsError({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

final class SearchNewsLoaded extends SearchNewsState {
  final List<NewsEntity> searchNews;

  const SearchNewsLoaded({required this.searchNews});

  @override
  List<Object> get props => [searchNews];
}
