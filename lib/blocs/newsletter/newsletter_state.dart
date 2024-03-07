part of 'newsletter_bloc.dart';

sealed class NewsletterState extends Equatable {
  const NewsletterState();

  @override
  List<Object> get props => [];
}

final class NewsletterInitial extends NewsletterState {}

class NewsletterError extends NewsletterState {
  final String error;
  const NewsletterError(this.error);

  @override
  List<Object> get props => [error];
}

class NewsletterLoading extends NewsletterState {
  @override
  List<Object> get props => [];
}

final class NewsletterSuccessState<T> extends NewsletterState {
  final T data;
  const NewsletterSuccessState(this.data);
}
