class Item {
  String title;
  bool done;

  Item({this.title, this.done});

  //Para trabalhar com Json
  //método para converter um json para este Item
  //método fromJson() recebe Map<String, dynamic> jason
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  //método para converter este item para um json
  Map<String, dynamic> toJson() {
    //final é como uma const
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}

// Basta passar "var item = new Item(title:'alguma tarefa', done: true)
