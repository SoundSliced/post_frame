import 'package:flutter/material.dart';
import 'package:post_frame/post_frame.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PostFrame Example',
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  String _message = 'Waiting for post frame...';

  @override
  void initState() {
    super.initState();
    PostFrame.postFrame(() {
      setState(() {
        _message = 'This ran after the first frame!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PostFrame Example')),
      body: Center(child: Text(_message)),
    );
  }
}
