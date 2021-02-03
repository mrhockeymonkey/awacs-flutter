import 'dart:core';
import "package:collection/collection.dart";

import 'package:awacs_flutter/models/asset.dart';
import 'package:awacs_flutter/models/asset_class_summary.dart';
import '../models/status_color.dart';

class AssetApiService {
  List<Asset> data = [
    Asset("host1", "linux-activity", "infradev", StatusColor.green),
    Asset("host2", "linux-activity", "infradev", StatusColor.amber),
    Asset("host3", "windows-patching", "infraauto", StatusColor.green),
    Asset("host4", "linux-activity", "cpe", StatusColor.green),
    Asset("host5", "linux-activity", "cpe", StatusColor.red),
    Asset("host6", "windows-patching", "cpe", StatusColor.amber),
    Asset("host7", "linux-activity", "cpe", StatusColor.green),
  ];

  List<Asset> getAssets() {
    return data;
  }

  List<Asset> getAssetsOfClass(String assetClass) {
    return data.where((element) => element.assetClass == assetClass).toList();
  }

  List<AssetClassSummary> getAssetClasses() {
    List<AssetClassSummary> summaryList = [];

    var grouped = groupBy(data, (Asset asset) => asset.assetClass);
    grouped.forEach((key, value) {
      var summary = new AssetClassSummary(
        key,
        value.where((element) => element.status == StatusColor.green).length,
        value.where((element) => element.status == StatusColor.amber).length,
        value.where((element) => element.status == StatusColor.red).length,
      );
      summaryList.add(summary);
    });
    return summaryList;
  }
}
