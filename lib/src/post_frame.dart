import 'dart:async';
// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';

class PostFrame {
  //after metrics are available (postframe), execute the action
  static Future<void> postFrame(
    FutureOr<void> Function() action, {
    List<ScrollController> scrollControllers = const [],
    int maxWaitFrames = 5,
    bool waitForEndOfFrame = true,
    int endOfFramePasses = 2,
  }) {
    final completer = Completer<void>();
    final binding = WidgetsBinding.instance;

    binding.addPostFrameCallback((_) async {
      try {
        if (waitForEndOfFrame) {
          final passes = endOfFramePasses.clamp(1, maxWaitFrames);

          for (var i = 0; i < passes; i++) {
            await binding.endOfFrame;
          }
        }

        for (final controller in scrollControllers) {
          await _waitForControllerMetrics(
              controller, maxWaitFrames, endOfFramePasses);
        }

        if (!completer.isCompleted) {
          await Future.sync(action);
          completer.complete();
        }
      } catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      }
    });

    return completer.future;
  }

  static Future<void> _waitForControllerMetrics(ScrollController controller,
      int maxWaitFrames, int endOfFramePasses) async {
    final binding = WidgetsBinding.instance;

    var remaining = maxWaitFrames;

    while (!controller.hasClients && remaining-- > 0) {
      await binding.endOfFrame;
    }

    if (!controller.hasClients) {
      return;
    }

    final position = controller.position;
    var previousExtent = position.maxScrollExtent;
    var previousViewport = position.viewportDimension;

    remaining = maxWaitFrames;
    while (remaining-- > 0) {
      await binding.endOfFrame;

      if (!controller.hasClients) {
        return;
      }

      if (position.maxScrollExtent != previousExtent ||
          position.viewportDimension != previousViewport) {
        return;
      }
    }
  }
}
