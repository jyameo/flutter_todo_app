import 'package:flutter/material.dart';

class NotodoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int _id;

  NotodoItem(this._itemName, this._dateCreated);

  NotodoItem.map(dynamic obj) {
    this._itemName = obj['itemName'];
    this._dateCreated = obj['dateCreated'];
    this._id = obj['id'];
  }

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;

//  set itemName(String name) => _itemName = name;

  Map<String, dynamic> toMap() {
    var item = Map<String, dynamic>();
    item['itemName'] = _itemName;
    item['dateCreated'] = _dateCreated;

    if (_id != null) {
      item['id'] = _id;
    }
    return item;
  }

  NotodoItem.fromMap(Map<String, dynamic> item) {
    this._itemName = item['itemName'];
    this._dateCreated = item['dateCreated'];
    this._id = item['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _itemName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              "Create on: $_dateCreated",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
