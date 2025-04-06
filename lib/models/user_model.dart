class UserModel {
  String id;
  String nama;
  String email;
  String telepon;
  String? fotoProfilPath;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.telepon,
    this.fotoProfilPath,
  });

  // Konversi dari JSON (untuk parsing data dari backend)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      telepon: json['telepon'] ?? '',
      fotoProfilPath: json['foto_profil'],
    );
  }

  // Konversi ke JSON (untuk mengirim data ke backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'telepon': telepon,
      'foto_profil': fotoProfilPath,
    };
  }

  // Method untuk menyalin objek dengan kemampuan modifikasi
  UserModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? telepon,
    String? fotoProfilPath,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      fotoProfilPath: fotoProfilPath ?? this.fotoProfilPath,
    );
  }
}