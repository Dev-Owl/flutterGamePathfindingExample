import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'gameState.dart';

class ColorPoint extends PositionComponent {
  late final Vector2 gridPosition;
  late final Paint mainPaint;
  final GameState state;

  ColorPoint(Vector2 gridPosition, this.state)
      : super(
            position: state.unitSystem
                .gridToPixel(gridPosition.x.toInt(), gridPosition.y.toInt())) {
    gridPosition = gridPosition;
  }

  @override
  Future<void>? onLoad() {
    mainPaint = Paint();
    mainPaint.color = Colors.pink;
    return super.onLoad();
  }

  @override
  void preRender(Canvas canvas) {
    //Nope
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(
      position.toOffset(),
      state.unitSystem.gridCellGap / 4,
      mainPaint,
    );
  }
}
