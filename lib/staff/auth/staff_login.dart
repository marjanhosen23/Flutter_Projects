import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool isLoading = false;
  bool hidePin = true;

  bool isValidPin(String pin) {
    final RegExp pinRegex = RegExp(r'^\d{4,}$'); // minimum 4 digit numeric
    return pinRegex.hasMatch(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 100,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/icons/staff.png',
                width: 132,
                height: 132,
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: 16,
            right: 16,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card_primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'LOGIN',
                      style: app_textstyles.sectionTitle,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: pinController,
                    obscureText: hidePin,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Staff PIN',
                      labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePin
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePin = !hidePin;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_pressed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Login'),
                    ),
                  ),

                   SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    final name = nameController.text.trim();
    final pin = pinController.text.trim();

    debugPrint('PIN="$pin" LENGTH=${pin.length}');

    if (name.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name এবং Staff PIN দিতে হবে'),
        ),
      );
      return;
    }

    if (!isValidPin(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff PIN অবশ্যই ঠিক ৪ ডিজিট নাম্বার হবে'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
      // Navigate to Staff Dashboard
    });
  }


  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    super.dispose();
  }
}
