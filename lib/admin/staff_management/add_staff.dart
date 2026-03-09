
/*marjan hosen Oni
Daffodil international University
*/

import 'package:flutter/material.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';

class AddStaff extends StatefulWidget {
  final String? name;
  final String? role;
  final String? pin;
  AddStaff({this.name,this.role,this.pin,super.key});


  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final nameCtrl = TextEditingController();
  final pinCtrl = TextEditingController();

  String? selectedRole;
  final roleCtrl = TextEditingController();

  final List<String> role =[
    "Counter staff",
    "Nurse",
    "Reception",
  ];
  @override
  void initState()
  {
    super.initState();
    nameCtrl.text=widget.name ?? '';
    pinCtrl.text=widget.pin ?? '';
    roleCtrl.text = widget.role ?? '';
    selectedRole = widget.role;
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
          'Add New Staff',
          style: app_textstyles.appBarTitle.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(child:
      Padding(padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Staff Name",style: app_textstyles.body.copyWith(fontSize: 15),),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColors.primary_text,
                  fontSize: 20,
                ),
                hintText: 'Enter Staff Name',
                hintStyle: TextStyle(color: AppColors.hint_text, fontSize: 16),
              ),
            ),
            SizedBox(height: 10,),
            Text('Role', style: app_textstyles.body),
            const SizedBox(height: 6),

            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ListView(
                      children: role.map((role) {
                        return ListTile(
                          title: Text(role),
                          onTap: () {
                            roleCtrl.text = role;
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              },
              child: TextField(
                controller: roleCtrl,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select Role',
                  hintStyle:
                  TextStyle(color: AppColors.hint_text, fontSize: 16),
                  suffixIcon: Icon(Icons.arrow_drop_down, size: 40),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // PIN
            Text('Create PIN (4 digit)', style: app_textstyles.body),
            const SizedBox(height: 6),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                counterText: '',
                hintText: 'Enter PIN',
                hintStyle: TextStyle(color: AppColors.hint_text,fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            /// Save Button
            Center(
              child: GestureDetector(
                onTap: () {

                  if (nameCtrl.text.isEmpty ||
                      roleCtrl.text.isEmpty ||
                      pinCtrl.text.length != 4) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all fields correctly'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'name': nameCtrl.text,
                    'role': roleCtrl.text,
                    'pin': pinCtrl.text,
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
      )
      ),
    );
  }
  @override
  void dispose() {
    nameCtrl.dispose();
    roleCtrl.dispose();
    pinCtrl.dispose();
    super.dispose();
  }

}
