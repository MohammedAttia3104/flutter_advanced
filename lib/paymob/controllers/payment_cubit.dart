import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_payment_integration/paymob/core/networks/constants.dart';
import 'package:stripe_payment_integration/paymob/core/networks/dio_helper.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  static PaymentCubit get(context) => BlocProvider.of<PaymentCubit>(context);

  ///TODo : FIRST SECTION
  ///Step 1 : Get Authintication Token ......>>GET FIRST TOKEN
  ///USE PAYMENT API KEY
  Future<void> getAuthToken() async {
    emit(PaymentAuthLoadingState());
    DioHelper.postData(url: ApiConstants.getAuthToken, data: {
      "api_key": ApiConstants.paymentApiKey,
    }).then(
      (value) {
        ApiConstants.firstToken = value.data["token"];
        print("FIRST TOKEN ${ApiConstants.firstToken}");
        emit(PaymentAuthSuccessState());
      },
    ).catchError((error) {
      emit(PaymentAuthErrorState());
    });
  }

  ///Step 2 : Get order registeration id to use it in the third step .....>>GET ID
  ///USE FIRST TOKEN
  // Future<void> getOrderRegisterationId({
  //   required String price,
  //   required String firstName,
  //   required String lastName,
  //   required String email,
  //   required String phone,
  // }) async {
  //   emit(PaymentOrderRegisterLoadingState());
  //   DioHelper.postData(
  //     url: ApiConstants.getOrderId,
  //     data: {
  //       "auth_token": ApiConstants.firstToken,
  //       "amount_cents": (price * 100).toString(),
  //       "currency": "EGP",
  //       "items": [],
  //     },
  //   ).then((value) {
  //     ApiConstants.paymentOrderId = value.data["id"].toString();
  //     print(
  //         "ORDER ID  =================================${ApiConstants.paymentOrderId}");
  //     // getPaymentRequest(
  //     //   price: price,
  //     //   firstName: firstName,
  //     //   lastName: lastName,
  //     //   email: email,
  //     //   phone: phone,
  //     // );
  //     emit(PaymentOrderRegisterSuccessState());
  //   }).catchError(
  //     (error) {
  //       debugPrint("ERROR OCCURED ${error.toString()}");
  //       emit(PaymentOrderRegisterErrorState(error: error.toString()));
  //     },
  //   );
  // }
  Future getOrderRegistrationID({
    required String price,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    emit(PaymentOrderRegisterLoadingState());
    DioHelper.postData(
      url: ApiConstants.getOrderId,
      data: {
        'auth_token': ApiConstants.firstToken,
        "delivery_needed": "false",
        "amount_cents": (price * 100).toString(),
        "currency": "EGP",
        "items": [],
      },
    ).then((value) {
      // OrderRegistrationModel orderRegistrationModel =
      // OrderRegistrationModel.fromJson(value.data);
      ApiConstants.paymentOrderId = value.data["id"].toString();
      getPaymentRequest(
        price,
        firstName,
        lastName,
        email,
        phone,
      );
      print('The order id 🍅 =${ApiConstants.paymentOrderId}');
      emit(PaymentOrderRegisterSuccessState());
    }).catchError((error) {
      print('Error in order id 🤦‍♂️');
      emit(
        PaymentOrderRegisterErrorState(error: error.toString()),
      );
    });
  }

  ///Step 3 : DONE PAYMENT REQUEST .......>> GET FINAL TOKEN
  ///USE FIRST TOKEN AND SOME DATA
  Future<void> getPaymentRequest(
    String price,
    String firstName,
    String lastName,
    String email,
    String phone,
  ) async {
    emit(PaymentRequestLoadingState());
    DioHelper.postData(
      url: ApiConstants.getPaymentRequest,
      data: {
        "auth_token": ApiConstants.firstToken,
        "amount_cents": price * 100,
        "expiration": 3600,
        "order_id": ApiConstants.paymentOrderId.toString(),
        "billing_data": {
          "apartment": "NA",
          "email": email,
          "floor": "NA",
          "first_name": "NA",
          "street": "NA",
          "building": "NA",
          "phone_number": phone,
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": lastName,
          "state": "NA"
        },
        "currency": "EGP",
        "integration_id": ApiConstants.integrationIdCard,
        "lock_order_when_paid": "false"
      },
    ).then((value) {
      ApiConstants.finalToken = value.data["token"];
      debugPrint("FINAL TOKEN ${ApiConstants.finalToken}");
      emit(PaymentRequestSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(PaymentRequestErrorState());
    });
  }

  ///ToDo: Section 2
  ///USE REFCODE as Payment method
  ///Get RefCode .....>> Get RefCode ID
  ///USE FINAL TOKEN
  Future<void> getRefCode() async {
    emit(PaymentRefCodeLoadingState());
    DioHelper.postData(
      url: ApiConstants.getRefCode,
      data: {
        "source": {
          "identifier": "AGGREGATOR",
          "subtype": "AGGREGATOR",
        },
        "payment_token": ApiConstants.finalToken,
      },
    ).then((value) {
      ApiConstants.refCode = value.data['id'].toString();
      emit(PaymentRequestSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(PaymentRefCodeErrorState());
    });
  }
}
