// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../hmwidget.dart';
import '../../utils/constant.dart';
import 'hm_file_picker_logic.dart';

class FilesPage extends HookWidget {
  const FilesPage({
    required this.files,
    required this.onEditingFile,
    this.controller,
    super.key,
  });
  final List<PlatformFile> files;

  final void Function(List<PlatformFile> files) onEditingFile;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final listFiles = useState(files);
    final selectedList = useState([]);
    final isSelecting = useState(false);
    return Column(
      // mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: buildTitle(selectedList, listFiles, isSelecting),
        ),
        Expanded(
          child: listFiles.value.isEmpty
              ? Center(child: const Text('No file selected.').fontSize(18))
              : GridView.builder(
                  shrinkWrap: true,
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: listFiles.value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return buildFile(
                        index, listFiles, selectedList, isSelecting);
                  }),
        ),
      ],
    );
  }

  Widget buildTitle(
      ValueNotifier<List> selectedList,
      ValueNotifier<List<PlatformFile>> listFiles,
      ValueNotifier<bool> isSelecting) {
    return isSelecting.value
        ? Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              HMIconButton(
                  onPressed: () {
                    selectedList.value = [];
                    isSelecting.value = false;
                  },
                  size: HMIconButtonSize.sm,
                  icon: const Icon(Icons.close_rounded),
                  iconColor: Colors.black),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${selectedList.value.length} selected',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              HMIconButton(
                  onPressed: () {
                    if (selectedList.value.length != listFiles.value.length ||
                        selectedList.value.isEmpty) {
                      selectedList.value = List.from(listFiles.value);
                    } else {
                      selectedList.value = [];
                    }
                  },
                  size: HMIconButtonSize.sm,
                  icon: const Icon(Icons.select_all_rounded),
                  iconColor: Colors.black),
              const SizedBox(width: 20),
              HMIconButton(
                  disabled: selectedList.value.isEmpty,
                  onPressed: () {
                    List<PlatformFile> a = List.from(listFiles.value);
                    for (int i = 0; i < selectedList.value.length; i++) {
                      a.remove(selectedList.value[i]);
                    }
                    listFiles.value = a;
                    selectedList.value = [];
                    isSelecting.value = false;
                    onEditingFile(listFiles.value);
                  },
                  size: HMIconButtonSize.sm,
                  icon: const Icon(Icons.delete),
                  iconColor: Colors.black),
              const SizedBox(width: 10),
            ],
          )
        : Row(
            children: [
              const Expanded(
                child: Center(
                  child: Text(
                    'Selected Files',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              HMIconButton(
                onPressed: () {
                  isSelecting.value = true;
                },
                disabled: listFiles.value.isEmpty,
                size: HMIconButtonSize.sm,
                icon: const Icon(Icons.highlight_alt),
                iconColor: Colors.black,
              ),
              const SizedBox(width: 20),
            ],
          );
  }

  Widget buildFile(int index, ValueNotifier<List<PlatformFile>> listFiles,
      ValueNotifier<List> selectedList, ValueNotifier<bool> isSelecting) {
    PlatformFile file = listFiles.value[index];
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final fileSize =
        mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = file.extension ?? 'none';

    return GestureDetector(
      onTap: () {
        if (isSelecting.value) {
          handleSelect(selectedList, file);
        }
      },
      // onLongPress: () {
      //   handleSelect(selectedList, file);
      // },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: selectedList.value.contains(file)
                    ? Colors.blue
                    : outlineColor)),
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: FilePickerLogic.buildIcon(file, extension),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                        visible: selectedList.value.contains(file),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.blue,
                          ),
                        ),
                      )),
                ],
              )),
              // const SizedBox(height: 8),
              Text(
                file.name,
                maxLines: 2,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                fileSize,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSelect(
      ValueNotifier<List<dynamic>> selectedList, PlatformFile file) {
    List<PlatformFile> x = List.from(selectedList.value);
    if (x.contains(file)) {
      x.remove(file);
      selectedList.value = x;
    } else {
      x.add(file);
      selectedList.value = x;
    }
  }
}
