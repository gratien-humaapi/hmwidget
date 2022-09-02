import 'package:flutter/material.dart';
import 'package:hmwidget/hmwidget.dart';

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
  RangeValues rangeValues = RangeValues(10, 50);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HmWidget demo"),
        centerTitle: true,
      ),
      // backgroundColor: Colors.black,
      body: Center(
        child: HMButton(
          onPressed: () => print("Pressed"),
          buttonVariant: HMButtonVariant.outlined,
          content: 'Press',
          textColor: Colors.blue,
        ),
      ),
    );
  }
}
