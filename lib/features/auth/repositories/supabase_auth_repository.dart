import 'package:google_sign_in/google_sign_in.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_repository.dart';

class SupabaseAuthRepository implements IAuthRepository {
  final GoTrueClient _auth;
  final GoogleSignIn _googleSignIn;

  SupabaseAuthRepository(this._auth)
    : _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Future<User?> getCurrentUser() async {
    Log.d('AuthRepo', 'getCurrentUser');
    try {
      final response = await _auth.getUser();
      Log.d('AuthRepo', 'server user: ${response.user?.email ?? 'null'}');
      return response.user;
    } catch (e) {
      Log.d('AuthRepo', 'getUser() failed, fallback to session: $e');
      final session = _auth.currentSession;
      Log.d('AuthRepo', 'session user: ${session?.user.email ?? 'null'}');
      return session?.user;
    }
  }

  @override
  Stream<AuthState> onAuthStateChanged() {
    return _auth.onAuthStateChange;
  }

  @override
  Future<User?> signInWithGoogle() async {
    Log.i('AuthRepo', 'signInWithGoogle');
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        Log.w('AuthRepo', 'google sign in cancelled');
        return null;
      }
      final authentication = await account.authentication;
      if (authentication.idToken == null) {
        Log.e('AuthRepo', 'no idToken from google', null);
        return null;
      }
      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: authentication.idToken!,
      );
      final user = response.user;
      Log.i('AuthRepo', 'google signin: ${user?.email ?? 'failed'}');
      return user;
    } catch (e) {
      Log.e('AuthRepo', 'google signin error', e);
      rethrow;
    }
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    Log.i('AuthRepo', 'signInWithEmail: $email');
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      Log.i('AuthRepo', 'email login: ${response.user?.email ?? 'failed'}');
      return response.user;
    } catch (e) {
      Log.e('AuthRepo', 'email login failed', e);
      rethrow;
    }
  }

  @override
  Future<User?> signUp(String name, String email, String password) async {
    Log.i('AuthRepo', 'signUp: $name <$email>');
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
      Log.i('AuthRepo', 'signup: ${response.user?.email ?? 'null'}');
      return response.user;
    } catch (e) {
      Log.e('AuthRepo', 'signup failed', e);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    Log.i('AuthRepo', 'signOut');
    await Future.wait<void>([_auth.signOut(), _googleSignIn.disconnect()]);
  }
}
