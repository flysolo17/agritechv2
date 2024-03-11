import 'dart:async';

import 'package:agritechv2/models/product/CartWithProduct.dart';
import 'package:agritechv2/repository/cart_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/product/Cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository, required String uid})
      : _cartRepository = cartRepository,
        super(CartInitial()) {
    on<CartEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddToCartEvent>(_addToCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<DeleteCart>(_onDeleteCart);
  }

  Future<void> _addToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      await _cartRepository.addToCart(event.cart);
      Future.delayed(const Duration(seconds: 2));
      emit(const CartSuccessState<String>("Successfully added!"));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    } finally {
      emit(CartInitial());
    }
  }

  Future<void> _onUpdateCartQuantity(
      UpdateCartQuantity event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    try {
      await _cartRepository.updateCartQuantity(event.cartID, event.quantity);
      print("cart updated");
      emit(const CartSuccessState<String>("Successfully Updated"));
    } catch (error) {
      print(error);
      emit(CartErrorState(error.toString()));
    }
  }

  Future<void> _onDeleteCart(DeleteCart event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await _cartRepository.deleteCart(event.cartID);
      print("cart updated");
      emit(const CartSuccessState<String>("Successfully Deleted"));
    } catch (error) {
      print(error);
      emit(CartErrorState(error.toString()));
    }
  }
}
