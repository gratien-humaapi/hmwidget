import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../utils/constant.dart';
import '../../size/hm_iconbutton_size.dart';
import '../../type/file_source.dart';
import '../../type/hm_button_type.dart';
import '../actions_sheet/action_sheet.dart';
import '../iconbutton/hm_iconbutton.dart';
import 'file_view.dart';
import 'hm_file_picker_logic.dart';

class HMFilePiker extends HookWidget {
  final bool isMultipleSelection;
  final List<Map<String, dynamic>> selectSource;
  final bool fileViewInModal;
  final FileType fileType;

  const HMFilePiker({
    this.isMultipleSelection = false,
    required this.selectSource,
    this.fileViewInModal = true,
    required this.fileType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<PlatformFile> selectedFile =
        useState(PlatformFile(name: '', size: 0));
    final ValueNotifier<List<PlatformFile>> multipleFiles =
        useState(<PlatformFile>[]);
    return Container(
      child: isMultipleSelection
          ? multipleFilePanel(context, multipleFiles, selectedFile)
          : singleFilePanel(context, selectedFile, multipleFiles),
    );
  }

  Widget singleFilePanel(
      BuildContext context,
      ValueNotifier<PlatformFile> selectedFile,
      ValueNotifier<List<PlatformFile>> multipleFiles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => showActionSheet(
                context: context,
                actions: buildSourceList(selectedFile, multipleFiles)),
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
                    if (selectedFile.value.path != null)
                      FilePickerLogic.buildIcon(
                          selectedFile.value, selectedFile.value.extension!),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        selectedFile.value.name,
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
                icon: Icons.file_upload_outlined,
                fillColor: Colors.blue,
                iconColor: Colors.white,
                buttonVariant: HMButtonVariant.filled,
                size: HMIconButtonSize.sm,
                onPressed: () async {
                  showActionSheet(
                      context: context,
                      actions: buildSourceList(selectedFile, multipleFiles));
                  // FilePickerLogic.pickFile(selectedFile, fileType);
                }),
            const SizedBox(width: 10),
            HMIconButton(
                icon: Icons.close,
                buttonVariant: HMButtonVariant.filled,
                fillColor: Colors.blue,
                size: HMIconButtonSize.sm,
                iconColor: Colors.white,
                onPressed: () {
                  if (selectedFile.value.path != null) {
                    selectedFile.value = PlatformFile(name: '', size: 0);
                  }
                }),
            // const SizedBox(width: 20),
          ],
        )
      ],
    );
  }

  List<ActionSheetItem> buildSourceList(
      ValueNotifier<PlatformFile> selectedFile,
      ValueNotifier<List<PlatformFile>> multipleFiles) {
    final List<ActionSheetItem> sourceList =
        selectSource.map((Map<String, dynamic> source) {
      String title = source['source'].value as String;
      Widget icon = source['icon'] as Widget;
      return ActionSheetItem(
          icon: icon,
          title: title,
          onPressed: () async {
            if (source['source'] == FileSource.camera) {
              // final XFile? image = fileType == FileType.image
              //     ? await ImagePicker().pickImage(source: ImageSource.camera)
              //     : await ImagePicker().pickVideo(source: ImageSource.camera);
              // if (image == null) return;

              // final int size = await image.length();
              // selectedFile.value =
              //     PlatformFile(path: image.path, name: image.name, size: size);
            } else {
              isMultipleSelection
                  ? FilePickerLogic.pickMultipleFiles(multipleFiles, fileType)
                  : FilePickerLogic.pickFile(selectedFile, fileType);
            }
          });
    }).toList();
    return sourceList;
  }

  Widget multipleFilePanel(
      BuildContext context,
      ValueNotifier<List<PlatformFile>> multipleFiles,
      ValueNotifier<PlatformFile> selectedFile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        selectedFileView(multipleFiles, context, selectedFile),
        //here
        Row(
          children: [
            HMIconButton(
                icon: Icons.file_upload_outlined,
                fillColor: Colors.blue,
                iconColor: Colors.white,
                buttonVariant: HMButtonVariant.filled,
                size: HMIconButtonSize.sm,
                onPressed: () async {
                  showActionSheet(
                      context: context,
                      actions: buildSourceList(selectedFile, multipleFiles));
                  // await pickMultipleFiles(multipleFiles);
                }),
            const SizedBox(width: 10),
            HMIconButton(
                icon: Icons.drive_file_rename_outline_outlined,
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
                        actions: buildSourceList(selectedFile, multipleFiles));
                  }
                }),
            // const SizedBox(width: 20),
          ],
        )
      ],
    );
  }

  Widget selectedFileView(ValueNotifier<List<PlatformFile>> multipleFiles,
      BuildContext context, ValueNotifier<PlatformFile> selectedFile) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            if (multipleFiles.value.isNotEmpty) {
              openMultipleFiles(multipleFiles, context);
            } else {
              showActionSheet(
                  context: context,
                  actions: buildSourceList(selectedFile, multipleFiles));
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
                  "${multipleFiles.value.length > 99 ? "99+" : multipleFiles.value.length}",
                  style: const TextStyle(
                      fontSize: 12, height: 1.5, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              // Text("${}"),
              Expanded(
                child: Text(
                  multipleFiles.value.map((PlatformFile e) => e.name).join(','),
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
                        print('object');
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
                      print('object');
                      files.value = newList;
                    }),
              ),
            ),
          ));
  }
}
