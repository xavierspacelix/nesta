import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static String get supabaseUrl {
    const dartDefine = String.fromEnvironment('SUPABASE_URL');
    if (dartDefine.isNotEmpty) return dartDefine;
    return dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';
  }

  static String get supabaseAnonKey {
    const dartDefine = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (dartDefine.isNotEmpty) return dartDefine;
    return dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key';
  }
}
