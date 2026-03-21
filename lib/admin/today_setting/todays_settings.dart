import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_app/theme/app_colors.dart';
import 'package:hospital_app/theme/app_textstyles.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TodaysSettings extends StatefulWidget {
  const TodaysSettings({super.key});

  @override
  State<TodaysSettings> createState() => _TodaysSettingsState();
}

class _TodaysSettingsState extends State<TodaysSettings> {
  List<Map<String, dynamic>> doctors = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadDoctors();
    updateStatus();

    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      updateStatus();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    searchCtrl.dispose();
    startCtrl.dispose();
    endCtrl.dispose();
    super.dispose();
  }

  void loadDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('doctors');

    if (data != null) {
      final decoded = List<Map<String, dynamic>>.from(jsonDecode(data));

      for (var doctor in decoded) {
        doctor['status'] ??= "Not Started";
        doctor['startTime'] ??= null;
        doctor['endTime'] ??= null;
        doctor['shift'] ??= "Morning";
        doctor['active'] ??= false;
        doctor['serialStart'] ??= 1;
        doctor['nowServing'] ??= 0;
      }

      setState(() {
        doctors = decoded;
      });
    }
  }

  String todayDate = DateFormat("dd MMM yyyy").format(DateTime.now());

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String status = "Not Started";
  String shift = "Morning";

  TextEditingController startCtrl = TextEditingController();
  TextEditingController endCtrl = TextEditingController();

  TextEditingController searchCtrl = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = doctors.where((doctor) {
      final name = (doctor['name'] ?? "").toLowerCase();
      return name.contains(searchText);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/icons/arrow.png', color: Colors.white),
        ),

        title: Text(
          "Today's Settings",
          style: app_textstyles.appBarTitle.copyWith(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  hintText: "Search Doctor",
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

              SizedBox(height: 15),

              Text(
                "Date: $todayDate",
                style: app_textstyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Active Doctors",
                style: app_textstyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  Color statusColor = Colors.grey;

                  if (doctor['status'] == "Running") {
                    statusColor = Colors.green;
                  } else if (doctor['status'] == "Paused") {
                    statusColor = Colors.orange;
                  } else if (doctor['status'] == "Finished") {
                    statusColor = Colors.red;
                  }

                  String doctorStatus = status;

                  if (doctor['active'] == false) {
                    doctorStatus = "Off Duty";
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: AppColors.card_primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: doctor['status'] == "Running"
                            ? Colors.green
                            : doctor['status'] == "Paused"
                            ? Colors.orange
                            : doctor['status'] == "Finished"
                            ? Colors.red
                            : doctor['active'] == true
                            ? AppColors.card_highlight
                            : Colors.transparent,
                        width: 2,
                      ),
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
                        Row(
                          children: [
                            Checkbox(
                              value: doctor['active'] ?? false,
                              activeColor: AppColors.icon_color,
                              checkColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  doctor['active'] = value;

                                  if (value == true) {
                                    doctor['status'] = "Not Started";
                                  } else {
                                    doctor['status'] = "Off Duty";
                                  }
                                });
                              },
                            ),
                            Text(
                              doctor['name'] ?? '',
                              style: app_textstyles.appBarTitle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 05),

                        Row(
                          children: [
                            const Text("Shift : "),

                            const SizedBox(width: 10),

                            DropdownButton<String>(
                              value: doctor['shift'] ?? "Morning",
                              items: ["Morning", "Evening"]
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  doctor['shift'] = value;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Start : ${doctor['startTime'] != null ? doctor['startTime'].format(context) : '--'}",
                              style: app_textstyles.body,
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (picked != null) {
                                  setState(() {
                                    doctor['startTime'] = picked;
                                  });
                                }
                              },
                              child: Text(
                                "Select",
                                style: app_textstyles.inputText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "End : ${doctor['endTime'] != null ? doctor['endTime'].format(context) : '--'}",
                              style: app_textstyles.body,
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (picked != null) {
                                  setState(() {
                                    doctor['endTime'] = picked;
                                  });
                                }
                              },
                              child: Text(
                                "Select",
                                style: app_textstyles.inputText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        Text(
                          "Status : ${doctor['status'] ?? 'Not Started'}",
                          style: app_textstyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        SizedBox(height: 05),
                        Text("Serial Start: ${doctor['serialStart']}"),
                        SizedBox(height: 05),
                        Text("Now Serving: ${doctor['nowServing']}"),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            ElevatedButton(
                              onPressed: (doctor['status'] != "Running")
                                  ? null
                                  : () {
                                setState(() {
                                  doctor['paused'] = true;
                                  doctor['status'] = "Paused";
                                });
                              },
                              child: Text(
                                "Pause",
                                style: app_textstyles.inputText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            ElevatedButton(
                              onPressed: (doctor['status'] != "Paused")
                                  ? null
                                  : () {
                                setState(() {
                                  doctor['paused'] = false;
                                  doctor['status'] = "Running";
                                });
                              },
                              child: Text(
                                "Start",
                                style: app_textstyles.inputText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var doctor in doctors) {
                        doctor['nowServing'] = doctor['serialStart'];
                      }
                    });
                  },

                  child: Text(
                    "Reset All Serials",
                    style: app_textstyles.inputText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
              'today_settings',
              jsonEncode(doctors),
            );

            prefs.setString(
              'doctors',
              jsonEncode(doctors),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Today's settings saved"),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            "Save Today's Settings",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
    );
  }

  void updateStatus() {
    for (var doctor in doctors) {

      if (doctor['active'] == false) {
        doctor['status'] = "Off Duty";
        continue;
      }

      // Pause has highest priority
      if (doctor['paused'] == true) {
        doctor['status'] = "Paused";
        continue;
      }

      if (doctor['startTime'] == null || doctor['endTime'] == null) {
        doctor['status'] = "Not Started";
        continue;
      }

      TimeOfDay start = doctor['startTime'];
      TimeOfDay end = doctor['endTime'];
      final now = TimeOfDay.now();

      int nowMin = now.hour * 60 + now.minute;
      int startMin = start.hour * 60 + start.minute;
      int endMin = end.hour * 60 + end.minute;

      if (nowMin < startMin) {
        doctor['status'] = "Not Started";
      }
      else if (nowMin >= startMin && nowMin <= endMin) {
        doctor['status'] = "Running";
      }
      else {
        doctor['status'] = "Finished";
      }
    }

    setState(() {});
  }
}
