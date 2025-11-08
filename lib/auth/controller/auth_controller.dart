import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth;
  final _authStateSubject = BehaviorSubject<User?>();

  AuthController(this._firebaseAuth) {
    _authStateSubject.add(_firebaseAuth.currentUser);
    _firebaseAuth.authStateChanges().listen(_authStateSubject.add);
  }

  late final Stream<User?> authStateChanges = _authStateSubject.stream;

  User? get currentUser =>
      _authStateSubject.valueOrNull ?? _firebaseAuth.currentUser;

  bool get isAuthenticated => currentUser != null;

  bool get isVerified => currentUser?.emailVerified ?? false;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
