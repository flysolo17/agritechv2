part of 'customer_bloc.dart';

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class CreateAddressEvent extends CustomerEvent {
  final String uid;
  final List<Address> address;
  const CreateAddressEvent(this.uid, this.address);
  @override
  List<Object> get props => [uid, address];
}

class UpdateAddressDefault extends CustomerEvent {
  final String uid;
  final List<Address> address;
  const UpdateAddressDefault(this.uid, this.address);
  @override
  List<Object> get props => [uid, address];
}

class UploadUserPhoto extends CustomerEvent {
  final String userID;
  final File image;
  const UploadUserPhoto(this.userID, this.image);
  @override
  List<Object?> get props => [userID, image];
}

class UpdateUserPhoto extends CustomerEvent {
  final String userID;
  final String imageURL;
  const UpdateUserPhoto(this.userID, this.imageURL);
  @override
  List<Object?> get props => [userID, imageURL];
}
