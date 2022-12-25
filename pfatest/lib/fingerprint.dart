import 'package:local_auth/local_auth.dart';

class FingerPrint{
  final LocalAuthentication _localAuthentication=LocalAuthentication();

  Future<bool> isFingerPrintEnabled()async{
    bool fingerPrintEnabel= await _localAuthentication.canCheckBiometrics;
    return fingerPrintEnabel;
  }
  Future<bool> isAuth(String reason) async{
    bool auth =await _localAuthentication.authenticate(localizedReason: reason,
      options: const AuthenticationOptions(biometricOnly: true),
    );
    return auth;
}
}