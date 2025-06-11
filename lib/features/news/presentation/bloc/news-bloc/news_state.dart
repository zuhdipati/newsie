part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

final class NewsTabLoading extends NewsState {}

final class NewsTabError extends NewsState {
  final String errorMsg;

  const NewsTabError({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

final class NewsTabLoaded extends NewsState {
  final Map<String, List<NewsEntity>> categoryNews;
  final List<NewsEntity> forYouNews;

  const NewsTabLoaded({required this.categoryNews, required this.forYouNews});

  @override
  List<Object> get props => [categoryNews, forYouNews];
}
