import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  //chamando a minha model globalmente
  var items = new List<Item>();

  Home() {
    //atribuindo tarefas iniciais
    items = [];
    // items.add(Item(title: 'Task 1', done: false));
    // items.add(Item(title: 'Task 2', done: true));
    // items.add(Item(title: 'Task 3', done: false));
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Pegar o valor do campo
  var newTaskCtrl = TextEditingController();

  void add() {
    //validando campo vazio
    if (newTaskCtrl.text.isEmpty) return;

    //alterando o estado e addicionando um item
    setState(() {
      widget.items.add(Item(
        title: newTaskCtrl.text,
        done: false,
      ));
      newTaskCtrl.text = '';
      save();
    });
  }

  void remove(int index) {
    //remove item alterando o estado
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    //chamo o Shared Preferences para guardar as alterações
    var prefs = await SharedPreferences.getInstance();
    //passo os meus dados para o Shared Preferences
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decoded = jsonDecode(data); // transformo em lista
      List<Item> result =
          decoded.map((xMapString) => Item.fromJson(xMapString)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'data', jsonEncode(widget.items)); // transformo em string
  }

  //carrego a minha função dentro do construtor da class
  //isso evita que a função seja disparada toda vez que o componente passar pelo build
  _HomeState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          //passando uma variável de controle
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
          return Dismissible(
            child: CheckboxListTile(
              //incluir checkbox
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                // verificando se o check está marcado ou desmarcado
                setState(() {
                  item.done = value;
                  save();
                });
                // tipo um console.log
                print(value);
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.2),
              child: Align(
                alignment: Alignment(-0.9, 0.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
            onDismissed: (diretion) {
              if (diretion == DismissDirection.startToEnd) print(diretion);
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        //botão de "+" passando a funcão add
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
