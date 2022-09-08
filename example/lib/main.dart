import 'package:flutter/material.dart';
import 'package:hmwidget/components/colorpicker/logic.dart';
import 'package:hmwidget/hmwidget.dart';
// import 'package:hmwidget/hmwidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool ischecked = false;
  RangeValues rangeValues = const RangeValues(10, 50);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HmWidget demo"),
        centerTitle: true,
      ),
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            HMSwitch(
                value: true,
                duration: const Duration(milliseconds: 100),
                onChange: (val) {
                  print(val);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HMButton(
                onPressed: () => print("Pressed"),
                buttonVariant: HMButtonVariant.outlined,
                fullWidth: true,
                content: 'Press',
                textColor: Colors.blue,
              ),
            ),
            SizedBox(
              width: 200,
              child: HMTextField(
                textFieldType: HMTextFieldType.text,
                onChange: (val) => print(val),
              ),
            ),
            HMColorIpnut(
              initialColor: colorToString(Colors.blue),
              onColorChange: (color) {
                print(color);
              },
            ),
            const SizedBox(height: 50),
            HMFilePiker(
              fileViewInModal: false,
              isMultipleFiles: true,
              onFileSelected: (files) {
                print('nombres de fichiers : ${files.length}');
              },
            ),
            HMImagePicker(
              isMultipleImage: false,
              onImageSelected: (value) => print(value),
            ),
          ],
        ),
      ),
    );
  }
}
