import 'package:flutter/material.dart';
import 'package:hmwidget/hmwidget.dart';
import 'package:hmwidget/widget_theme.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue,
          // useMaterial3: true,
          extensions: [
            HMButtonTheme(
              fillColor: Colors.pink,
              textColor: Colors.green,
              buttonVariant: HMButtonVariant.filled,
              size: HMButtonSize.md,
              // radius: HMRadius.xl,
            ),
            HMIconButtonTheme(
              fillColor: Colors.pink,
              iconColor: Colors.green,
              buttonVariant: HMButtonVariant.filled,
              size: HMIconButtonSize.xs,
              // radius: HMRadius.xl,
            ),
            HMSwitchTheme(
                color: Colors.redAccent,
                radius: HMRadius.xl,
                size: HMSwitchSize.md),
            HMCheckBoxTheme(
                color: Colors.redAccent,
                radius: HMRadius.sm,
                size: HMCheckBoxSize.md),
            HMTextFieldTheme(
                fillColor: Colors.greenAccent.withOpacity(0.4),
                radius: HMRadius.md,
                variant: HMTextVariant.outlined),
            HMSliderTheme(
                color: Colors.orange,
                radius: HMRadius.xs,
                size: HMSliderSize.md)
          ]),
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
  String select = '';
  List choix = [];
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
            ElevatedButton(onPressed: () {}, child: Text("Open")),
            HMIconButton(
                icon: const Icon(Icons.edit_calendar_sharp), onPressed: () {}),
            SizedBox(
              width: 200,
              child: HMSlider(value: 10, onChange: (val) {}),
            ),
            const SizedBox(height: 10),
            HMRangeSlider(rangeValues: rangeValues, onChange: (range) {}),
            HMRadio(
              value: select,
              radioList: const ["Flutter", 'React', 'Svelte', 'Vue', 'Python'],
              onChanged: (value) {
                setState(() {
                  select = value;
                });
              },
            ),
            HMSelect(
              value: select,
              selectList: const ["Flutter", 'React', 'Svelte', 'Vue', 'Python'],
              onChanged: (value) {
                setState(() {
                  select = value;
                });
              },
            ),
            HMCheckBox(
                value: ischecked,
                // disabled: true,
                onChange: (val) {
                  setState(() {
                    ischecked = val;
                    print(ischecked);
                  });
                }),
            HMSelectBadge(
                // disabled: true,
                selectedList: choix
                    .map((element) => HMSelectedItem(
                        avatar: Text(element.toString()[0]),
                        value: element.toString(),
                        label: Text(element.toString())))
                    .toList(),
                radius: HMRadius.md,
                onDeleted: (deletedValue) {
                  setState(() {
                    choix.remove(deletedValue);
                  });
                }),

            HMMultiSelect(
              selectList: const ["Flutter", 'React', 'Svelte', 'Vue', 'Python'],
              onChanged: (value) {
                setState(() {
                  choix = value;
                  print(choix);
                });
              },
              selectedValueList: choix,
            ),

            HMChoiceChips(
              label: Text("Call"),
              isFilled: true,
              // disabled: true,
              radius: HMRadius.md,
              onSelected: (value) {
                print(value);
              },
            ),
            HMFilterChips(
              label: Text("Flutter"),
              isFilled: true,
              // disabled: true,
              onSelected: (value) {
                print(value);
              },
            ),

            HMSwitch(
                value: ischecked,
                // duration: const Duration(milliseconds: 100),
                onChange: (val) {
                  // print(val);
                  setState(() {
                    ischecked = val;
                    // print(ischecked);
                  });
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HMButton(
                onPressed: () => print("Pressed"),
                buttonVariant: HMButtonVariant.outlined,
                fullWidth: true,
                content: 'Press',
                // textColor: Colors.blue,
              ),
            ),
            // HMIcons.svg,
            SizedBox(
              width: 200,
              child: HMTextField(
                textFieldType: HMTextFieldType.password,
                // disabled: true,
                variant: HMTextVariant.filled,
                maxLength: 8,
                onChange: (val) => print(val),
              ),
            ),
            HMButton(content: "CLIC", onPressed: () {}),
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
