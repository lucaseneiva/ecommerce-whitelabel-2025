// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String?,
  name: json['nome'] as String?,
  description: json['descricao'] as String?,
  image: json['imagem'] as String?,
  price: json['preco'] as String?,
  department: json['departamento'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.name,
      'descricao': instance.description,
      'imagem': instance.image,
      'preco': instance.price,
      'departamento': instance.department,
    };
