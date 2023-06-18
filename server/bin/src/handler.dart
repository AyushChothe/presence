// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:polo_server/polo_server.dart';

import 'constants.dart';

void handleApp(Polo serverManager, String namsepace) {
  if (serverManager.hasNamespace(namsepace)) return;

  logger.i('App "$namsepace" started listening');

  final dio = Dio();
  dio.interceptors.add(RetryInterceptor(dio: dio, logPrint: logger.i));
  final app = serverManager.of(namsepace);
  final appId = namsepace.replaceFirst('/', '');

  // Function to handle user join
  Future<void> onPresence(PoloClient client, Map<String, dynamic> data) async {
    try {
      // Strore Data
      final record = {
        'app_id': appId,
        'client_id': client.id,
        'payload': data,
      };
      await supabase.insertPayload(record);

      // Trigger WebHook Connected
      final appData = await supabase.getAppData(appId);
      final webhook = appData['webhook'] as String;
      dio
          .post<dynamic>(webhook, data: {
            ...record,
            'status': 'connected',
            'at': DateTime.now().toUtc().toIso8601String()
          })
          .catchError((Object? e) => logger.e(e.toString()))
          .ignore();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // Function to handel user leave
  Future<void> onDiconnect(String clientId, _, __) async {
    try {
      logger.i('Client disconnected: $clientId');
      // Delete Data
      final record = await supabase.deletePayload(clientId);

      // Trigger WebHook Disconnected
      final appData = await supabase.getAppData(appId);
      final webhook = appData['webhook'] as String;
      dio
          .post<dynamic>(webhook, data: {
            'app_id': record['app_id'],
            'client_id': record['client_id'],
            'payload': record['payload'],
            'status': 'disconnected',
            'at': DateTime.now().toUtc().toIso8601String()
          })
          .catchError((Object? e) => logger.e(e.toString()))
          .ignore();
    } catch (e) {
      logger.e(e.toString());
    }
  }

// Main app
  app
    ..onClientConnect = ((PoloClient client) {
      logger.i('New client connected: ${client.id}');
      client.onEvent<Map<String, dynamic>>(
          'presence', (data) => onPresence(client, data));
    })
    ..onClientDisconnect = onDiconnect;
}
