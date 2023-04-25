import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:styled_widget/styled_widget.dart';

import '../actions_sheet/action_sheet.dart';

class HMImagePicker extends HookWidget {
  const HMImagePicker(
      {this.isMultipleImage = false,
      this.hasCancelButton = true,
      this.imageSourceList,
      this.builder,
      this.initialValues,
      required this.onImageSelected,
      super.key});
  final bool isMultipleImage;
  final bool hasCancelButton;
  final List<XFile>? initialValues;
  final List<ActionSheetItem> Function(
      bool isMultipleImage,
      ValueNotifier<List<XFile>> pickedImage,
      void Function() pickMultiImage,
      void Function(ImageSource source) pickSingleImage)? imageSourceList;
  final ValueChanged<List<XFile>> onImageSelected;
  final Widget Function(ValueNotifier<List<XFile>> images, bool isMutipleImage)?
      builder;
  @override
  Widget build(BuildContext context) {
    final pickedImage = useState(initialValues ?? <XFile>[]);
    final ImagePicker imagePicker = ImagePicker();
    pickedImage.addListener(() {
      onImageSelected(pickedImage.value);
    });
    void pickMultiImage() {
      imagePicker.pickMultiImage().then((value) {
        if (value != null) {
          pickedImage.value = value;
        }
      });
    }

    void pickSingleImage(ImageSource source) {
      imagePicker.pickImage(source: source).then((value) {
        if (value != null) {
          pickedImage.value = [value];
        }
      });
    }

    return GestureDetector(
      onTap: () {
        showActionSheet(
            context: context,
            hasCancelButton: hasCancelButton,
            actions: imageSourceList != null
                ? imageSourceList!(isMultipleImage, pickedImage, pickMultiImage,
                    pickSingleImage)
                : [
                    ActionSheetItem(
                        title: const Text('Camera',
                            style: TextStyle(color: Colors.black)),
                        icon: const Icon(Icons.camera_alt_rounded),
                        onPressed: () {
                          pickSingleImage(ImageSource.camera);
                        }),
                    ActionSheetItem(
                        title: const Text('Gallery',
                            style: TextStyle(color: Colors.black)),
                        icon: const Icon(Icons.photo),
                        onPressed: () {
                          if (isMultipleImage) {
                            pickMultiImage();
                          } else {
                            pickSingleImage(ImageSource.gallery);
                          }
                          // imagePicker
                          //     .pickImage(source: ImageSource.gallery)
                          //     .then((value) {
                          //   if (value != null) {
                          //     pickedImage.value = [value];
                          //   }
                          // });
                        })
                  ]);
      },
      child: builder != null
          ? builder!(pickedImage, isMultipleImage)
          : _defaultBuilder(pickedImage),
    );
  }

  Widget _defaultBuilder(ValueNotifier<List<XFile>> pickedImage) {
    if (pickedImage.value.isEmpty) {
      return CustomPaint(
        foregroundPainter: _DashedPainter(),
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
      );
    } else {
      return SizedBox(
        height: 100,
        width: 150,
        // color: Colors.grey.shade500,
        child: isMultipleImage && pickedImage.value.length > 1
            ? multipleImageView(pickedImage)
            : Image.file(
                File(pickedImage.value.first.path),
                fit: BoxFit.cover,
              ),
      );
    }
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

class _DashedPainter extends CustomPainter {
  _DashedPainter();

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
  bool shouldRepaint(_DashedPainter oldDelegate) => false;
}
