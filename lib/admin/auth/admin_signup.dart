import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {

  final TextEditingController hospitalController=TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  bool hidePin=true;
  bool isLoading=false;
  bool hideConfirmPin = true;

  bool isValidPin(String pin) {
    final RegExp pinRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return pinRegex.hasMatch(pin);
  }
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }
  bool isValidMobile(String mobile) {
    final RegExp mobileRegex = RegExp(r'^01[3-9]\d{8}$');
    return mobileRegex.hasMatch(mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
         child: SingleChildScrollView(
           child: Container(
             margin: EdgeInsets.symmetric(horizontal: 20),
             padding: EdgeInsets.all(20),
             decoration: BoxDecoration(
               color: AppColors.card_primary,
               borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
               boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.15),
                   blurRadius: 10,
                   offset: Offset(0, 6),

                 )
               ]
             ),
             child: Column(
               children: [
                 Text("Signup",style: app_textstyles.sectionTitle.copyWith(
                   fontSize: 22,
                   fontWeight: FontWeight.w600,
                 ),),
                 SizedBox(height: 20.0,),

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
                 SizedBox(height: 16.0,),

                 TextField(
                   controller: emailController,
                   decoration: InputDecoration(
                     labelText: 'Email',

                       labelStyle: TextStyle(
                         color: AppColors.primary,
                         fontSize: 16,
                     )
                   ),
                 ),
                 SizedBox(height: 16,),
                 TextField(
                   controller: mobileController,
                   decoration: InputDecoration(
                     labelText: 'Mobile Number',
                     labelStyle: TextStyle(
                       color: AppColors.primary,
                       fontSize: 16,
                       ),
                   ),
                 ),
                 SizedBox(height: 16.0,),
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
                 SizedBox(height: 16,),
                 TextField(
                   controller: confirmPinController,
                   obscureText: hidePin,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                     labelText: 'Confirm PIN',
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
                 SizedBox(height: 20,),
                 Center(
                   child: SizedBox(
                     width: 142,
                     child: ElevatedButton(
                       onPressed: isLoading ? null : _signup,
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
                           : const Text('Sign up'),
                     ),
                   ),
                 ),


               ],
             ),
           ),
           
         )),

    );
  }
  void _signup() async{
    final hospitalName = hospitalController.text.trim();
    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final pin = pinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    // Empty field check
    if (hospitalName.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty ||
        pin.isEmpty ||
        confirmPin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    // Email validation
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email format')),
      );
      return;
    }

    // Mobile validation
    if (!isValidMobile(mobile)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid mobile number')),
      );
      return;
    }

    //  Strong PIN validation
    if (!isValidPin(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'PIN must be 8 characters with uppercase, lowercase, number & special character',
          ),
        ),
      );
      return;
    }

    //  Confirm PIN match
    if (pin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN and Confirm PIN do not match')),
      );
      return;
    }
    final prefs =await SharedPreferences.getInstance();
    await prefs.setString('hospital_name', hospitalName);
    await prefs.setString('admin_email', email);
    await prefs.setString('admin_mobile', mobile);
    await prefs.setString('admin_pin', pin);
    debugPrint('SAVED HOSPITAL: ${prefs.getString('hospital_name')}');
    debugPrint('SAVED PIN: ${prefs.getString('admin_pin')}');

    //  SUCCESS
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signup successful')),
    );

    Navigator.pop(context);
  }

}
