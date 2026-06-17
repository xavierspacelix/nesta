## [1.2.1] - 2026-06-17

### Fixed
- **Google Login redirect**: Welcome screen sekarang pakai `ref.listen` untuk navigasi — lebih robust daripada `onPressed` callback yang context-nya bisa stale setelah widget rebuild.
- **Changelog di Version Screen**: `updateCheckProvider` sekarang selalu return data versi, jadi changelog tetap tampil meskipun sudah di versi terbaru.
- **Join house**: Hapus `textCapitalization` yang bikin input jadi UPPERCASE sementara kode di DB lowercase. Input sekarang di-lowercase sebelum dikirim ke DB.
- **CI/CD**: Release workflow JSON payload gagal karena changelog multiline tidak di-escape. Sekarang pakai `jq --rawfile` dan heredoc untuk handle encoding otomatis.

### Added
- `scripts/release.sh` — script lokal untuk insert `app_versions` ke Supabase
- **Notifikasi**: FCM service diinisialisasi dari `SplashScreen` (bukan lazy dari screen lain)
- **Permission notifikasi**: `requestPermission()` dipanggil di `init()` sebelum `getToken()`, jadi dialog izin notifikasi muncul saat pertama kali app dibuka
- **Toggle notifikasi di Settings**: Switch notifikasi sekarang benar-benar minta permission saat diaktifkan, dan cancel scheduled notifications saat dinonaktifkan

## [1.2.0] - 2026-06-17

### Added
- Native Google Sign-In via `google_sign_in` package (replaces OAuth redirect)
- Firebase Core initialization on app startup
- Google Services Gradle plugin for Android
- Android deep link callback intent filter for auth redirects
- `firebase_core` and `google_sign_in` as direct dependencies
- `scripts/release.sh` — script lokal untuk insert `app_versions` ke Supabase

### Changed
- Google auth flow: `signInWithOAuth` → `signInWithIdToken` (native token-based)
- Welcome screen: Google login now awaits auth and navigates based on `houseId`
- `signOut` now disconnects Google account in addition to Supabase session

### Fixed
- Missing `google_sign_in` import in `supabase_auth_repository.dart`
- `Future.wait` type inference error with explicit type parameter
- Post-Google-login redirect: user no longer stuck on welcome screen after successful login
- **CI/CD**: Release workflow JSON payload gagal karena changelog multiline tidak di-escape. Sekarang pakai `jq --rawfile` dan heredoc untuk handle encoding otomatis.
