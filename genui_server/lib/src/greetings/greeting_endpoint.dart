import 'package:serverpod/serverpod.dart';

/// Endpoint providing a simple health check or ping for the Serverpod connection.
class GreetingEndpoint extends Endpoint {
  Future<bool> ping(Session session) async {
    return true;
  }
}
