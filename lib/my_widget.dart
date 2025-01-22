import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fix Input Focus")),
      body: Center(
        child: TextField(
          focusNode: _focusNode,
          decoration: InputDecoration(labelText: "Input Text"),
          onTap: () {
            // Fokuskan elemen input saat di-tap
            _focusNode.requestFocus();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
