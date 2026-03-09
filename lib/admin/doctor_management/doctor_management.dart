import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital_app/admin/dashboard/admin_dashboard.dart';
import 'package:hospital_app/admin/doctor_management/add_doctor.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorManagement extends StatefulWidget {
  const DoctorManagement({super.key});

  @override
  State<DoctorManagement> createState() => _DoctorManagementState();
}

class _DoctorManagementState extends State<DoctorManagement> {
  List<Map<String, String>> doctors = [];

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  void loadDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('doctors');

    if (data != null) {
      setState(() {
        doctors = List<Map<String, String>>.from(jsonDecode(data));
      });
    }
  }

  void saveDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('doctors', jsonEncode(doctors));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/icons/arrow.png', color: Colors.white),
        ),
        title: Text(
          'Doctor Management',
          style: app_textstyles.appBarTitle.copyWith(
            color: AppColors.inputColor,
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final newDoctor = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddDoctor()),
              );

              if (newDoctor != null) {
                setState(() {
                  doctors.add(newDoctor);
                });
                saveDoctors();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 227,
                height: 53,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/plus.png', height: 21),
                    const SizedBox(width: 10),
                    Text('Add New Doctor', style: app_textstyles.appBarTitle),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(
                  name: doctors[index]['name']!,
                  dept: doctors[index]['dept']!,
                  time: doctors[index]['time']!,
                  onRemove: () {
                    setState(() {
                      doctors.removeAt(index);
                    });
                    saveDoctors();
                  },
                  onEdit: () async {
                    final updatedDoctor = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddDoctor(
                          name: doctors[index]['name'],
                          dept: doctors[index]['dept'],
                          time: doctors[index]['time'],
                        ),
                      ),
                    );

                    if (updatedDoctor != null) {
                      setState(() {
                        doctors[index] = updatedDoctor;
                      });
                      saveDoctors();
                    }
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

class DoctorCard extends StatelessWidget {
  final String name;
  final String dept;
  final String time;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const DoctorCard({
    super.key,
    required this.name,
    required this.dept,
    required this.time,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card_primary,
        border: Border.all(color: AppColors.card_highlight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: app_textstyles.body.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Department : $dept',
            style: app_textstyles.body.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 6),
          Text(
            'Avg Time : $time',
            style: app_textstyles.body.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              actionButton('Edit', onEdit),
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
          color: AppColors.app_bar,
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
