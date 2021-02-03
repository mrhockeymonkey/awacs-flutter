import 'package:awacs_flutter/models/asset.dart';
import 'package:awacs_flutter/models/status_color.dart';
import 'package:awacs_flutter/services/asset_api_service.dart';
import 'package:flutter/material.dart';

class WorldPage extends StatefulWidget {
  WorldPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorldPageState();
  }
}

class _WorldPageState extends State<WorldPage> {
  List<Asset> assetData;

  @override
  void initState() {
    super.initState();
    assetData = AssetApiService().getAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AWACS"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GridView.extent(
      maxCrossAxisExtent: 250.0,
      //crossAxisCount: 4,
      childAspectRatio: 1.6,
      // children: [
      //   Container(
      //     child: Text("foo"),
      //     color: Colors.amber,
      //   ),
      //   Container(child: Text("bar"), color: Colors.black)
      // ],
      children: assetData.map((asset) => _buildCard(asset)).toList(),
    );
  }

  Widget _buildCard(Asset asset) {
    Color cardColor;
    IconData cardIcon;

    switch (asset.status) {
      case StatusColor.green:
        cardColor = Colors.green;
        cardIcon = Icons.check;
        break;
      case StatusColor.amber:
        cardColor = Colors.amber;
        cardIcon = Icons.priority_high_outlined;
        break;
      case StatusColor.red:
        cardColor = Colors.red;
        cardIcon = Icons.close_outlined;
        break;
    }

    return Card(
      color: cardColor,
      child: Column(
        children: [
          ListTile(
            leading: Icon(cardIcon),
            title: Text(asset.assetId),
            subtitle: Text(asset.assetClass),
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text("Details"),
              )
            ],
          ),
          SizedBox(
            height: 3,
          )
        ],
      ),
    );
  }
}
