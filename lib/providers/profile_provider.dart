import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfileProvider with ChangeNotifier {
  // Data profil default
  String _nama = 'Kelompok 5';
  String _email = 'ezpzgeming@gmail.com';
  String _telepon = '085960652905';
  
  // Path foto profil default
  String _fotoProfilPath = 'assets/images/profile_avatar.png';

  // Getter untuk data profil
  String get nama => _nama;
  String get email => _email;
  String get telepon => _telepon;
  String get fotoProfilPath => _fotoProfilPath;

  // Metode untuk upload foto profil
  Future<void> uploadFotoProfil() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // Kompresi gambar
      );

      if (pickedFile != null) {
        // Dapatkan direktori dokumen aplikasi
        final appDir = await getApplicationDocumentsDirectory();
        final profileDir = Directory('${appDir.path}/profile');
        
        // Buat direktori jika belum ada
        if (!await profileDir.exists()) {
          await profileDir.create(recursive: true);
        }

        // Generate nama file unik
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final newPath = '${profileDir.path}/$fileName';

        // Copy file ke direktori profile
        final File newImage = await File(pickedFile.path).copy(newPath);

        // Update path foto profil dengan path absolut
        _fotoProfilPath = newPath;
        
        // Beritahu listener
        notifyListeners();
      }
    } catch (e) {
      print('Gagal mengupload foto: $e');
    }
  }

  // Fungsi untuk generate avatar dari nama
  Widget generateAvatar({double size = 70, Color? backgroundColor}) {
    if (nama.isEmpty) {
      return Icon(
        Icons.person, 
        size: size, 
        color: backgroundColor ?? Colors.grey
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          nama[0].toUpperCase(), // Ambil huruf pertama
          style: TextStyle(
            color: Colors.white,
            fontSize: size / 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Metode untuk update profil
  void updateProfil({
    String? nama, 
    String? email, 
    String? telepon, 
    String? fotoProfilPath
  }) {
    // Update data jika ada perubahan
    if (nama != null) _nama = nama;
    if (email != null) _email = email;
    if (telepon != null) _telepon = telepon;
    if (fotoProfilPath != null) _fotoProfilPath = fotoProfilPath;

    // Beritahu listener
    notifyListeners();
  }

  // Validasi email
  bool validasiEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validasi nomor telepon (untuk Indonesia)
  bool validasiNomorTelepon(String telepon) {
    final teleponRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$');
    return teleponRegex.hasMatch(telepon);
  }
}