import 'package:flutter/material.dart';
import 'package:myapptest/models/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  var items = new List<Item>();

  Home() {
    items = [];
    items.add(Item(title: 'Task 1', done: false));
    items.add(Item(title: 'Task 2', done: true));
    items.add(Item(title: 'Task 3', done: false));
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelText: 'Nova tarefa',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          Icon(Icons.edit),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return CheckboxListTile(
            title: Text(item.title),
            key: Key(item.title),
            value: item.done,
            onChanged: (value) {
              setState(() {
                item.done = value;
              });
              print(value);
            },
          );
        },
      ),
    );
  }
}
