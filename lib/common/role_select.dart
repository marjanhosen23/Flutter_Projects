import 'package:flutter/material.dart';
import 'package:hospital_app/admin/auth/admin_login.dart';
import 'package:hospital_app/patient/hospital/hospital_list.dart';
import 'package:hospital_app/staff/auth/staff_login.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';

class RoleSelect extends StatefulWidget {
   RoleSelect({super.key});

  @override
  State<RoleSelect> createState() => _RoleSelectState();
}

class _RoleSelectState extends State<RoleSelect> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.screen_top,
                AppColors.screen_bottom,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 10,
                offset: Offset(0, 6),
              )
            ]

        ),
        child: Stack(
          children: [
            Positioned(
              left: 80,
              top: 70,
              child: Image.asset(
                'assets/images/select_page_image.png',
                width: 230,
                height: 319,
              ),
            ),
            Positioned(
              top: 320,
              left: 13,
              right: 13,
              child: Container(
                padding:  EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inputColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "আপনি কে?",
                      style: app_textstyles.sectionTitle,
                    ),
                     SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            roleCard('User', 'assets/icons/woman.png'),
                             SizedBox(height: 20),
                            roleCard('Admin', 'assets/icons/admin.png'),
                          ],
                        ),
                         SizedBox(width: 20),
                        roleCard('Staff', 'assets/icons/staff.png'),
                      ],
                    ),
                     SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(selectedRole.isEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content:Text('আগে একটি Role নির্বাচন করুন') ));
                              return;
                            }
                          if(selectedRole == 'User')
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (_) =>  HospitalList()));
                            }
                          else if(selectedRole == 'Staff')
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (_) =>  StaffLogin()));
                            }
                          else if(selectedRole== 'Admin')
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (_) =>  AdminLogin()));
                            }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: app_textstyles.button,
                            ),
                             SizedBox(width: 8),
                            Image.asset(
                              'assets/icons/right-arrow.png',
                              width: 18,
                              height: 18,
                              color: Colors.white,

                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roleCard(String title, String imagePath) {
    bool isSelected = selectedRole == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
      },
      child: Container(
        width: 140,
        padding:  EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card_primary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.card_highlight,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 10,
              offset: Offset(0, 6),

            )
          ]
        ),
        child: Column(
          children: [
            Image.asset(imagePath, width: 72, height: 72), SizedBox(height: 8),
            Text(title, style: app_textstyles.cardTitle),
          ],
        ),
      ),
    );
  }
}