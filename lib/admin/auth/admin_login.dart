import 'package:flutter/material.dart';
import 'package:hospital_app/admin/auth/admin_signup.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';
import 'package:hospital_app/admin/dashboard/admin_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;
  bool hidePin = true;

  bool isValidPin(String pin) {
    final RegExp pinRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
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
                'assets/icons/admin.png',
                width: 132,
                height: 132,
              ),
            ),
          ),

          Positioned(
            top: 260,
            left: 16,
            right: 16,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card_primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Text('LOGIN', style: app_textstyles.sectionTitle),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: hospitalController,
                    decoration: InputDecoration(
                      labelText: 'Hospital Name',
                      labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: pinController,
                    obscureText: hidePin,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Hospital PIN',
                      labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePin ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePin = !hidePin;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 142,
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
                  ),

                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: app_textstyles.body,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminSignup()),
                          );
                        },
                        child: Text(
                          ' Create',
                          style: app_textstyles.body.copyWith(
                            color: AppColors.primary_pressed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    final enteredHospital = hospitalController.text.trim();
    final enteredPin = pinController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final savedHospital = prefs.getString('hospital_name');
    final savedPin = prefs.getString('admin_pin');

    debugPrint('SAVED HOSPITAL: $savedHospital');
    debugPrint('ENTERED HOSPITAL: $enteredHospital');
    debugPrint('SAVED PIN: $savedPin');
    debugPrint('ENTERED PIN: $enteredPin');

    if (savedHospital == null || savedPin == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please signup first')));
      return;
    }

    if (enteredHospital.toLowerCase() != savedHospital.toLowerCase() ||
        enteredPin != savedPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid login credentials')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AdminDashboard(hospitalName: enteredHospital),
      ),
    );
  }

  @override
  void dispose() {
    hospitalController.dispose();
    pinController.dispose();
    super.dispose();
  }
}
