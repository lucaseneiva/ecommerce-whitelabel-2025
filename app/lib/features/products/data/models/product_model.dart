import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String? id; // Pode vir null ou numérico convertido
  
  @JsonKey(name: 'nome')
  final String? name;
  
  @JsonKey(name: 'descricao')
  final String? description;
  
  @JsonKey(name: 'imagem')
  final String? image;
  
  @JsonKey(name: 'preco')
  final String? price; // O MockAPI as vezes manda numero, as vezes string
  
  @JsonKey(name: 'departamento')
  final String? department;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.department,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Pequeno truque para converter tudo para String caso venha Number do JSON
    // Isso evita erros do tipo "int is not a subtype of String"
    Map<String, dynamic> safeJson = {};
    json.forEach((key, value) {
      safeJson[key] = value?.toString();
    });
    
    return _$ProductModelFromJson(safeJson);
  }
}