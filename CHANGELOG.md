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
