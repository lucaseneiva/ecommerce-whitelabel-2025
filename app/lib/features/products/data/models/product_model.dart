import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  
  // O Backend agora manda number, mas o JsonSerializable lida bem com num
  final num? price; 
  
  final String? department;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.department,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}