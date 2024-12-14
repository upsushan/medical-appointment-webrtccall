import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  // Check if biometric authentication is possible
  Future<bool> canCheckBiometrics() async {
    try {
      print('Hello');
      return await auth.canCheckBiometrics;
    } catch (e) {
      print('Error checking biometric capabilities: $e');
      return false;
    }
  }

  // Get available biometric types (Face ID, fingerprint, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await auth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return <BiometricType>[];
    }
  }

  // Authenticate using biometrics
  Future<bool> authenticate() async {
    print('Hello');
    final isAvailable = await canCheckBiometrics();
    if (!isAvailable) {
      return false;
    }

    try {
      return await auth.authenticate(
        localizedReason: 'Scan your fingerprint or face to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print('Error during authentication: $e');
      return false;
    }
  }
}