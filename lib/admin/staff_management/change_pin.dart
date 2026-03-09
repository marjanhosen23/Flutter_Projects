import 'package:flutter/material.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';

class ChangePin extends StatefulWidget {
  final String oldPin;

  const ChangePin({super.key, required this.oldPin});

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  final TextEditingController pinCtrl = TextEditingController();
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
          "Change PIN",
          style: app_textstyles.appBarTitle.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create PIN (4 digit)"),

            SizedBox(height: 10),

            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Enter new PIN',
                hintStyle: TextStyle(
                  color: AppColors.hint_text,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (pinCtrl.text.length != 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("PIN must be 4 digit")),
                    );

                    return;
                  }

                  Navigator.pop(context, pinCtrl.text);
                },

                child: Text(
                  "Save",
                  style: app_textstyles.appBarTitle.copyWith(
                    fontSize: 20,

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
