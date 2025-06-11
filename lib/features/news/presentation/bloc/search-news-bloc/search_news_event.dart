part of 'search_news_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchNewsEvent extends SearchEvent {
  final String query;
  final String page;
  final String pageSize;

  const SearchNewsEvent(
      {required this.query, required this.page, required this.pageSize});

  @override
  List<Object> get props => [query, page, pageSize];
}
