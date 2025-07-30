// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solana_fee_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaFeeResponseModel _$SolanaFeeResponseModelFromJson(
        Map<String, dynamic> json) =>
    SolanaFeeResponseModel(
      fee: json['fee'] == null
          ? null
          : AssetAmountModel.fromJson(json['fee'] as Map<String, dynamic>),
      createAccountFee: json['createAccountFee'] == null
          ? null
          : AssetAmountModel.fromJson(
              json['createAccountFee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SolanaFeeResponseModelToJson(
        SolanaFeeResponseModel instance) =>
    <String, dynamic>{
      'fee': instance.fee?.toJson(),
      'createAccountFee': instance.createAccountFee?.toJson(),
    };
