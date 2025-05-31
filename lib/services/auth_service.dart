import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk mendengarkan perubahan auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in dengan email dan password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Terjadi kesalahan yang tidak terduga: $e';
    }
  }

  // Register dengan email dan password
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String nama,
    required String telepon,
  }) async {
    try {
      // Buat akun Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Simpan data user tambahan ke Firestore
      if (result.user != null) {
        await _createUserDocument(
          uid: result.user!.uid,
          email: email.trim(),
          nama: nama.trim(),
          telepon: telepon.trim(),
        );
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Terjadi kesalahan yang tidak terduga: $e';
    }
  }

  // Buat document user di Firestore
  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String nama,
    required String telepon,
  }) async {
    try {
      final userDoc = FirebaseUserModel(
        uid: uid,
        email: email,
        nama: nama,
        telepon: telepon,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(userDoc.toMap());
    } catch (e) {
      throw 'Gagal menyimpan data pengguna: $e';
    }
  }

  // Get user data dari Firestore
  Future<FirebaseUserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return FirebaseUserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil data pengguna: $e';
    }
  }

  // Update user data di Firestore
  Future<void> updateUserData({
    required String uid,
    String? nama,
    String? telepon,
    String? fotoProfilUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (nama != null) updateData['nama'] = nama.trim();
      if (telepon != null) updateData['telepon'] = telepon.trim();
      if (fotoProfilUrl != null) updateData['fotoProfilUrl'] = fotoProfilUrl;

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      throw 'Gagal memperbarui data pengguna: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Gagal keluar dari akun: $e';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Gagal mengirim email reset password: $e';
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Hapus data user dari Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Hapus akun Firebase Auth
        await user.delete();
      }
    } catch (e) {
      throw 'Gagal menghapus akun: $e';
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail.trim());

        // Update email di Firestore juga
        await _firestore.collection('users').doc(user.uid).update({
          'email': newEmail.trim(),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Gagal memperbarui email: $e';
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Gagal memperbarui password: $e';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email sudah digunakan akun lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Pengguna dengan email ini tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'user-disabled':
        return 'Akun pengguna telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      case 'requires-recent-login':
        return 'Operasi sensitif memerlukan login ulang.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate password strength
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Validate phone number (Indonesia format)
  bool isValidPhone(String phone) {
    return RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$').hasMatch(phone);
  }
}