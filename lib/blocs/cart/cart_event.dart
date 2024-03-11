part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final Cart cart;
  const AddToCartEvent(this.cart);
  @override
  List<Object> get props => [cart];
}

class UpdateCartQuantity extends CartEvent {
  final String cartID;
  final int quantity;
  const UpdateCartQuantity(this.cartID, this.quantity);
  @override
  List<Object> get props => [cartID, quantity];
}

class DeleteCart extends CartEvent {
  final String cartID;

  const DeleteCart(this.cartID);
  @override
  List<Object> get props => [cartID];
}
