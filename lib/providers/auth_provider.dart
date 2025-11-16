import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tambahan: menyimpan info profil user
  String? userName;
  String? userEmail;
  String? userPhoto;

  AuthProvider() {
    _user = _auth.currentUser;
    if (_user != null) {
      _updateUserInfo(_user!);
    }
  }

  // ✅ Fungsi internal untuk update info user
  void _updateUserInfo(User user) {
    userName = user.displayName;
    userEmail = user.email;
    userPhoto = user.photoURL;
    notifyListeners();
  }

  // ✅ Cek status login
  Future<User?> checkLoginStatus() async {
    _user = _auth.currentUser;
    if (_user != null) {
      _updateUserInfo(_user!);
    }
    return _user;
  }

  // ✅ Login Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) _updateUserInfo(_user!);

      _isLoading = false;
      notifyListeners();
      return _user;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal login: $e')),
      );
      return null;
    }
  }

  // ✅ Logout Google
  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      userName = null;
      userEmail = null;
      userPhoto = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }
}
