
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<User?> get userChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signup(
      {required String email, required String password}) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'password-too-weak') {
        throw Exception("Your password too weak!");
      } else if (e.code == 'email-already-in-use') {
        throw Exception("Email is already in use!");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    print("signed out!");
    await _auth.signOut();
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  
}
