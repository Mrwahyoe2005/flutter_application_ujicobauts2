import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 🔹 Stream untuk memantau perubahan status login
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 🔹 Dapatkan user saat ini
  User? get currentUser => _auth.currentUser;

  /// 🔹 Login menggunakan akun Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger proses login Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null; // Jika user batal login

      // Ambil token autentikasi
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Buat credential untuk Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('⚠️ FirebaseAuth error: ${e.message}');
      return null;
    } catch (e) {
      print('⚠️ Error signInWithGoogle: $e');
      return null;
    }
  }

  /// 🔹 Logout dari akun Google & Firebase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('⚠️ Error signOut: $e');
    }
  }
}
