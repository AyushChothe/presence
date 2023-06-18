import 'dart:async';
import 'dart:io';

import 'constants.dart';

class AuthStreamTransformer
    extends StreamTransformerBase<HttpRequest, HttpRequest> {
  AuthStreamTransformer();

  @override
  Stream<HttpRequest> bind(Stream<HttpRequest> stream) async* {
    await for (final e in stream) {
      final app = await supabase.getAppData(e.uri.path.replaceAll('/', ''));

      if (app.isNotEmpty && app['key'] == e.uri.queryParameters['key']) {
        yield e;
      } else {
        await e.response.close();
      }
    }
  }
}
