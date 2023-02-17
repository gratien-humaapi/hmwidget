import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../iconbutton/hm_iconbutton.dart';

class CameraPage extends StatefulWidget {
  CameraPage({super.key, required this.cameras});
  List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? imageFile;
  bool toggleCamera = false;
  late CameraController controller;
  XFile? pictureFile;
  bool isVideoRecording = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double cameraHeight = screenSize.height * 0.8;
    final double cameraWidth = screenSize.width;
    final double dimension = screenSize.height * 0.08;

    if (widget.cameras.isEmpty) {
      return Material(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'No Camera Found',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container();
    }

    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
                height: cameraHeight,
                width: cameraWidth,
                child: CameraPreview(controller)),
            Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 30,
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Flash button
                    HMIconButton(
                      onPressed: () async {
                        controller.value.flashMode == FlashMode.auto
                            ? await controller.setFlashMode(FlashMode.always)
                            : controller.value.flashMode == FlashMode.always
                                ? await controller.setFlashMode(FlashMode.off)
                                : controller.value.flashMode == FlashMode.off
                                    ? await controller
                                        .setFlashMode(FlashMode.torch)
                                    : controller.value.flashMode ==
                                            FlashMode.torch
                                        ? await controller
                                            .setFlashMode(FlashMode.auto)
                                        : null;
                        setState(() {});
                        // print(index);
                        // controller.setFlashMode(flashModeList[index]);
                      },
                      iconColor: Colors.white,
                      icon: Icon(getFlashIcon(controller.value.flashMode)),
                    ),
                    // The capture boutton
                    GestureDetector(
                      onTap: () => _captureImage(),
                      onLongPress: () {
                        setState(() {
                          isVideoRecording = true;
                          controller.startVideoRecording();
                        });
                      },
                      onTapDown: (tapDownDetails) {
                        // Effet d'appui
                      },
                      onTapUp: (tapDownDetails) async {
                        // if (isVideoRecording) {
                        //   imageFile = await controller.stopVideoRecording();
                        //   isVideoRecording = false;
                        //   setState(() {});
                        //   setCameraResult();
                        // }
                      },
                      onLongPressEnd: (details) async {
                        if (isVideoRecording) {
                          imageFile = await controller.stopVideoRecording();
                          isVideoRecording = false;
                          setState(() {});
                          setCameraResult();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: dimension,
                          width: dimension,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isVideoRecording ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Switch camera button
                    HMIconButton(
                      onPressed: () {
                        if (!toggleCamera) {
                          onCameraSelected(widget.cameras[1]);
                          setState(() {
                            toggleCamera = true;
                          });
                        } else {
                          onCameraSelected(widget.cameras[0]);
                          setState(() {
                            toggleCamera = false;
                          });
                        }
                      },
                      iconColor: Colors.white,
                      icon: const Icon(Icons.flip_camera_ios_outlined),
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

  Future<void> onCameraSelected(CameraDescription cameraDescription) async {
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    await controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() {
    controller.takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          setCameraResult();
        }
      }
    });
  }

  IconData getFlashIcon(FlashMode flashMode) {
    switch (flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto_outlined;
      case FlashMode.off:
        return Icons.flash_off_outlined;

      case FlashMode.always:
        return Icons.flash_on_outlined;

      case FlashMode.torch:
        return Icons.light_mode;
    }
  }

  void setCameraResult() {
    Navigator.pop(context, imageFile);
  }
}
