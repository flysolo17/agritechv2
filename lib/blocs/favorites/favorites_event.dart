part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class AddFavoritesEvent extends FavoritesEvent {
  final Favorites favorites;
  const AddFavoritesEvent(this.favorites);
  @override
  List<Object?> get props => [favorites];
}

class FetchFavoritesEvent extends FavoritesEvent {
  final String customerID;
  const FetchFavoritesEvent(this.customerID);
  @override
  List<Object?> get props => [customerID];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String productID;
  final String customerID;
  const RemoveFromFavorites(this.productID, this.customerID);
  @override
  List<Object?> get props => [productID, customerID];
}
