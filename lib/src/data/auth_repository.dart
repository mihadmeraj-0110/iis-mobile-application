import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/app_user.dart';
import '../core/firebase_status.dart';

class AuthRepository {
  auth.FirebaseAuth get _auth => auth.FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Stream<AppUser?> get userChanges {
    if (!firebaseIsReady) return const Stream<AppUser?>.empty();
    return _auth.userChanges().map(
      (user) => user == null ? null : _fromFirebase(user),
    );
  }

  AppUser? get currentUser => firebaseIsReady && _auth.currentUser != null
      ? _fromFirebase(_auth.currentUser!)
      : null;

  AppUser _fromFirebase(auth.User user) => AppUser(
    uid: user.uid,
    email: user.email ?? '',
    displayName: user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : 'Meditation seeker',
  );

  Future<AppUser?> restoreDemoSession() async {
    if (firebaseIsReady) return currentUser;
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('demo_uid');
    if (uid == null) return null;
    return AppUser(
      uid: uid,
      email: prefs.getString('demo_email') ?? '',
      displayName: prefs.getString('demo_name') ?? 'Meditation seeker',
    );
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    if (firebaseIsReady) {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _fromFirebase(result.user!);
    }
    return _saveDemoSession(email: email.trim(), name: 'Meditation seeker');
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (firebaseIsReady) {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await result.user!.updateDisplayName(name.trim());
      final user = AppUser(
        uid: result.user!.uid,
        email: result.user!.email ?? email.trim(),
        displayName: name.trim(),
      );
      await _saveProfile(user, isNew: true);
      return user;
    }
    return _saveDemoSession(email: email.trim(), name: name.trim());
  }

  Future<void> updateProfile({required String name}) async {
    if (firebaseIsReady && _auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(name.trim());
      final currentUser = _auth.currentUser!;
      final user = AppUser(
        uid: currentUser.uid,
        email: currentUser.email ?? '',
        displayName: name.trim(),
      );
      await _saveProfile(user);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('demo_name', name.trim());
  }

  Future<void> _saveProfile(AppUser user, {bool isNew = false}) =>
      _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'onboardingComplete': true,
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<AppUser> _saveDemoSession({
    required String email,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final uid =
        prefs.getString('demo_uid') ??
        'demo-${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('demo_uid', uid);
    await prefs.setString('demo_email', email);
    await prefs.setString('demo_name', name);
    return AppUser(uid: uid, email: email, displayName: name);
  }

  Future<void> signOut() async {
    if (firebaseIsReady) {
      await _auth.signOut();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('demo_uid');
    await prefs.remove('demo_email');
    await prefs.remove('demo_name');
  }
}
