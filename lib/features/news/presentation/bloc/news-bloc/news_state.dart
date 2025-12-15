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
  final bool isLoadingMore;
  final Map<String, bool> hasMoreData;

  const NewsTabLoaded({
    required this.categoryNews,
    required this.forYouNews,
    this.isLoadingMore = false,
    this.hasMoreData = const {},
  });

  NewsTabLoaded copyWith({
    Map<String, List<NewsEntity>>? categoryNews,
    List<NewsEntity>? forYouNews,
    bool? isLoadingMore,
    Map<String, bool>? hasMoreData,
  }) {
    return NewsTabLoaded(
      categoryNews: categoryNews ?? this.categoryNews,
      forYouNews: forYouNews ?? this.forYouNews,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  List<Object> get props =>
      [categoryNews, forYouNews, isLoadingMore, hasMoreData];
}
