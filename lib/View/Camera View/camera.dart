import 'dart:io';

import 'package:camera/camera.dart';
import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/View/Camera%20View/camera_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late AttendanceProvider atProv;
  late CameraProvider camProv;

  @override
  void initState() {
    super.initState();
    atProv = Provider.of<AttendanceProvider>(context, listen: false);
    camProv = Provider.of<CameraProvider>(context, listen: false);
    camProv.getAvailableCameras();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isTaken = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<CameraProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return value.isInitCam
            ? Stack(
                children: [
                  SizedBox(
                    height: Get.height,
                    child: CameraPreview(
                      camProv.controller!,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: InkWell(
                        onTap: () async {
                          atProv.xFile = await camProv.controller!.takePicture();
                          Get.to(() => CameraImageView());
                        },
                        child: CircleAvatar(radius: 30, backgroundColor: Colors.white)),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    ));

  }
}

class CameraProvider extends ChangeNotifier {
  List<CameraDescription>? cameras;
  CameraController? controller;
  bool isInitCam = false;

  void getAvailableCameras() async {
    cameras = await availableCameras();
    if (cameras != null) initCam();
    print("cameras ${cameras!.length}");

  }

  void initCam() async {
    CameraDescription? camera;

    cameras!.forEach((element) {
      if(element.lensDirection==CameraLensDirection.front){
        camera=element;
      }
    });
    // CameraLensDirection

    controller = await CameraController(
      camera!
       /* Platform.isIOS ? cameras!.first : cameras!.last*/, ResolutionPreset.medium,
    );
    await controller!.initialize().then((value) {
      isInitCam = true;
      return null;
    });

    notifyListeners();
  }
}
