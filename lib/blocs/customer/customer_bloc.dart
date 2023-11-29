import 'dart:async';
import 'dart:io';

import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final UserRepository _userRepository;
  CustomerBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(CustomerInitial()) {
    on<CustomerEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CreateAddressEvent>(_onCreateAddress);

    on<UploadUserPhoto>(_uploadUserProfile);
    on<UpdateUserPhoto>(_updateUserPhoto);
    on<UpdateAddressDefault>(_onUpdateAddressDefault);
  }

  Future<void> _onCreateAddress(
      CreateAddressEvent event, Emitter<CustomerState> emit) async {
    try {
      emit(CustomerLoading());
      await _userRepository.addAddress(event.uid, event.address);
      await Future.delayed(const Duration(seconds: 2));
      emit(const CustomerSuccess<String>("Successfully Added"));
    } catch (e) {
      emit(CustomerError("error on bloc" + e.toString()));
    } finally {
      emit(CustomerInitial());
    }
  }

  Future<void> _uploadUserProfile(
      UploadUserPhoto event, Emitter<CustomerState> emit) async {
    try {
      emit(CustomerLoading());
      String? result = await _userRepository.uploadFile(event.image);
      await Future.delayed(const Duration(seconds: 1));
      if (result != null) {
        add(UpdateUserPhoto(event.userID, result));
      } else {
        emit(const CustomerError("Error uploading image"));
        emit(CustomerInitial());
      }
    } catch (e) {
      emit(CustomerError(e.toString()));
      emit(CustomerInitial());
    }
  }

  Future<void> _updateUserPhoto(
      UpdateUserPhoto event, Emitter<CustomerState> emit) async {
    try {
      emit(CustomerLoading());
      await _userRepository.updateUserPhoto(event.userID, event.imageURL);
      emit(const CustomerSuccess<String>("Profile Successfully updated"));
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      emit(CustomerError(e.toString()));
    } finally {
      emit(CustomerInitial());
    }
  }

  Future<void> _onUpdateAddressDefault(
      UpdateAddressDefault event, Emitter<CustomerState> emit) async {
    try {
      emit(CustomerLoading());
      await _userRepository.addAddress(event.uid, event.address);
      await Future.delayed(const Duration(seconds: 2));
      emit(const CustomerSuccess<String>("Successfully Updated"));
    } catch (e) {
      emit(CustomerError(e.toString()));
    } finally {
      emit(CustomerInitial());
    }
  }
}
