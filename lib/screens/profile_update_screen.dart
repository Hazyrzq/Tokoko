import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  // Warna utama dari aplikasi
  final Color _primaryColor = const Color(0xFF2D7BEE);

  // Controller untuk input field
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller dengan data dari provider
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _namaController = TextEditingController(text: profileProvider.nama);
    _emailController = TextEditingController(text: profileProvider.email);
    _teleponController = TextEditingController(text: profileProvider.telepon);
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pilihGambar() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.uploadFotoProfil();
  }

  // Fungsi untuk menyimpan perubahan profil
  void _simpanProfil() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // Validasi input
    if (_namaController.text.isEmpty) {
      _tampilkanSnackBar('Nama tidak boleh kosong');
      return;
    }

    if (!profileProvider.validasiEmail(_emailController.text)) {
      _tampilkanSnackBar('Email tidak valid');
      return;
    }

    if (!profileProvider.validasiNomorTelepon(_teleponController.text)) {
      _tampilkanSnackBar('Nomor telepon tidak valid');
      return;
    }

    // Update profil melalui provider
    profileProvider.updateProfil(
      nama: _namaController.text.trim(),
      email: _emailController.text.trim(),
      telepon: _teleponController.text.trim(),
    );

    // Tampilkan konfirmasi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Profil Diperbarui',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Perubahan profil Anda telah disimpan.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Kembali ke layar sebelumnya
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: _primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan pesan kesalahan
  void _tampilkanSnackBar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pesan,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profil',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto Profil
                GestureDetector(
                  onTap: _pilihGambar,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _primaryColor, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _buildProfileImage(profileProvider),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Input Nama
                _buildInputField(
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_rounded,
                ),

                const SizedBox(height: 16),

                // Input Email
                _buildInputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Input Nomor Telepon
                _buildInputField(
                  controller: _teleponController,
                  label: 'Nomor Telepon',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 32),

                // Tombol Simpan
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _simpanProfil,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Simpan Perubahan',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget untuk membangun gambar profil
  Widget _buildProfileImage(ProfileProvider profileProvider) {
    // Cek apakah foto profil adalah asset atau file lokal
    if (profileProvider.fotoProfilPath.startsWith('assets/')) {
      // Jika dari asset
      return Image.asset(
        profileProvider.fotoProfilPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return profileProvider.generateAvatar(
            size: 120, 
            backgroundColor: _primaryColor
          );
        },
      );
    } else {
      // Jika dari file lokal
      return Image.file(
        File(profileProvider.fotoProfilPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return profileProvider.generateAvatar(
            size: 120, 
            backgroundColor: _primaryColor
          );
        },
      );
    }
  }

  // Widget untuk membuat input field dengan desain kustom
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: _primaryColor,
              size: 22,
            ),
          ),
          hintText: label,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[500],
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  // Pembersihan controller
  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    super.dispose();
  }
}