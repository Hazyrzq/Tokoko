import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/firebase_user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  // State variables
  FirebaseUserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  FirebaseUserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  // Initialize authentication state
  void _initializeAuth() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        try {
          // Get user data from Firestore
          _user = await _authService.getUserData(firebaseUser.uid);
          _errorMessage = null;
        } catch (e) {
          _errorMessage = e.toString();
          _user = null;
        }
      } else {
        _user = null;
        _errorMessage = null;
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  // Sign in method
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate input
      if (!_authService.isValidEmail(email)) {
        throw 'Format email tidak valid';
      }

      if (password.isEmpty) {
        throw 'Password tidak boleh kosong';
      }

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register method
  Future<bool> register({
    required String email,
    required String password,
    required String nama,
    required String telepon,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate input
      if (nama.trim().isEmpty) {
        throw 'Nama tidak boleh kosong';
      }

      if (!_authService.isValidEmail(email)) {
        throw 'Format email tidak valid';
      }

      if (!_authService.isValidPassword(password)) {
        throw 'Password minimal 6 karakter';
      }

      if (!_authService.isValidPhone(telepon)) {
        throw 'Format nomor telepon tidak valid';
      }

      await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        nama: nama,
        telepon: telepon,
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? nama,
    String? telepon,
    String? fotoProfilUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (_user == null) {
        throw 'User tidak ditemukan';
      }

      // Validate input
      if (nama != null && nama.trim().isEmpty) {
        throw 'Nama tidak boleh kosong';
      }

      if (telepon != null && !_authService.isValidPhone(telepon)) {
        throw 'Format nomor telepon tidak valid';
      }

      // Update data in Firestore
      await _authService.updateUserData(
        uid: _user!.uid,
        nama: nama,
        telepon: telepon,
        fotoProfilUrl: fotoProfilUrl,
      );

      // Update local user data
      _user = _user!.copyWith(
        nama: nama,
        telepon: telepon,
        fotoProfilUrl: fotoProfilUrl,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_authService.isValidEmail(email)) {
        throw 'Format email tidak valid';
      }

      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update email
  Future<bool> updateEmail(String newEmail) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_authService.isValidEmail(newEmail)) {
        throw 'Format email tidak valid';
      }

      await _authService.updateEmail(newEmail);

      // Update local user data
      if (_user != null) {
        _user = _user!.copyWith(updatedAt: DateTime.now());
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      _setLoading(true);
      _clearError();

      if (!_authService.isValidPassword(newPassword)) {
        throw 'Password minimal 6 karakter';
      }

      await _authService.updatePassword(newPassword);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.deleteAccount();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    if (_user != null) {
      try {
        _user = await _authService.getUserData(_user!.uid);
        notifyListeners();
      } catch (e) {
        _setError(e.toString());
      }
    }
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

  // Clear error manually
  void clearError() {
    _clearError();
  }
}