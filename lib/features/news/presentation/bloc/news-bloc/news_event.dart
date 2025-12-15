part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

final class ChangeTabEvent extends NewsEvent {
  final String category;

  const ChangeTabEvent({required this.category});

  @override
  List<Object> get props => [category];
}

final class GetForYouEvent extends NewsEvent {
  final String category;

  const GetForYouEvent({required this.category});

  @override
  List<Object> get props => [category];
}

final class RefreshEvent extends NewsEvent {
  final String category;

  const RefreshEvent({required this.category});

  @override
  List<Object> get props => [category];
}

final class LoadMoreCategoryEvent extends NewsEvent {
  final String category;

  const LoadMoreCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}
