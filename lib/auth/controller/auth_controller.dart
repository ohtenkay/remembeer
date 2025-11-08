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

  /// Returns the currently authenticated `User`.
  ///
  /// Intended to be used only in an authenticated context.
  /// If no user is signed in this getter throws a `StateError`.
  User get authenticatedUser {
    final user = currentUser;
    if (user == null) {
      throw StateError('User is not authenticated.');
    }
    return user;
  }

  bool get isAuthenticated => currentUser != null;

  bool get isVerified => authenticatedUser.emailVerified;

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
    final user = authenticatedUser;
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
