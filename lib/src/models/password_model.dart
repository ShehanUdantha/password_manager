// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PasswordModel {
  final String? id;
  final String? uid;
  final String? label;
  final String? userName;
  final String? password;
  final String? notes;
  final String? category;
  final bool? isFavorite;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  PasswordModel({
    required this.id,
    required this.uid,
    required this.label,
    required this.userName,
    required this.password,
    required this.notes,
    required this.category,
    this.isFavorite,
    required this.createdDate,
    required this.updatedDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'label': label,
      'username': userName,
      'password': password,
      'notes': notes,
      'category': category,
      'is_favorite': isFavorite,
      'created_date': createdDate?.toIso8601String(),
      'updated_date': updatedDate?.toIso8601String(),
    };
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'] != null ? map['id'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      label: map['label'] != null ? map['label'] as String : null,
      userName: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      isFavorite: map['is_favorite'] != null ? map['is_favorite'] as bool : null,
      createdDate: map['created_date'] != null ? DateTime.parse(map['created_date']) : DateTime.now(),
      updatedDate: map['updated_date'] != null ? DateTime.parse(map['updated_date']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordModel.fromJson(String source) => PasswordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
