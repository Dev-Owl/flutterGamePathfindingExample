import 'dart:ui';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mazeball2021/colorPoint.dart';

import 'gameState.dart';
import 'gridLayer.dart';
import 'unitSystem.dart';

class ExampleGame extends BaseGame with HasDraggableComponents {
  late final GameState state;
  late final GridLayer gridLayer;
  Path? tempPath;
  final Paint debugPaint = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  void onResize(Vector2 canvasSize) {
    super.onResize(canvasSize);
    state = GameState(UnitSystem(canvasSize.y, canvasSize.x));
  }

  @override
  Future<void> onLoad() {
    gridLayer = GridLayer(state);
    return super.onLoad();
  }

  Path getLineBetween(Vector2 startPoint, Vector2 endPoint) {
    final gridPath = AStar(
      rows: (GRID_VERT_HEIGHT + 2),
      columns: (GRID_VERT_WIDTH + 2),
      start: startPoint.toOffset(),
      end: endPoint.toOffset(),
      barriers: [], //Add points here to prevent the path passing
    ).findThePath().reversed.toList();

    final start = state.unitSystem.gridToPixelFrom(vector: startPoint);

    final newPath = Path();
    newPath.moveTo(start.x, start.y);

    gridPath
        .map((pathFindingOffset) =>
            state.unitSystem.gridToPixelFrom(offset: pathFindingOffset))
        .forEach((gridPosition) {
      newPath.lineTo(gridPosition.x, gridPosition.y);
    });

    var end = state.unitSystem.gridToPixelFrom(vector: endPoint);
    newPath.lineTo(end.x, end.y);
    return newPath;
  }

  Vector2? lastDragPosition;
  Vector2? lastDragStart;

  void resetElements() {
    components.clear();
    tempPath = null;
  }

  void addPointOnGrid(Vector2 point) =>
      components.add(ColorPoint(point, state));

  void onDragStart(int pointerId, DragStartInfo info) {
    super.onDragStart(pointerId, info);
    resetElements();
    lastDragPosition = info.eventPosition.global;
    lastDragStart = info.eventPosition.global;
    addPointOnGrid(state.unitSystem.pixelToGrid(lastDragPosition!));
  }

  void onDragUpdate(int pointerId, DragUpdateInfo event) {
    super.onDragUpdate(pointerId, event);
    lastDragPosition = event.eventPosition.global;
  }

  void onDragEnd(int pointerId, DragEndInfo event) {
    super.onDragEnd(pointerId, event);
    if (lastDragPosition != null) {
      addPointOnGrid(state.unitSystem.pixelToGrid(lastDragPosition!));
      tempPath = getLineBetween(state.unitSystem.pixelToGrid(lastDragStart!),
          state.unitSystem.pixelToGrid(lastDragPosition!));
    }
  }

  @override
  void render(Canvas canvas) {
    gridLayer.render(canvas);
    super.render(canvas);
    if (tempPath != null) {
      canvas.drawPath(tempPath!, debugPaint);
    }
  }
}
