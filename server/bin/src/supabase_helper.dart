import 'package:supabase/supabase.dart';

class SupabaseService {
  SupabaseService(this._client);
  late final SupabaseClient _client;

  SupabaseQueryBuilder get apps => _client.from('apps');
  SupabaseQueryBuilder get payloads => _client.from('payloads');

  Future<PostgrestMap> getAppData(String appId) async =>
      await apps.select<PostgrestMap>().eq('uid', appId).limit(1).single();

  Future<void> insertPayload(PostgrestMap payload) async =>
      await payloads.insert(payload);

  Future<PostgrestMap> deletePayload(String clientId) async => payloads
      .delete()
      .eq('client_id', clientId)
      .select<PostgrestMap>()
      .single()
      .catchError((_) => null);

  Future<void> clearPayloads() async =>
      await payloads.delete().neq('client_id', '0');
}
