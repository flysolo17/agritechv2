import 'dart:async';
import 'package:agritechv2/models/favorites/favorites.dart';
import 'package:agritechv2/repository/favorites_repository.dart';
import 'package:agritechv2/utils/Constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;
  final _favoritesController = StreamController<List<Favorites>>();
  Stream<List<Favorites>> get favoritesStream => _favoritesController.stream;
  FavoritesBloc(
      {required FavoritesRepository favoritesRepository,
      required String customerID})
      : _favoritesRepository = favoritesRepository,
        super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) {});
    on<AddFavoritesEvent>(_onAddFavorites);
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<RemoveFromFavorites>(_onRemoveFavorite);
    _initializeStream(customerID);
  }

  Future<void> _initializeStream(String customerID) async {
    try {
      Stream<List<Favorites>> favoritesStream =
          _favoritesRepository.streamFavoritesByCustomerId(customerID);
      favoritesStream.listen(
        (favorites) {
          _favoritesController.add(favorites);
        },
        onError: (error) {
          print(error);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAddFavorites(
      AddFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      emit(FavoritesLoadingState());
      event.favorites.id = generateInvoiceID();
      await _favoritesRepository.addFavorite(event.favorites);
      emit(const FavoritesSuccessState<String>("Successfully Added"));
    } catch (e) {
      emit(FavoritesErrorState(e.toString()));
    }
  }

  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      print("Fetching Favorites by: ${event.customerID}");
      Stream<List<Favorites>> favoritesStream =
          _favoritesRepository.streamFavoritesByCustomerId(event.customerID);
      favoritesStream.listen((favorites) {
        _favoritesController.add(favorites);

        emit(FavoritesSuccessState<List<Favorites>>(favorites));
        print("Fetching Favorites Success  by: ${event.customerID}");
      });
    } catch (e) {
      emit(FavoritesErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _favoritesController.close();
    return super.close();
  }

  Future<void> _onRemoveFavorite(
      RemoveFromFavorites event, Emitter<FavoritesState> emit) async {
    try {
      emit(FavoritesLoadingState());

      // Replace 'yourProductId' and 'yourCustomerId' with the actual values
      String productId = event.productID;
      String customerId = event.customerID;
      await _favoritesRepository.deleteFavorite(productId, customerId);
      emit(const FavoritesSuccessState<String>("Successfully Removed"));
    } catch (e) {
      emit(FavoritesErrorState(e.toString()));
    }
  }
}
