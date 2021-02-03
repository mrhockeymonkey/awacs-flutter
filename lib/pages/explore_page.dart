import 'package:awacs_flutter/models/status_color.dart';
import 'package:awacs_flutter/widgets/status_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:awacs_flutter/models/asset.dart';
import 'package:awacs_flutter/services/asset_api_service.dart';

class ExplorerPage extends StatefulWidget {
  ExplorerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExplorerPageState();
  }
}

class _ExplorerPageState extends State<ExplorerPage> {
  List<Asset> assetData;
  String _selectedAssetClass;
  String _selectedAssetId;
  String _selectedEvent;
  Future<String> _loaded;
  int _singleColumnFocus;

  @override
  void initState() {
    super.initState();
    assetData = AssetApiService().getAssets();
    _singleColumnFocus = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Scaffold(
          appBar: AppBar(
            title: Text("AWACS"),
            actions: [
              IconButton(
                  icon: Icon(Icons.grid_view),
                  onPressed: () {
                    Navigator.pushNamed(context, '/world');
                  }),
            ],
          ),
          body: constraints.maxWidth > 1000
              ? _buildThreeColumn()
              : _buildSingleColumn(_singleColumnFocus),
        ),
      ),
    );
  }

  Widget _buildThreeColumn() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildAssetClassColumn(false),
        ),
        Expanded(
          flex: 2,
          child: _buildAssetIdColumn(false),
        ),
        Expanded(
          flex: 3,
          child: _buildAssetDetailsColumn(false),
        ),
      ],
    );
  }

  Widget _buildSingleColumn(int activeColumn) {
    switch (activeColumn) {
      case 0:
        return _buildAssetClassColumn();
      case 1:
        return _buildAssetIdColumn();
      case 2:
        return _buildAssetDetailsColumn();
      default:
        return Text("Unknown Column");
    }
  }

  Widget _buildColumnHeader(String title, [bool backBtnEnabled = true]) {
    return Row(
      children: [
        _singleColumnFocus > 0 && backBtnEnabled
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _singleColumnFocus = _singleColumnFocus - 1;
                  });
                },
              )
            : Container(),
        Text(
          title,
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildAssetClassColumn([bool backBtnEnabled = true]) {
    var assetClasses = AssetApiService().getAssetClasses();

    return Column(
      children: [
        _buildColumnHeader("Asset Class", backBtnEnabled),
        Expanded(
          child: ListView.builder(
            itemCount: assetClasses.length,
            itemBuilder: (context, index) {
              var item = assetClasses[index];
              return StatusCard(
                title: item.name,
                statusColor: item.statusColor,
                isSelected: item.name == _selectedAssetClass,
                onTap: () {
                  setState(() {
                    _selectedAssetClass = item.name;
                    _singleColumnFocus = 1;
                  });
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildAssetIdColumn([bool backBtnEnabled = true]) {
    var assets = AssetApiService().getAssetsOfClass(_selectedAssetClass);

    return Column(
      children: [
        _buildColumnHeader("Assets", backBtnEnabled),
        Expanded(
          child: assets.isEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text("Select Asset Class")
                  ],
                )
              : ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    var item = assets[index];
                    return StatusCard(
                      title: item.assetId,
                      statusColor: item.status,
                      isSelected: item.assetId == _selectedAssetId,
                      onTap: () {
                        setState(() {
                          _selectedAssetId = item.assetId;
                          _singleColumnFocus = 2;
                        });
                      },
                    );
                  },
                ),
        )
      ],
    );
  }

  Widget _buildAssetDetailsColumn([bool backBtnEnabled = true]) {
    if (_selectedAssetId == null) {
      return Column(
        children: [
          _buildColumnHeader("Asset Details"),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Text("Select Asset"),
          )
        ],
      );
    }
    Map<String, dynamic> mockData = {
      "property1": "some property",
      "property2": "some other property",
      "metadata": {"meta1": "extra info", "meta2": "extra info"},
      "owner": "owner"
    };
    JsonEncoder encoder = new JsonEncoder.withIndent('    ');
    var json = encoder.convert(mockData);

    return Column(
      children: [
        _buildColumnHeader("Asset Details", backBtnEnabled),
        Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text("Asset Class: "),
                ),
                Expanded(
                  child: Card(
                    child: Text(_selectedAssetClass ?? ""),
                  ),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text("Asset ID: "),
                ),
                Expanded(
                  child: Card(
                    child: Text(_selectedAssetId ?? ""),
                  ),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text("Event: "),
                ),
                Expanded(
                  child: Card(
                    child: Text(_selectedEvent ?? ""),
                  ),
                )
              ],
            ),
            Row(
              children: [Text("Metadata: ")],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: FutureBuilder(
                      future: _loaded,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (_selectedEvent == null) {
                          return Text("{ }");
                        } else if (snapshot.data != _selectedEvent) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                            ),
                          );
                        } else {
                          return Text(json);
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            Text("Events:"),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => StatusCard(
              title: "Event ${index.toString()}",
              statusColor: StatusColor.green,
              isSelected: _selectedEvent == "Event ${index.toString()}",
              onTap: () {
                setState(() {
                  _selectedEvent = "event-${index.toString()}";
                  _loaded = Future<String>.delayed(
                      Duration(seconds: 2), () => _selectedEvent);
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
