import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_chat/screens/chat_screen.dart';
import 'package:happy_chat/services/authentication_service.dart';
import 'package:happy_chat/utils/alert_dialog.dart';
import 'package:happy_chat/widgets/face_detector_view.dart';
import 'package:camera/camera.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authService = AuthenticationService();

  List<CameraDescription> cameras = [];

  int _currentStep = 0;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  late String _verificationId;
  late CameraController _cameraController;

  bool isSmile = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('เข้าสู่ระบบแฮปปี้แชท'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Theme(
          data: ThemeData(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
          ),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _onStepContinue,
            onStepCancel: _currentStep == 1
                ? () => setState(() => _currentStep -= 1)
                : null,
            steps: _buildSteps(),
            controlsBuilder: (context, details) {
              return Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(children: [
                  Expanded(
                      child: FilledButton(
                          onPressed: details.onStepContinue,
                          child: const Text('ต่อไป'))),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: FilledButton(
                          onPressed: details.onStepCancel,
                          child: const Text('ย้อนกลับ'))),
                ]),
              );
            },
          ),
        ));
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('เบอร์โทรศัพท์'),
        subtitle: const Text("ยืนยันเบอร์โทรศัพท์เพื่อรับรหัสผ่าน"),
        content: TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
              labelText: 'กรอกเบอร์โทรศัพท์ ',
              helperText: 'รูปแบบ: +66123456789'),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('ยืนยันรหัส OTP'),
        subtitle: const Text("กรอกรหัส OTP ที่ได้รับทาง SMS"),
        content: TextField(
          controller: _otpController,
          decoration: const InputDecoration(labelText: 'กรอกรหัส OTP'),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('ยิ้มและสแกนใบหน้า'),
        subtitle: const Text("ยิ้มเพื่อเข้าสู่ระบบ"),
        content: Column(
          children: <Widget>[
            // Camera Preview Widget

            _currentStep == 2 && isSmile == false
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 500,
                    height: 500,
                    child: FaceDetectorView(
                      isSmiling: (smile) => {
                        if (smile == true)
                          {
                            setState(() {
                              isSmile = smile;
                            })
                          }
                      },
                    ),
                  )
                : const Row(children: [
                    Icon(
                      Icons.sentiment_very_satisfied,
                    ),
                    SizedBox(width: 8),
                    Text("ดูเหมือนคุณจะอารมณ์ดีแล้วนะ~")
                  ]),

            const SizedBox(height: 8),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('สำเร็จ!'),
        subtitle: const Text("เข้าสู่ระบบสำเร็จ"),
        content: const Text('เข้าสู่ระบบสำเร็จ'),
        isActive: _currentStep >= 3,
      ),
    ];
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      _sendOTP();
    } else if (_currentStep == 1) {
      _verifyOTP();
    } else if (_currentStep == 2) {
      if (isSmile == false) {
        showAlertDialog(
            context, 'ยิ้มก่อน!', 'ทำอารมณ์ให้ดี แล้วเข้าสู่ระบบอีกครั้ง');
        return;
      }
      setState(() {
        _currentStep += 1;
      });
    } else if (_currentStep == 3) {
      _completeLoginProcess();
    }
  }

  void _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      showAlertDialog(context, 'Invalid Phone Number',
          'Please enter a valid phone number ex. +66861234567');
      return;
    }
    try {
      await _authService.sendOTP(phone, (verificationId, resendToken) {
        _verificationId = verificationId;
        setState(() => _currentStep += 1);
      });
    } catch (e) {
      showAlertDialog(
          context, 'เกิดข้อผิดพลาด', 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง');
    }
  }

  void _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) {
      return;
    }

    try {
      await _authService.verifyOTP(_verificationId, _otpController.text.trim());
      setState(() => _currentStep += 1);
    } catch (e) {
      showAlertDialog(
          context, 'รหัสผ่าน OTP ไม่ถูกต้อง', 'กรุณาลองใหม่อีกครั้ง');
    }
  }

  void _completeLoginProcess() {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => ChatScreen(),
    ));
  }

  Future<List<CameraDescription>> _getAvailableCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      return <CameraDescription>[];
    }
  }
}
