import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendOTP(
      String phoneNumber, Function(String, int) codeSent) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign-in or handle completion
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        codeSent(verificationId, forceResendingToken ?? 0);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto retrieval timeout
      },
    );
  }

  Future<UserCredential> verifyOTP(
      String verificationId, String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }
}
