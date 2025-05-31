import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import '../services/auth_service.dart';
import '../models/firebase_user_model.dart';

class ProfileProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  // User data - now integrated with Firebase
  FirebaseUserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Path foto profil default
  String _defaultFotoProfilPath = 'assets/images/profile_avatar.png';

  // Getters
  String get nama => _currentUser?.nama ?? 'Guest User';
  String get email => _currentUser?.email ?? 'guest@tokoku.com';
  String get telepon => _currentUser?.telepon ?? '';
  String get fotoProfilPath => _currentUser?.fotoProfilUrl ?? _defaultFotoProfilPath;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FirebaseUserModel? get currentUser => _currentUser;

  // Initialize with Firebase user data
  Future<void> initializeWithUser(FirebaseUserModel user) async {
    _currentUser = user;
    notifyListeners();
  }

  // Load user data from Firebase
  Future<void> loadUserData() async {
    try {
      _setLoading(true);
      final currentFirebaseUser = _authService.currentUser;

      if (currentFirebaseUser != null) {
        _currentUser = await _authService.getUserData(currentFirebaseUser.uid);
        _clearError();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Metode untuk upload foto profil dengan Firebase Storage
  Future<void> uploadFotoProfil() async {
    final picker = ImagePicker();
    try {
      _setLoading(true);

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Kompresi untuk mempercepat upload
      );

      if (pickedFile != null && _currentUser != null) {
        // Upload ke Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${_currentUser!.uid}.jpg');

        // Upload file
        final uploadTask = await storageRef.putFile(File(pickedFile.path));

        // Get download URL
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        // Update user data dengan URL foto baru
        await _authService.updateUserData(
          uid: _currentUser!.uid,
          fotoProfilUrl: downloadUrl,
        );

        // Update local user data
        _currentUser = _currentUser!.copyWith(
          fotoProfilUrl: downloadUrl,
          updatedAt: DateTime.now(),
        );

        _clearError();
        notifyListeners();
      }
    } catch (e) {
      _setError('Gagal mengupload foto: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Upload foto profil dari file lokal (fallback method)
  Future<void> uploadFotoProfilLocal() async {
    final picker = ImagePicker();
    try {
      _setLoading(true);

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        // Simpan lokal sebagai backup
        final appDir = await getApplicationDocumentsDirectory();
        final profileDir = Directory('${appDir.path}/profile');

        if (!await profileDir.exists()) {
          await profileDir.create(recursive: true);
        }

        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final newPath = '${profileDir.path}/$fileName';
        final File newImage = await File(pickedFile.path).copy(newPath);

        // Jika user login, coba upload ke Firebase, jika tidak simpan lokal
        if (_currentUser != null) {
          try {
            // Upload ke Firebase Storage
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('profile_images')
                .child('${_currentUser!.uid}.jpg');

            final uploadTask = await storageRef.putFile(newImage);
            final downloadUrl = await uploadTask.ref.getDownloadURL();

            // Update di Firestore
            await _authService.updateUserData(
              uid: _currentUser!.uid,
              fotoProfilUrl: downloadUrl,
            );

            // Update local data
            _currentUser = _currentUser!.copyWith(
              fotoProfilUrl: downloadUrl,
              updatedAt: DateTime.now(),
            );
          } catch (e) {
            // Jika gagal upload ke Firebase, gunakan path lokal
            print('Firebase upload failed, using local path: $e');
            if (_currentUser != null) {
              _currentUser = _currentUser!.copyWith(
                fotoProfilUrl: newPath,
                updatedAt: DateTime.now(),
              );
            }
          }
        }

        _clearError();
        notifyListeners();
      }
    } catch (e) {
      _setError('Gagal mengupload foto: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fungsi untuk generate avatar dari nama
  Widget generateAvatar({double size = 70, Color? backgroundColor}) {
    if (nama.isEmpty || nama == 'Guest User') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Icon(
            Icons.person,
            size: size * 0.6,
            color: Colors.white
        ),
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
          nama[0].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Metode untuk update profil (integrated with Firebase)
  Future<bool> updateProfil({
    String? nama,
    String? email,
    String? telepon,
    String? fotoProfilUrl
  }) async {
    try {
      _setLoading(true);

      if (_currentUser == null) {
        throw 'User tidak ditemukan';
      }

      // Validate input
      if (nama != null && nama.trim().isEmpty) {
        throw 'Nama tidak boleh kosong';
      }

      if (telepon != null && !validasiNomorTelepon(telepon)) {
        throw 'Format nomor telepon tidak valid';
      }

      if (email != null && !validasiEmail(email)) {
        throw 'Format email tidak valid';
      }

      // Update di Firebase
      await _authService.updateUserData(
        uid: _currentUser!.uid,
        nama: nama,
        telepon: telepon,
        fotoProfilUrl: fotoProfilUrl,
      );

      // Update email jika berbeda (requires separate Firebase Auth call)
      if (email != null && email != _currentUser!.email) {
        await _authService.updateEmail(email);
      }

      // Update local user data
      _currentUser = _currentUser!.copyWith(
        nama: nama,
        telepon: telepon,
        fotoProfilUrl: fotoProfilUrl,
        updatedAt: DateTime.now(),
      );

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data from Firebase
  Future<void> refreshUserData() async {
    if (_currentUser != null) {
      await loadUserData();
    }
  }

  // Clear user data (logout)
  void clearUserData() {
    _currentUser = null;
    _clearError();
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

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Method to get profile image widget
  Widget getProfileImage({double size = 70, Color? backgroundColor}) {
    final imagePath = fotoProfilPath;

    // Jika menggunakan URL Firebase
    if (imagePath.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    backgroundColor ?? Colors.blue,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return generateAvatar(size: size, backgroundColor: backgroundColor);
          },
        ),
      );
    }

    // Jika menggunakan asset
    if (imagePath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return generateAvatar(size: size, backgroundColor: backgroundColor);
          },
        ),
      );
    }

    // Jika menggunakan file lokal
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.file(
        File(imagePath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return generateAvatar(size: size, backgroundColor: backgroundColor);
        },
      ),
    );
  }
}