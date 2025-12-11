// lib/Common/ShareHelper.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  ShareHelper._();

  /// Creates a safe non-zero Rect to use as sharePositionOrigin on iOS/iPad.
  static Rect _calculateSafeOrigin(BuildContext? ctx) {
    if (ctx != null) {
      try {
        final mq = MediaQuery.of(ctx);
        final width = mq.size.width;
        final height = mq.size.height;

        // pick a 120x120 box near center — should always be within view
        final w = (width >= 120) ? 120.0 : width / 2;
        final h = (height >= 120) ? 120.0 : height / 2;
        final left = (width - w) / 2;
        final top = (height - h) / 2;
        return Rect.fromLTWH(left, top, w, h);
      } catch (_) {
        // fallthrough to default
      }
    }
    // fallback default rect (non-zero)
    return const Rect.fromLTWH(100.0, 100.0, 200.0, 200.0);
  }

  /// Share a single XFile safely (handles iOS origin & fallback).
  static Future<void> shareFileUniversal(
    XFile file, {
    String text = '',
  }) async {
    final ctx = Get.context;
    final origin = _calculateSafeOrigin(ctx);

    try {
      await Share.shareXFiles([file], text: text, sharePositionOrigin: origin);
    } catch (e) {
      // try fallback without origin
      try {
        await Share.shareXFiles([file], text: text);
      } catch (e2) {
        debugPrint('ShareHelper.shareFileUniversal failed: $e / $e2');
        rethrow;
      }
    }
  }

  /// Share multiple XFiles safely (handles iOS origin & fallback).
  static Future<void> shareFilesUniversal(
    List<XFile> files, {
    String text = '',
  }) async {
    final ctx = Get.context;
    final origin = _calculateSafeOrigin(ctx);

    try {
      await Share.shareXFiles(files, text: text, sharePositionOrigin: origin);
    } catch (e) {
      // try fallback without origin
      try {
        await Share.shareXFiles(files, text: text);
      } catch (e2) {
        debugPrint('ShareHelper.shareFilesUniversal failed: $e / $e2');
        rethrow;
      }
    }
  }
}
