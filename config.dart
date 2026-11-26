class AppConfig {
  static const appName = 'AU CHARITY';
  static const paymentMode = 'DEMO';

  // Supply these at build/run time:
  // flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co
  //            --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasSupabase =>
      supabaseUrl.startsWith('https://') && supabaseAnonKey.isNotEmpty;
}
