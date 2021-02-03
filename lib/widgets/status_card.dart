import 'package:awacs_flutter/models/status_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final StatusColor statusColor;
  final bool isSelected;
  final Function onTap;

  StatusCard({
    @required this.title,
    @required this.statusColor,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color selectedColor;
    IconData cardIcon;

    switch (statusColor) {
      case StatusColor.green:
        iconColor = Colors.green;
        selectedColor = Colors.green[900];
        cardIcon = Icons.check;
        break;
      case StatusColor.amber:
        iconColor = Colors.amber;
        selectedColor = Colors.amber[900];
        cardIcon = Icons.priority_high_outlined;
        break;
      case StatusColor.red:
        iconColor = Colors.red;
        selectedColor = Colors.red[900];
        cardIcon = Icons.close_outlined;
        break;
      default:
        iconColor = Colors.grey;
        selectedColor = Colors.grey[900];
        cardIcon = Icons.help_outline;
        break;
    }

    return Card(
      //color: cardColor,
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          "foo",
          style: TextStyle(color: iconColor),
        ),
        leading: Icon(
          cardIcon,
          color: iconColor,
          size: 28,
        ),
        trailing: this.onTap != null ? Icon(Icons.chevron_right) : null,
        onTap: this.onTap,
        selected: this.isSelected,
        selectedTileColor: selectedColor,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
