import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserModel {
  final String uid;
  final String email;
  final String nama;
  final String telepon;
  final String? fotoProfilUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FirebaseUserModel({
    required this.uid,
    required this.email,
    required this.nama,
    required this.telepon,
    this.fotoProfilUrl,
    required this.createdAt,
    this.updatedAt,
  });

  // Konversi dari Firestore Document
  factory FirebaseUserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FirebaseUserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      nama: data['nama'] ?? '',
      telepon: data['telepon'] ?? '',
      fotoProfilUrl: data['fotoProfilUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Konversi dari Map (untuk parsing dari Firestore)
  factory FirebaseUserModel.fromMap(Map<String, dynamic> map, String uid) {
    return FirebaseUserModel(
      uid: uid,
      email: map['email'] ?? '',
      nama: map['nama'] ?? '',
      telepon: map['telepon'] ?? '',
      fotoProfilUrl: map['fotoProfilUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Konversi ke Map untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nama': nama,
      'telepon': telepon,
      'fotoProfilUrl': fotoProfilUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Method untuk update data
  FirebaseUserModel copyWith({
    String? nama,
    String? telepon,
    String? fotoProfilUrl,
    DateTime? updatedAt,
  }) {
    return FirebaseUserModel(
      uid: uid,
      email: email,
      nama: nama ?? this.nama,
      telepon: telepon ?? this.telepon,
      fotoProfilUrl: fotoProfilUrl ?? this.fotoProfilUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'FirebaseUserModel(uid: $uid, email: $email, nama: $nama, telepon: $telepon)';
  }
}