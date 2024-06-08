import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OTP Event.dart';
import 'OTP State.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  OtpBloc() : super(OtpInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(OtpLoading());
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            if (!emit.isDone) emit(OtpVerified());
          },
          verificationFailed: (FirebaseAuthException e) {
            if (!emit.isDone) emit(OtpError(e.message ?? 'Verification Failed'));
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            if (!emit.isDone) emit(OtpSent());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      } catch (e) {
        if (!emit.isDone) emit(OtpError(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(OtpLoading());
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: event.otp,
        );
        await _auth.signInWithCredential(credential);
        if (!emit.isDone) emit(OtpVerified());
      } catch (e) {
        if (!emit.isDone) emit(OtpError(e.toString()));
      }
    });
  }
}
