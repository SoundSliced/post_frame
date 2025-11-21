import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:post_frame/post_frame.dart';

void main() {
  testWidgets('PostFrame.postFrame executes after frame', (tester) async {
    String message = 'before';
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    PostFrame.postFrame(() {
      message = 'after';
    }, waitForEndOfFrame: false);
    // Pump a few frames to allow the post frame callback to run
    await tester.pump();
    expect(message, 'after');
  }, timeout: const Timeout(Duration(seconds: 10)));
}
