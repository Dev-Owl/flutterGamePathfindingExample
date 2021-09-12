import 'package:flame/layers.dart';
import 'package:flutter/material.dart';

import 'gameState.dart';
import 'unitSystem.dart';

class GridLayer extends PreRenderedLayer {
  final GameState state;
  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

  GridLayer(this.state);

  @override
  void drawLayer() {
    renderPlayAreaGrid();
  }

  void renderPlayAreaGrid() {
    // Draw a rectangle
    for (var y = 0; y < GRID_HEIGHT; ++y) {
      for (var x = 0; x < GRID_WIDTH; ++x) {
        canvas.drawRect(
            Rect.fromLTWH(
                x * state.unitSystem.gridCellGap +
                    state.unitSystem.playingFieldOffset.x,
                y * state.unitSystem.gridCellGap +
                    state.unitSystem.playingFieldOffset.y,
                state.unitSystem.gridCellGap,
                state.unitSystem.gridCellGap),
            paint);
      }
    }

    canvas.drawRect(
        Rect.fromLTWH(
            state.unitSystem.activeAreaOffset.x,
            state.unitSystem.activeAreaOffset.y,
            GRID_VERT_WIDTH * state.unitSystem.gridCellGap -
                state.unitSystem.gridCellGap,
            GRID_VERT_HEIGHT * state.unitSystem.gridCellGap -
                state.unitSystem.gridCellGap),
        paint);
  }
}
