# post_frame

`post_frame` is a Flutter package that provides utilities to execute actions after the first frame is rendered, making it easy to schedule work that depends on layout or widget tree completion. It also supports waiting for `ScrollController` metrics and end-of-frame passes for precise timing.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  post_frame:
    path: ../my_extensions/post_frame
```

## Features

- Execute actions after the first frame is rendered using `PostFrame.postFrame`.
- Optionally wait for end-of-frame passes for more accurate layout timing.
- Wait for `ScrollController` metrics to be available before executing actions.

## Usage

```dart
import 'package:post_frame/post_frame.dart';

// Example: update state after first frame
PostFrame.postFrame(() {
  // Your code here, e.g. setState or navigation
});
```

### Full Example

```dart
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message),
            ElevatedButton(
              onPressed: () {
                PostFrame.postFrame(() {
                  setState(() {
                    _message = 'Button pressed after frame!';
                  });
                });
              },
              child: const Text('Press Me'),
            ),
          ],
        ),
      ),
    );
  }
}
```

See the [`example/`](example/main.dart) directory for a runnable example.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Repository

https://github.com/SoundSliced/post_frame
