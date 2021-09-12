import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';

// Constants (size in m)
// - Physics
const double SCALE = 0.2;
const double SCALE_WORLD_MULTIPLIER =
    100 * SCALE; // meters to centimeters * scaler

// - Size, close to the american pool table (224x112) which is 2:1, we need 16:9
const double PLAYING_FIELD_HEIGHT = 2.00 * SCALE_WORLD_MULTIPLIER;
const double PLAYING_FIELD_WIDTH = 1.10 * SCALE_WORLD_MULTIPLIER;

// - Grid size
const int GRID_VERT_WIDTH = 11;
const int GRID_VERT_HEIGHT = 19;
const int GRID_WIDTH = GRID_VERT_WIDTH + 1;
const int GRID_HEIGHT = GRID_VERT_HEIGHT + 1;
const double GRID_CELL_GAP = PLAYING_FIELD_WIDTH / GRID_WIDTH;

// - Sizes of different components
const double PLAYER_DIAMETER = 0.06 * SCALE_WORLD_MULTIPLIER;
const double PLANET_DIAMETER = GRID_CELL_GAP * 2;
const double WORMHOLE_DIAMETER = PLANET_DIAMETER;
const double CHECKPOINT_DIAMETER = GRID_CELL_GAP;

class UnitSystem {
  // Getters
  double get pixelsInMeter =>
      screenHeightInPixels / PLAYING_FIELD_HEIGHT * playingFieldToScreenRatio;
  double get playingFieldHeight => PLAYING_FIELD_HEIGHT * pixelsInMeter;
  double get playingFieldWidth => PLAYING_FIELD_WIDTH * pixelsInMeter;
  double get playerDiameter => PLAYER_DIAMETER * pixelsInMeter;
  double get planetDiameter => PLANET_DIAMETER * pixelsInMeter;
  double get checkpointDiameter => CHECKPOINT_DIAMETER * pixelsInMeter;
  double get gridCellGap => GRID_CELL_GAP * pixelsInMeter;
  Vector2 get playingFieldOffset => Vector2(
      screenWidthInPixels / 2 - playingFieldWidth / 2,
      screenHeightInPixels / 2 - playingFieldHeight / 2);
  Vector2 get activeAreaOffset =>
      playingFieldOffset + Vector2(gridCellGap, gridCellGap);

  final double screenHeightInPixels;
  final double screenWidthInPixels;
  final double playingFieldToScreenRatio;

  // Utility methods
  Vector2 metersToPixels(Vector2 meters) =>
      Vector2(meters.x, meters.y) * pixelsInMeter;
  Vector2 pixelToGrid(Vector2 pixelCoordinates) {
    final dragPixelPosition = pixelCoordinates;
    final dragCorrectedPixelPosition = dragPixelPosition - activeAreaOffset;
    final dragGridPosition = dragCorrectedPixelPosition / gridCellGap;
    final dragGridPositionRounded = Vector2(
            dragGridPosition.x.round().toDouble(),
            dragGridPosition.y.round().toDouble()) +
        Vector2.all(1);

    return dragGridPositionRounded;
  }

  Vector2 gridToPixelFrom({Offset? offset, Vector2? vector}) {
    if (offset == null && vector == null) return Vector2.zero();
    if (offset != null) {
      return gridToPixel(offset.dx, offset.dy);
    } else {
      return gridToPixel(vector!.x, vector.y);
    }
  }

  Vector2 gridToPixel(num x, num y) {
    final result = Vector2.copy(playingFieldOffset);
    result.add(Vector2(x * gridCellGap, y * gridCellGap));
    return result;
  }

  UnitSystem(this.screenHeightInPixels, this.screenWidthInPixels,
      {this.playingFieldToScreenRatio = 0.85});
}
