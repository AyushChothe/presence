import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

import 'supabase_helper.dart';

final logger = Logger();
final supabaseClient = SupabaseClient(
  const String.fromEnvironment('SUPABASE_URL'),
  const String.fromEnvironment('SUPABASE_KEY'),
);

final supabase = SupabaseService(supabaseClient);
