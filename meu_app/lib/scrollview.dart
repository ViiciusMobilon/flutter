import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(scrollviewwidget());

class scrollviewwidget extends StatelessWidget {
  const scrollviewwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(appBar: AppBar(), body: MyWidget(),),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.blue),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.blue),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.blue),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.blue),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.blue),
            ),
         widget2() ],
        ),
      ),
    );
  }
}
class widget2 extends StatelessWidget {
  const widget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.red),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.red),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.red),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.red),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 200, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
