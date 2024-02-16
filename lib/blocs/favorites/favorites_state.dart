part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

class FavoritesErrorState extends FavoritesState {
  final String error;
  const FavoritesErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class FavoritesLoadingState extends FavoritesState {
  @override
  List<Object> get props => [];
}

final class FavoritesSuccessState<T> extends FavoritesState {
  final T data;
  const FavoritesSuccessState(this.data);
}
