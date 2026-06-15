import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository {
  Future<User?> getCurrentUser();
  Stream<AuthState> onAuthStateChanged();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUp(String name, String email, String password);
  Future<void> signOut();
}
