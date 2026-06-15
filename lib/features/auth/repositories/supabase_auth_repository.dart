import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_repository.dart';

class SupabaseAuthRepository implements IAuthRepository {
  final GoTrueClient _auth;

  SupabaseAuthRepository(this._auth);

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
    final response = await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: null,
    );
    final session = _auth.currentSession;
    Log.i('AuthRepo', 'google signin: ${session?.user.email ?? 'failed'}');
    return session?.user;
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
    await _auth.signOut();
  }
}
