import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital_app/admin/staff_management/add_staff.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffManagement extends StatefulWidget {
  const StaffManagement({super.key});

  @override
  State<StaffManagement> createState() => _StaffManagementState();
}

class _StaffManagementState extends State<StaffManagement> {
  List<Map<String, dynamic>> staffs = [];

  @override
  void initState() {
    super.initState();
    loadStaffs();
  }

  void loadStaffs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('staffs');

    if (data != null) {
      setState(() {
        staffs = List<Map<String, String>>.from(jsonDecode(data));
      });
    }
  }

  void saveStaffs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('staffs', jsonEncode(staffs));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset('assets/icons/arrow.png', color: Colors.white),
        ),
        title: Text(
          'Staff Management',
          style: app_textstyles.appBarTitle.copyWith(
            color: AppColors.inputColor,
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final newStaff = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddStaff()),
              );

              if (newStaff != null) {
                setState(() {
                  staffs.add(newStaff);
                });
                saveStaffs();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 220,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/plus.png',height: 21,),
                    const SizedBox(width: 8),
                    Text('Add New Staff', style: app_textstyles.appBarTitle),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: staffs.length,
              itemBuilder: (context, index) {
                return StaffCard(
                  name: staffs[index]['name']!,
                  role: staffs[index]['role']!,
                  pin: staffs[index]['pin']!,
                  status: staffs[index]['status']!,
                  onRemove: () {
                    setState(() {
                      staffs.removeAt(index);
                    });
                    saveStaffs();
                  },
                  onChangePin: () {
                    setState(() {
                      staffs[index]['pin'] = '0000';
                    });
                    saveStaffs();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class StaffCard extends StatelessWidget {
  final String name;
  final String role;
  final String pin;
  final String status;
  final VoidCallback onRemove;
  final VoidCallback onChangePin;

  const StaffCard({
    super.key,
    required this.name,
    required this.role,
    required this.pin,
    required this.status,
    required this.onRemove,
    required this.onChangePin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card_primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: app_textstyles.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text('Role: $role',style: app_textstyles.body.copyWith(
            fontSize: 18,
          ),),
          Text('PIN: ****',style: app_textstyles.body.copyWith(
            fontSize: 18,
          ),),
          Text('Status: $status',style: app_textstyles.body.copyWith(
            fontSize: 18,
          ),),

          const SizedBox(height: 12),

          Row(
            children: [
              actionButton('Change Pin', onChangePin),
              const SizedBox(width: 12),
              actionButton('Remove', onRemove),
            ],
          ),
        ],
      ),
    );
  }
}
Widget actionButton(String title, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ),
  );
}
