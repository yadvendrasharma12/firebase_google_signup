import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Sign Up with Email & Password
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Sign up failed";
    }
  }

  /// 🔹 Sign In with Email & Password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw "Please create an account first!";
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw "No account found for this email. Please sign up!";
      } else if (e.code == "wrong-password") {
        throw "Incorrect password. Please try again.";
      } else if (e.code == "invalid-email") {
        throw "Invalid email address.";
      } else {
        throw e.message ?? "Sign in failed";
      }
    }
  }

  /// 🔹 Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      if (email.isEmpty) throw "Please enter your registered email";
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw "No user found with this email";
      } else if (e.code == "invalid-email") {
        throw "Invalid email address.";
      } else {
        throw e.message ?? "Failed to send reset email";
      }
    }
  }

  /// 🔹 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut(); // Google sign out bhi
  }

  /// 🔹 Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // user canceled

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      throw "Google Sign-In failed: $e";
    }
  }

  /// 🔹 Current User
  User? get currentUser => _auth.currentUser;
}
