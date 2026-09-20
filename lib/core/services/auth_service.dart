import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

abstract class AuthService {
  Stream<User?> get user;
  User? get currentUser;
  Future<UserCredential?> login(String email, String password);
  Future<UserCredential?> register(String email, String password, String name);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> updateProfile({String? name, String? photoUrl});
  Future<void> sendOtp(String identifier); // Email or Phone
  Future<bool> verifyOtp(String identifier, String otp);
}

class FirebaseAuthService implements AuthService {
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<User?> get user => _auth?.authStateChanges() ?? Stream.value(null);

  @override
  User? get currentUser => _auth?.currentUser;

  @override
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    final user = _auth?.currentUser;
    if (user != null) {
      if (name != null) await user.updateDisplayName(name);
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
      await user.reload();
    }
  }

  @override
  Future<UserCredential?> login(String email, String password) async {
    final auth = _auth;
    if (auth == null) return null;
    try {
      return await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.message}');
      throw e.message ?? 'An unknown error occurred';
    } catch (e) {
      debugPrint('Login error: $e');
      throw 'An error occurred during login';
    }
  }

  @override
  Future<UserCredential?> register(String email, String password, String name) async {
    final auth = _auth;
    if (auth == null) return null;
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Register error: ${e.message}');
      throw e.message ?? 'An unknown error occurred';
    } catch (e) {
      debugPrint('Register error: $e');
      throw 'An error occurred during registration';
    }
  }

  @override
  Future<void> logout() async {
    await _auth?.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    final auth = _auth;
    if (auth == null) return;
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw 'Failed to send password reset email';
    }
  }

  @override
  Future<void> sendOtp(String identifier) async {
    // In a production app, this would use Firebase Auth phone provider
    // or a custom backend for email OTP.
    // For now, we simulate success for both real and mock modes
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<bool> verifyOtp(String identifier, String otp) async {
    // Simulating OTP verification. In production, this would call
    // Firebase or your backend.
    await Future.delayed(const Duration(seconds: 1));
    return otp == '123456'; // Default mock OTP
  }
}

class SimulatedUser implements User {
  @override
  final String uid;
  @override
  String? displayName;
  @override
  final String? email;
  @override
  String? photoURL;

  SimulatedUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeUserCredential implements UserCredential {
  @override
  final User? user;
  FakeUserCredential(this.user);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockAuthService implements AuthService {
  final _controller = StreamController<User?>.broadcast();
  User? _currentUser;

  MockAuthService() {
    _currentUser = null;
  }

  @override
  Stream<User?> get user => _controller.stream;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<UserCredential?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = SimulatedUser(
      uid: 'mock_user_123',
      displayName: email.split('@').first,
      email: email,
      photoURL: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400',
    );
    _controller.add(_currentUser);
    return FakeUserCredential(_currentUser);
  }

  @override
  Future<UserCredential?> register(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = SimulatedUser(
      uid: 'mock_user_123',
      displayName: name,
      email: email,
      photoURL: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400',
    );
    _controller.add(_currentUser);
    return FakeUserCredential(_currentUser);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _controller.add(null);
  }

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentUser != null) {
      _currentUser = SimulatedUser(
        uid: _currentUser!.uid,
        displayName: name ?? _currentUser!.displayName,
        email: _currentUser!.email,
        photoURL: photoUrl ?? _currentUser!.photoURL,
      );
      _controller.add(_currentUser);
    }
  }

  @override
  Future<void> sendOtp(String identifier) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<bool> verifyOtp(String identifier, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '123456';
  }
}
