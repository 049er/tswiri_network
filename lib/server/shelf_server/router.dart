import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'handlers.dart';

Router router() {
  Router app = Router();

  app.post('/upload', imageReceiveHandler);
  app.get('/test', testHandler);
  app.get('/ws', _webSocketHandler());

  return app;
}

Handler _webSocketHandler() {
  return webSocketHandler((webSocket) {
    // clients.add(WsClient(ws: webSocket));
  });
}
