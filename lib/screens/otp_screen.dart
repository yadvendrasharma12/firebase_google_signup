
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'home_screen.dart'; // Make sure to import your HomeScreen

class StylishOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber; // ✅ Added phone number
  const StylishOtpScreen({Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  State<StylishOtpScreen> createState() => _StylishOtpScreenState();
}

class _StylishOtpScreenState extends State<StylishOtpScreen> {
  TextEditingController otpController = TextEditingController();
  bool isResending = false;

  /// ✅ Verify OTP function with logs
  void verifyOtp() async {
    String otp = otpController.text.trim();
    print("👉 verifyOtp() called");
    print("📌 OTP entered: $otp");

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ OTP must be 6 digits"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      print("✅ OTP verified successfully: $userCredential");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ OTP Verified!"),
          backgroundColor: Colors.green,
        ),
      );

      // ✅ Navigate to HomeScreen after verification
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } catch (ex) {
      print("❌ OTP verification failed: ${ex.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Verification Failed: ${ex.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// ✅ Resend OTP function
  void resendOtp() async {
    setState(() {
      isResending = true;
    });
    print("🔄 Resend OTP pressed");

    // Call your previous sendOTP() method here
    await Future.delayed(const Duration(seconds: 2)); // simulate delay

    setState(() {
      isResending = false;
    });
    print("✅ OTP resent successfully");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🔄 OTP resent!"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        title: const Text("OTP verification", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                "assets/otp.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),

              /// ✅ Show phone number
              Text(
                "OTP sent to ${widget.phoneNumber}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                "Enter the 6-digit code sent to your mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),

              /// PIN CODE FIELDS
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                autoFocus: true,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  inactiveColor: Colors.grey,
                  activeColor: Colors.blue,
                  selectedColor: Colors.blueAccent,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  inactiveFillColor: Colors.grey.shade200,
                  fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                enableActiveFill: true,
                onChanged: (value) {
                  print("⌨️ User typing: $value");
                },
              ),
              const SizedBox(height: 20),

              /// VERIFY BUTTON
              ElevatedButton(
                onPressed: verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify OTP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              /// RESEND OTP
              TextButton(
                onPressed: isResending ? null : resendOtp,
                child: isResending
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Resend OTP",
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
