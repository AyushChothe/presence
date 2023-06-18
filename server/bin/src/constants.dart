import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

import 'supabase_helper.dart';

final logger = Logger(
  filter: ProductionFilter(),
  printer: LogfmtPrinter(),
  level: Level.info,
);
final supabaseClient = SupabaseClient(
  const String.fromEnvironment('SUPABASE_URL'),
  const String.fromEnvironment('SUPABASE_KEY'),
);

final supabase = SupabaseService(supabaseClient);
