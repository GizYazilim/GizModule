import 'dart:typed_data';
import 'package:giz_module/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:visibility_detector/visibility_detector.dart';

abstract class Fragment extends GizStatefulWidget {
  dynamic args;
  String title;

  String get fragmentKey;

  GlobalKey paintKey = new GlobalKey();

  @override
  Widget buildWidget(GizState<GizStatefulWidget> state) {
    return VisibilityDetector(
      key: paintKey,
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint('Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
        if (visiblePercentage == 100) {
          capturePng();
        }
      },
      child: RepaintBoundary(
        key: paintKey,
        child: buildFragment(state),
      ),
    );
  }

  Widget buildFragment(GizState state);

  ByteData byteData;

  Future<ByteData> capturePng() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      RenderRepaintBoundary boundary = paintKey.currentContext.findRenderObject();
      MediaQueryData queryData = MediaQuery.of(gizContext);
      ui.Image image = await boundary.toImage(pixelRatio: queryData.devicePixelRatio);
      return byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    } catch (ex) {}
  }
}