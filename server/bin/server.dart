import 'dart:io';

import 'package:polo_server/polo_server.dart';

import 'src/auth_transformer.dart';
import 'src/constants.dart';
import 'src/handler.dart';

void main(List<String> args) async {
  try {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.tryParse('0.0.0.0')!;
    // For running in containers, we respect the PORT environment variable.
    final port = int.parse(Platform.environment['PORT'] ?? '3000');
    await supabase.clearPayloads();

    final serverManager = await Polo.createManager(
      address: ip.address,
      port: port,
    );

    serverManager.reqStream =
        serverManager.reqStream.transform(AuthStreamTransformer()).map((e) {
      handleApp(serverManager, e.uri.path);
      return e;
    }).asBroadcastStream();

    logger.i('Server listening on port ${ip.address}:$port');
    handleApp(serverManager, '/_');
  } catch (e) {
    logger.e(e.toString());
  }
}
