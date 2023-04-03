import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../size/hm_iconbutton_size.dart';
import '../../type/file_source.dart';
import '../../type/hm_button_type.dart';
import '../../utils/constant.dart';
import '../actions_sheet/action_sheet.dart';
import '../iconbutton/hm_iconbutton.dart';
import 'camera_page.dart';
import 'file_view.dart';
import 'hm_file_picker_logic.dart';

class HMFilePiker extends HookWidget {
  const HMFilePiker({
    required this.fileViewInModal,
    required this.isMultipleFiles,
    required this.onFileSelected,
    super.key,
  });

  final bool fileViewInModal;
  final bool isMultipleFiles;
  final void Function(List<PlatformFile> files) onFileSelected;

// The build function
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<PlatformFile>> selectedFiles =
        useState(<PlatformFile>[]);
    selectedFiles.addListener(() {
      onFileSelected(selectedFiles.value);
    });
    return Container(
      child: isMultipleFiles
          ? multipleFilePanel(context, selectedFiles)
          : singleFilePanel(context, selectedFiles),
    );
  }

  Widget singleFilePanel(
      BuildContext context, ValueNotifier<List<PlatformFile>> selectedFiles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showActionSheet(
                  context: context,
                  actions: buildSourceList(
                      selectedFiles: selectedFiles, context: context));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: outlineColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    if (selectedFiles.value.isNotEmpty)
                      FilePickerLogic.buildIcon(selectedFiles.value.first,
                          selectedFiles.value.first.extension!, 25),
                    const SizedBox(width: 15),
                    if (selectedFiles.value.isNotEmpty)
                      Expanded(
                        child: Text(
                          selectedFiles.value.first.name,
                          // textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        //here
        Row(
          children: [
            HMIconButton(
                icon: const Icon(Icons.file_upload_outlined),
                fillColor: Colors.blue,
                iconColor: Colors.white,
                buttonVariant: HMButtonVariant.filled,
                size: HMIconButtonSize.sm,
                onPressed: () async {
                  showActionSheet(
                      context: context,
                      actions: buildSourceList(
                          selectedFiles: selectedFiles, context: context));
                  // FilePickerLogic.pickFile(selectedFile, fileType);
                }),
            const SizedBox(width: 10),
            HMIconButton(
                icon: const Icon(Icons.close),
                buttonVariant: HMButtonVariant.filled,
                fillColor: Colors.blue,
                size: HMIconButtonSize.sm,
                iconColor: Colors.white,
                onPressed: () {
                  if (selectedFiles.value.isNotEmpty) {
                    selectedFiles.value = [];
                  }
                }),
            // const SizedBox(width: 20),
          ],
        )
      ],
    );
  }

  List<ActionSheetItem> buildSourceList(
      {required BuildContext context,
      required ValueNotifier<List<PlatformFile>> selectedFiles}) {
    final List sourcesList = [
      HMFileSource(
          icon: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.blue,
          ),
          source: FileSource.camera),
      HMFileSource(
          icon: const Icon(
            Icons.photo,
            color: Colors.blue,
          ),
          source: FileSource.gallery),
      HMFileSource(
          icon: const Icon(
            Icons.insert_drive_file,
            color: Colors.blue,
          ),
          source: FileSource.document),
    ];
    final List<ActionSheetItem> actionsList = sourcesList.map((source) {
      final Widget title = Text('${source.source.value}');
      final Widget icon = source.icon as Widget;
      return ActionSheetItem(
          icon: icon,
          title: title,
          onPressed: () async {
            if (source.source == FileSource.camera) {
              await availableCameras().then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CameraPage(cameras: value)),
                ).then((value) async {
                  if (value != null) {
                    final int size = await value.length() as int;
                    selectedFiles.value = [
                      PlatformFile(
                          name: value.name as String,
                          size: size,
                          path: value.path as String)
                    ];
                  }
                }),
              );
            } else if (source.source == FileSource.gallery) {
              isMultipleFiles
                  ? FilePickerLogic.pickMultipleFiles(
                      selectedFiles, FileType.media)
                  : FilePickerLogic.pickFile(selectedFiles, FileType.media);
            } else {
              isMultipleFiles
                  ? FilePickerLogic.pickMultipleFiles(
                      selectedFiles, FileType.any)
                  : FilePickerLogic.pickFile(selectedFiles, FileType.any);
            }
          });
    }).toList();
    return actionsList;
  }

  Widget multipleFilePanel(
    BuildContext context,
    ValueNotifier<List<PlatformFile>> multipleFiles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        selectedFileView(multipleFiles, context),
        //here
        Row(
          children: [
            HMIconButton(
                icon: const Icon(Icons.file_upload_outlined),
                fillColor: Colors.blue,
                iconColor: Colors.white,
                buttonVariant: HMButtonVariant.filled,
                size: HMIconButtonSize.sm,
                onPressed: () async {
                  showActionSheet(
                      context: context,
                      actions: buildSourceList(
                          selectedFiles: multipleFiles, context: context));
                  // await pickMultipleFiles(multipleFiles);
                }),
            const SizedBox(width: 10),
            HMIconButton(
                icon: const Icon(Icons.drive_file_rename_outline_outlined),
                buttonVariant: HMButtonVariant.filled,
                fillColor: Colors.blue,
                size: HMIconButtonSize.sm,
                iconColor: Colors.white,
                onPressed: () {
                  if (multipleFiles.value.isNotEmpty) {
                    openMultipleFiles(multipleFiles, context);
                  } else {
                    showActionSheet(
                        context: context,
                        actions: buildSourceList(
                            selectedFiles: multipleFiles, context: context));
                  }
                }),
            // const SizedBox(width: 20),
          ],
        )
      ],
    );
  }

  Widget selectedFileView(
      ValueNotifier<List<PlatformFile>> selectedFiles, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            if (selectedFiles.value.isNotEmpty) {
              openMultipleFiles(selectedFiles, context);
            } else {
              showActionSheet(
                  context: context,
                  actions: buildSourceList(
                      selectedFiles: selectedFiles, context: context));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: outlineColor),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15,
                child: Text(
                  "${selectedFiles.value.length > 99 ? "99+" : selectedFiles.value.length}",
                  style: const TextStyle(
                      fontSize: 12, height: 1.5, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              // Text("${}"),
              Expanded(
                child: Text(
                  selectedFiles.value.map((PlatformFile e) => e.name).join(','),
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<dynamic> openMultipleFiles(
      ValueNotifier<List<PlatformFile>> files, BuildContext context) {
    return fileViewInModal
        ? showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
            context: context,
            builder: (BuildContext ctx) {
              return DraggableScrollableSheet(
                maxChildSize: 0.9,
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return FilesPage(
                      controller: scrollController,
                      files: files.value,
                      onEditingFile: (List<PlatformFile> newList) {
                        // print('object');
                        files.value = newList;
                      });
                },
              );
            })
        : Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
              body: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: FilesPage(
                    files: files.value,
                    onEditingFile: (List<PlatformFile> newList) {
                      // print('object');
                      files.value = newList;
                    }),
              ),
            ),
          ));
  }
}
