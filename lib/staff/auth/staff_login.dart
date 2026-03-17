import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_app/staff/doctor_select/select_doctor.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool isLoading = false;
  bool hidePin = true;

  bool isValidPin(String pin) {
    final RegExp pinRegex = RegExp(r'^\d{4}$');
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
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
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

                  SizedBox(height: 20),

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
                          ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          :  Text('Login'),
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

  void _login() async {
    final hospital = hospitalController.text.trim();
    final name = nameController.text.trim();
    final pin = pinController.text.trim();

    if (hospital.isEmpty || name.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সব ফিল্ড পূরণ করতে হবে')),
      );
      return;
    }

    if (!isValidPin(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN অবশ্যই ৪ ডিজিট হতে হবে')),
      );
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    final savedHospital = prefs.getString('hospital_name');
    final data = prefs.getString('staffs');

    if (data == null) {
      setState(() => isLoading = false);
      return;
    }

    final staffs = List<Map<String, dynamic>>.from(jsonDecode(data));

    bool isValid = false;

    for (var staff in staffs) {

      if (staff['name'].toLowerCase() == name.toLowerCase() &&
          staff['pin'] == pin &&
          staff['status'] == 'Active') {

        isValid = true;
        break;
      }

    }

    setState(() => isLoading = false);

    if (hospital.toLowerCase() == savedHospital?.toLowerCase() && isValid) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SelectDoctor()),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Invalid Hospital / Name / PIN')),
      );

    }
  }


  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    hospitalController.dispose();
    super.dispose();
  }
}
