import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluxtodo/services/auth_Service.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 45;
  bool wait = false;
  String buttonName = 'send';
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = '';
  String smsCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5665b1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5665b1),
        title: Text(
          'Sign Up With Phone',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              textField(),
              const SizedBox(
                height: 32,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    Text(
                      'Enter Verification Code',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              otpField(),
              const SizedBox(
                height: 40,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Send Verification Code again in ',
                      style: TextStyle(fontSize: 14, color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: '00:$start ',
                      style: TextStyle(fontSize: 18, color: Colors.redAccent),
                    ),
                    TextSpan(
                      text: 'sec',
                      style: TextStyle(fontSize: 14, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: (){
                  authClass.signInwithPhoneNumber(verificationIdFinal, smsCode, context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text('Lets Go',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 30,
      fieldWidth: 48,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Color(0xFF5675c1),
        borderColor: Colors.white,
      ),
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
          color: const Color(0xFF5675c1),
          borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        controller: phoneController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your Phone Number",
          hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            child: Text(
              '(+90)',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait
                ? null
                : () async {
                    startTimer();
                    setState(() {
                      start = 45;
                      wait = true;
                      buttonName = 'resend';
                    });
                    await authClass.verifyPhoneNumber(
                        '+90 ${phoneController.text}', context, setData);
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
              child: Text(
                buttonName,
                style: TextStyle(
                    color: wait ? Colors.grey : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
