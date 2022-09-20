import 'dart:io';
import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CameraImageView extends StatelessWidget {
  const CameraImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (BuildContext context, atProv, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.grey,
          bottomSheet: choiceButton(
            onRetry: () {
              Get.back();
              atProv.xFile == null;
            },
            onConfirm: () {
              Get.back();
              Get.back(result: atProv.xFile);
            },
          ),
          body: Column(
            children: [
              // SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  height: Get.height * .8,
                  width: Get.width * 8,
                  decoration: BoxDecoration(
                      image: atProv.xFile != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(atProv.xFile!.path),
                              ),
                            )
                          : null,
                      border: Border.all(width: 3, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget choiceButton({
    required VoidCallback onRetry,
    required VoidCallback onConfirm,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: onRetry,
              child: Container(
                constraints: BoxConstraints(minWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Retry",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            InkWell(
              onTap: onConfirm,
              child: Container(
                constraints: BoxConstraints(minWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Confirm",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
