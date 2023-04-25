import 'package:flutter/material.dart';
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
                // fillColor: Colors.greenAccent.withOpacity(0.4),
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
  List<String> options = [
    'pomme',
    'banane',
    'orange',
    'ananas',
    'pastèque',
    'fraise',
    'melon',
    'raisin',
    'kiwi',
    'mangue',
    'papaye',
    'poire',
    'citron',
    'lime',
    'pamplemousse',
    'mandarine',
    'framboise',
    'myrtille',
    'cerise',
    'pêche'
  ];
  String choosedValue = "";
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
            // ElevatedButton(onPressed: () {}, child: Text("Open"), ),
            HMAutocomplete(
              hintText: "Enter somting",
              optionsBuilder: (value) {
                if (value == '') {
                  return [];
                }
                return options.where((String option) {
                  return option.contains(value);
                }).toList();
              },
              initialValue: choosedValue,
              onSelected: (value) {
                setState(() {
                  choosedValue = value;
                });
              },
            ),
            const SizedBox(height: 50),
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
              selectionPageTitle: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Select a Framework'),
                ),
              ),
              // selectIconAtLeft: false,
              // selectItemStyle: TextStyle(fontSize: 20),
              selectList: const [
                "Flutter",
                'React',
                'Svelte',
                'Vue',
                'Angular'
              ],
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
              },
              direction: Axis.vertical,
              onTap: (index) {
                print(index);
              },
            ),

            HMMultiSelect(
              selectionPageTitle: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Select a Framework'),
                ),
              ),
              selectListItem: const [
                "Création d'une armoire de rangement sur mesure",
                "Réparation d'une chaise en bois",
                "Fabrication d'un escalier en bois",
                "Création d'une bibliothèque encastrée",
                "Réparation d'un plancher en bois",
                "Fabrication d'un banc de jardin en bois",
                "Création d'un présentoir à bijoux en bois"
              ],
              onChanged: (value) {
                setState(() {
                  choix = value;
                  print(choix);
                });
              },
              selectedValues: choix,
              onSelectedValuePressed: (int index) {
                print(index);
              },
            ),

            HMChoiceChips(
              label: const Text("Call"),
              isFilled: true,
              // disabled: true,
              radius: HMRadius.md,
              onSelected: (value) {
                print(value);
              },
            ),
            HMFilterChips(
              label: const Text("Flutter"),
              isFilled: true,
              // disabled: true,
              onSelected: (value) {
                print(value);
              },
            ),
            const HMTextField(
              size: HMTextFieldSize.md,
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
