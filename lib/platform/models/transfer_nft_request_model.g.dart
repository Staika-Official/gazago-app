// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_nft_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferNftRequestModel _$TransferNftRequestModelFromJson(
        Map<String, dynamic> json) =>
    TransferNftRequestModel(
      tokenAddress: json['tokenAddress'] as String,
      encodedTransaction: json['encodedTransaction'] as String,
    );

Map<String, dynamic> _$TransferNftRequestModelToJson(
        TransferNftRequestModel instance) =>
    <String, dynamic>{
      'tokenAddress': instance.tokenAddress,
      'encodedTransaction': instance.encodedTransaction,
    };
