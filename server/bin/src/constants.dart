import 'dart:io';

import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

import 'supabase_helper.dart';

final logger = Logger(
  filter: ProductionFilter(),
  printer: LogfmtPrinter(),
  level: Level.info,
);
final supabaseClient = SupabaseClient(
  Platform.environment['SUPABASE_URL']!,
  Platform.environment['SUPABASE_KEY']!,
);

final supabase = SupabaseService(supabaseClient);
