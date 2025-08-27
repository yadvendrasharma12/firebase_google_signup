import 'package:firebase_auth/firebase_auth.dart';

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

      // Update display name
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
      // Agar empty email/password daala
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

  /// 🔹 Forgot Password (Reset Email)
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
  }

  /// 🔹 Current User
  User? get currentUser => _auth.currentUser;
}
