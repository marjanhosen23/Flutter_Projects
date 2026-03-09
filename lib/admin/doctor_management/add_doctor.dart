/*marjan hosen Oni
Daffodil international University
*/

import 'package:flutter/material.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';

class AddDoctor extends StatefulWidget {
  final String? name;
  final String? dept;
  final String? time;

  AddDoctor({this.name, this.dept, this.time, super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final nameCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  String? selectedDept;

  final deptCtrl = TextEditingController();

  final List<String> departments = [
    'General Medicine',
    'General Surgery',
    'Pediatrics',
    'Obstetrics & Gynecology',
    'Orthopedics',
    'Cardiology',
    'Neurology',
    'Pulmonology',
    'Gastroenterology',
    'Nephrology',
    'Urology',
    'Dermatology',
    'Psychiatry',
    'Ophthalmology',
    'ENT',
    'Endocrinology',
    'Rheumatology',
    'Hematology',
    'Oncology',
    'Infectious Diseases',
  ];
  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.name ?? '';
    timeCtrl.text = widget.time ?? '';
    deptCtrl.text = widget.dept ?? '';
    selectedDept = widget.dept;
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
          'Add New Doctor',
          style: app_textstyles.appBarTitle.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(child:
      Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Name',
              style: app_textstyles.body.copyWith(fontSize: 15),
            ),

            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColors.primary_text,
                  fontSize: 20,
                ),
                hintText: 'Enter Doctor Name',
                hintStyle: TextStyle(color: AppColors.hint_text, fontSize: 16),
              ),
            ),
            SizedBox(height: 10,),
            Text('Department',style: app_textstyles.body.copyWith(fontSize: 15)),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ListView(
                      children: departments.map((dept) {
                        return ListTile(
                          title: Text(dept),
                          onTap: () {
                            deptCtrl.text = dept;
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              },
              child: TextField(
                controller: deptCtrl,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select Department',
                  hintStyle: TextStyle(color: AppColors.body_text, fontSize: 16),
                  suffixIcon: Icon(Icons.arrow_drop_down,size: 40,),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('Avg Time',style: app_textstyles.body.copyWith(fontSize: 15)),
            TextField(
              controller: timeCtrl,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColors.primary_text,
                  fontSize: 20,
                ),
                hintText: '5 min/Patient',
                hintStyle: TextStyle(color: AppColors.hint_text, fontSize: 16),
              ),
            ),
            SizedBox(height: 40),

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, {
                    'name': nameCtrl.text,
                    'dept': deptCtrl.text,
                    'time': timeCtrl.text,
                  });
                },
                child: Container(
                  width: 160,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: app_textstyles.appBarTitle.copyWith(
                        fontSize: 20,

                      ),
                    ),
                  ),
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
