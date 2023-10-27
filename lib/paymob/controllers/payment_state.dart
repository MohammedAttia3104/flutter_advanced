part of 'payment_cubit.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentAuthLoadingState extends PaymentState {}

class PaymentAuthSuccessState extends PaymentState {}

class PaymentAuthErrorState extends PaymentState {}

class PaymentOrderRegisterLoadingState extends PaymentState {}

class PaymentOrderRegisterSuccessState extends PaymentState {}

class PaymentOrderRegisterErrorState extends PaymentState {
  final String error;

  PaymentOrderRegisterErrorState({required this.error});
}

class PaymentRequestLoadingState extends PaymentState {}

class PaymentRequestSuccessState extends PaymentState {}

class PaymentRequestErrorState extends PaymentState {}

class PaymentRefCodeLoadingState extends PaymentState {}

class PaymentRefCodeSuccessState extends PaymentState {}

class PaymentRefCodeErrorState extends PaymentState {}
