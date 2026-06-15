import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nesta/core/services/logger.dart';
import '../repositories/auth_repository.dart';
import '../repositories/supabase_auth_repository.dart';

enum AuthStatus { unauthenticated, loading, authenticated }

class AuthState {
  final AuthStatus status;
  final String? userName;
  final String? email;
  final String? userId;
  final String? houseId;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.userName,
    this.email,
    this.userId,
    this.houseId,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userName,
    String? email,
    String? userId,
    String? houseId,
  }) {
    return AuthState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      houseId: houseId ?? this.houseId,
    );
  }
}

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client.auth);
});

class AuthNotifier extends Notifier<AuthState> {
  late final IAuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return const AuthState();
  }

  Future<String?> _fetchHouseId(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('house_id')
          .eq('id', userId)
          .maybeSingle();
      if (response == null) return null;
      final houseId = response['house_id'] as String?;
      Log.d('Auth', 'houseId for $userId: ${houseId ?? 'null'}');
      return houseId;
    } catch (e) {
      Log.e('Auth', 'fetchHouseId failed', e);
      return null;
    }
  }

  Future<void> checkSession() async {
    Log.i('Auth', 'checkSession');
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        Log.i('Auth', 'session found: ${user.email}');
        final metadata = user.userMetadata;
        final houseId = await _fetchHouseId(user.id);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userName: metadata?['full_name'] as String? ?? user.email?.split('@').first ?? 'User',
          email: user.email,
          userId: user.id,
          houseId: houseId,
        );
      } else {
        Log.w('Auth', 'no session');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      Log.e('Auth', 'checkSession error', e);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> loginWithGoogle() async {
    Log.i('Auth', 'loginWithGoogle');
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        Log.i('Auth', 'google login ok: ${user.email}');
        final metadata = user.userMetadata;
        final houseId = await _fetchHouseId(user.id);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userName: metadata?['full_name'] as String? ?? user.email?.split('@').first ?? 'User',
          email: user.email,
          userId: user.id,
          houseId: houseId,
        );
      } else {
        Log.w('Auth', 'google login returned null');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      Log.e('Auth', 'google login error', e);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    Log.i('Auth', 'loginWithEmail: $email');
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authRepository.signInWithEmail(email, password);
      if (user != null) {
        Log.i('Auth', 'email login ok: $email');
        final metadata = user.userMetadata;
        final houseId = await _fetchHouseId(user.id);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userName: metadata?['full_name'] as String? ?? email.split('@').first,
          email: email,
          userId: user.id,
          houseId: houseId,
        );
      } else {
        Log.w('Auth', 'email login returned null');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      Log.e('Auth', 'email login error', e);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<User?> register(String name, String email, String password) async {
    Log.i('Auth', 'register: $name <$email>');
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authRepository.signUp(name, email, password);
      if (user != null) {
        Log.i('Auth', 'register ok: ${user.id}');
        final houseId = await _fetchHouseId(user.id);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userName: name,
          email: email,
          userId: user.id,
          houseId: houseId,
        );
      } else {
        Log.w('Auth', 'register returned null (email confirmation needed)');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
      return user;
    } catch (e) {
      Log.e('Auth', 'register error', e);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return null;
    }
  }

  void setSessionFromUser(User user, {String? houseId}) {
    Log.d('Auth', 'setSessionFromUser: ${user.email} houseId=$houseId');
    final metadata = user.userMetadata;
    state = AuthState(
      status: AuthStatus.authenticated,
      userName: metadata?['full_name'] as String? ?? user.email?.split('@').first ?? 'User',
      email: user.email,
      userId: user.id,
      houseId: houseId,
    );
  }

  void logout() {
    Log.i('Auth', 'logout');
    _authRepository.signOut();
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final currentUserProvider = Provider<String>((ref) {
  final authState = ref.watch(authProvider);
  return authState.userName ?? 'Budi';
});
