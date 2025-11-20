import 'package:json_annotation/json_annotation.dart';

part 'client_config_model.g.dart';

@JsonSerializable()
class ClientConfigModel {
  final String name;
  final String primaryColor;

  ClientConfigModel({
    required this.name,
    required this.primaryColor,
  });

  factory ClientConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ClientConfigModelFromJson(json);
}