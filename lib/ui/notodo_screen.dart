import 'package:flutter/material.dart';
import 'package:flutter_notodo/model/notodo_item.dart';
import 'package:flutter_notodo/util/database_client.dart';

class NotodoScreen extends StatefulWidget {
  @override
  _NotodoScreenState createState() => _NotodoScreenState();
}

class _NotodoScreenState extends State<NotodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  final List<NotodoItem> _items = <NotodoItem>[];

  @override
  void initState() {
    super.initState();
    _readNotodoList();
  }

  void _handleSubmit(String text) async {
    _textEditingController.clear();

    NotodoItem item = NotodoItem(text, DateTime.now().toIso8601String());
    int itemId = await db.saveItem(item);

    NotodoItem newItem = await db.getItem(itemId);

    setState(() {
      _items.insert(0, newItem);
    });
//    print("Item Saved Id: $itemId");
//    _readNotodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _items.length,
                  itemBuilder: (_, int index) {
                    return Card(
                      color: Colors.white10,
                      child: ListTile(
                        title: _items[index],
                        onLongPress: () => debugPrint(""),
                        trailing: Listener(
                          key: Key(_items[index].itemName),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteNotodo(_items[index].id, index),
                        ),
                      ),
                    );
                  })),
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "eg. Don't buy stuff",
                  icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmit(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNotodoList() async {
    List items = await db.getItems();
    items.forEach((item) {
//      NotodoItem todoItem = NotodoItem.map(item);
      setState(() {
        _items.add(NotodoItem.map(item));
      });
//      print("DB items: ${todoItem.itemName}");
    });
  }

  _deleteNotodo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _items.removeAt(index);
    });
  }
}
