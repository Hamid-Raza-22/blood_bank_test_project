import 'dart:io';

/// Network Info - Check internet connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Network Info Implementation
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
