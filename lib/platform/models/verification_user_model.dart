import 'package:json_annotation/json_annotation.dart';

part 'verification_user_model.g.dart';

@JsonSerializable()
class VerificationUserModel {
  String birthday;
  String gender;
  String name;
  String mobileCompany;
  String mobileNumber;
  bool isForeigner;
  String clientId;

  VerificationUserModel({this.name = '', this.birthday = '', this.gender = '', this.mobileNumber = '', this.mobileCompany = '', this.isForeigner = true, this.clientId = ''});

  Map<String, dynamic> toJson() => _$VerificationUserModelToJson(this);
}
