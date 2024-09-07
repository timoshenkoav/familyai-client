import 'dart:async';

import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/api_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

sealed class SignInResult {}

class SignInHome extends SignInResult {}

class SignInProfile extends SignInResult {}

class SignInError extends SignInResult {
  final dynamic ex;
  final StackTrace? stack;

  SignInError({required this.ex, this.stack});
}

class UserRepository {
  final ApiRepository _apiRepository = getIt();

  Future<bool> hasUser() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  Stream<OAuthCredential> listenGoogleSignIn() {
    final googleSignInStream = StreamController<OAuthCredential>();
    if (kIsWeb) {
      signin.onCurrentUserChanged.listen(
            (event) async {
          print("onGoogleUser $event");
          if (event != null && FirebaseAuth.instance.currentUser == null) {
            final GoogleSignInAuthentication googleAuth =
            await event.authentication;
            // Create a new credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            googleSignInStream.add(credential);
            // final authRet =  await auth(credential);
            // googleSignInStream.add(authRet);
          }
        },
      );
    }
    return googleSignInStream.stream;
  }

  Future<SignInResult> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return await checkUserStatus();
    } catch (ex) {
      return SignInError(ex: ex);
    }
  }

  Future<SignInResult> signUp(String email, String password) async {
    final ret = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return await checkUserStatus();
  }

  Future<SignInResult> auth(AuthCredential creds) async {
    final ret = await FirebaseAuth.instance.signInWithCredential(creds);

    var user = ret.user;
    if (user != null) {
      return checkUserStatus();
    }
    return SignInError(ex: Error);
  }

  Future<SignInResult> checkUserStatus() async {
    // await Future.delayed(const Duration(milliseconds: 300));
    if (await hasUser()) {
      return SignInHome();
    } else {
      return SignInProfile();
    }
  }

  final signin = GoogleSignIn(
      signInOption: SignInOption.standard,
      scopes: ["email"],
      clientId:
      "351315350105-b2jubi3boj6o49eo6jvp5tnmgiu3vq0u.apps.googleusercontent.com");

  Future<SignInResult?> google() async {
    try {
      if (kIsWeb) {
        final account = await signin.signIn();
        print("google account = $account");
      } else {
        final signin = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await signin.signIn();
        if (googleUser == null) {
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await auth(credential);
      }
    } catch (ex, stack) {
      print(ex);
      return SignInError(ex: ex, stack: stack);
    }
  }

  Future<bool> hasCompleteUser() async {
    final profile = await _apiRepository.profile();
    return profile["complete"] == 1;
  }

  Future<bool> update({
    String? firstName,
    String? lastName,
  }) {
    return _apiRepository.updateProfile(firstName: firstName, lastName: lastName);
  }

  Stream<User?> user() {
    return FirebaseAuth.instance.userChanges();
  }
}
