import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_signin/screens/otp_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();

  /// ✅ Validate phone number (10 digits)
  bool isValidPhone(String phone) {
    final regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(phone);
  }

  void sendOTP() async {
    print("📌 sendOTP() called");

    String phone = phoneController.text.trim();
    print("👉 Raw input: $phone");

    if (!isValidPhone(phone)) {
      print("❌ Invalid phone number entered: $phone");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit number")),
      );
      return;
    }

    if (phone.startsWith("0")) {
      print("⚠️ Number starts with 0, removing leading zero");
      phone = phone.substring(1);
    }

    String mobileNumber = "+91$phone";
    print("✅ Final formatted number (E.164): $mobileNumber");

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("✅ verificationCompleted called with credential: $credential");
          await FirebaseAuth.instance.signInWithCredential(credential);
          print("🎉 Auto verification successful, user signed in");
        },
        verificationFailed: (FirebaseAuthException ex) {
          print("❌ verificationFailed: ${ex.code} | ${ex.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${ex.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken,) {
          print("📩 OTP sent to $mobileNumber");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StylishOtpScreen(verificationId: verificationId,phoneNumber: phoneController.text,),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("⏳ codeAutoRetrievalTimeout called. Verification ID: $verificationId");
        },
      );
    } catch (e) {
      print("🔥 Exception during verifyPhoneNumber: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("📱 PhoneAuthScreen build() called");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text("Phone number verification",style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),

              /// ✅ Top Image
              Image.asset(
                "assets/mobile.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 30),

              /// ✅ Title Text
              const Text(
                "Enter your mobile number",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We will send you a 6-digit OTP for verification",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              /// ✅ Phone Input Field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                  prefixText: "+91 ",
                  labelText: "Phone Number",
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                onChanged: (value) {
                  print("⌨️ User typing: $value");
                },
              ),
              const SizedBox(height: 30),

              /// ✅ Send OTP Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(

                  onPressed: sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Send OTP",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
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
