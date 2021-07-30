import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: DemoApp()));

class DemoApp extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
          body: Center(
        child: CustomButton("Hello World", _onButtonTap),
      ));

  void _onButtonTap() {
    print("_onButtonTap");
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback callback;

  CustomButton(this.label, this.callback);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(label),
    );
  }
}
