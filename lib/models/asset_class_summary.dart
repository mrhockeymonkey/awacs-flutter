import 'package:awacs_flutter/models/status_color.dart';

class AssetClassSummary {
  String name;
  int greenCount;
  int amberCount;
  int redCount;

  AssetClassSummary(
    this.name,
    this.greenCount,
    this.amberCount,
    this.redCount,
  );

  StatusColor get statusColor {
    if (redCount > 0) {
      return StatusColor.red;
    }
    if (amberCount > 0) {
      return StatusColor.amber;
    }
    return StatusColor.green;
  }
}
