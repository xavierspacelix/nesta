import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key';
}
