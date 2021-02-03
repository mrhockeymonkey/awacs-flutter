import './status_color.dart';

class Asset {
  final String assetId;
  final String assetClass;
  final String owner;
  final StatusColor status;

  Asset(this.assetId, this.assetClass, this.owner, this.status);
}
