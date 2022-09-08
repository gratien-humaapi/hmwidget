import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:styled_widget/styled_widget.dart';

import '../actions_sheet/action_sheet.dart';

class HMImagePicker extends HookWidget {
  const HMImagePicker(
      {this.isMultipleImage = false, required this.onImageSelected, super.key});
  final bool isMultipleImage;
  final ValueChanged<List<XFile>> onImageSelected;
  @override
  Widget build(BuildContext context) {
    final pickedImage = useState(<XFile>[]);
    pickedImage.addListener(() {
      onImageSelected(pickedImage.value);
    });
    return GestureDetector(
      onTap: () {
        if (isMultipleImage) {
          ImagePicker().pickMultiImage().then((value) {
            if (value != null) {
              pickedImage.value = value;
            }
          });
        } else {
          showActionSheet(context: context, actions: [
            ActionSheetItem(
                title: 'Camera',
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.blue),
                onPressed: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.camera)
                      .then((value) {
                    if (value != null) {
                      pickedImage.value = [value];
                    }
                  });
                }),
            ActionSheetItem(
                title: 'Gallery',
                icon: const Icon(Icons.photo, color: Colors.blue),
                onPressed: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((value) {
                    if (value != null) {
                      pickedImage.value = [value];
                    }
                  });
                })
          ]);
        }
      },
      child: pickedImage.value.isEmpty
          ? CustomPaint(
              foregroundPainter: DashedPainter(),
              child: Container(
                  height: 100,
                  width: 150,
                  color: Colors.grey.withOpacity(0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Colors.grey, size: 35),
                      const SizedBox(height: 5),
                      Text(
                        'Import image',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  )),
            )
          : Container(
              height: 100,
              width: 150,
              color: Colors.grey.shade500,
              child: isMultipleImage && pickedImage.value.length > 1
                  ? multipleImageView(pickedImage)
                  : Image.file(
                      File(pickedImage.value.first.path),
                      // fit: BoxFit.contain,
                    ),
            ),
    );
  }

  Widget multipleImageView(ValueNotifier<List<XFile>> pickedImage) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Wrap(
        runSpacing: 2,
        spacing: 2,
        children: List.generate(
            pickedImage.value.length <= 3 ? pickedImage.value.length : 4,
            (index) {
          if (index < 3) {
            return SizedBox(
              height: (constraints.maxHeight / 2) - 2,
              width: (constraints.maxWidth / 2) - 2,
              child: Image.file(
                File(pickedImage.value[index].path),
                fit: BoxFit.cover,
              ),
            );
          } else {
            return SizedBox(
              height: (constraints.maxHeight / 2) - 2,
              width: (constraints.maxWidth / 2) - 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(pickedImage.value[index].path),
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Text('+${pickedImage.value.length - 4}')
                            .fontSize(18)
                            .fontWeight(FontWeight.w500)
                            .textColor(Colors.white)
                            .center()),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}

class DashedPainter extends CustomPainter {
  DashedPainter();

  final Paint _paint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
        const Radius.circular(8),
      ));

    final Path dashedPath = Path();
    const double dashWidth = 10.0;
    const double dashSpace = 5.0;
    double distance = 0.0;

    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashedPath, _paint);
  }

  @override
  bool shouldRepaint(DashedPainter oldDelegate) => false;
}
