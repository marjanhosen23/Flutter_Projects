import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';

class SelectDoctor extends StatefulWidget {
  const SelectDoctor({super.key});

  @override
  State<SelectDoctor> createState() => _SelectDoctorState();
}

class _SelectDoctorState extends State<SelectDoctor> {
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> selectedDoctors = [];

  TextEditingController searchCtrl = TextEditingController();
  String searchText = "";

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
        doctors = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = doctors.where((doctor) {
      final name = (doctor['name'] ?? "").toLowerCase();
      return name.contains(searchText);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Doctors",
          style: app_textstyles.appBarTitle.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Serach Doctors',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: AppColors.card_primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),

            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  bool isSelected = selectedDoctors.contains(doctor);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card_primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          activeColor: AppColors.icon_color,
                          onChanged: (value) {
                            setState(() {
                              if (isSelected) {
                                selectedDoctors.remove(doctor);
                              } else {
                                selectedDoctors.add(doctor);
                              }
                            });
                          },
                        ),

                        Text(
                          doctor['name'] ?? '',
                          style: app_textstyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

        bottomNavigationBar: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              prefs.setString(
                'selected_doctors',
                jsonEncode(selectedDoctors),
              );

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "Confirm",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    );
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
