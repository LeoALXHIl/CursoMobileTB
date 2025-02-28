import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // estudo do scaffold
      home: Scaffold(
        // app bar barra de navegação superior
        appBar: AppBar(
          title: Text("exemplo appBar"),
        ),
        backgroundColor: Colors.blue,
        // corpo do aplicativo
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.star),
                Icon(Icons.star),
                Icon(Icons.star),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.favorite),
                Icon(Icons.favorite),
                Icon(Icons.favorite),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up),
                Icon(Icons.thumb_up),
                Icon(Icons.thumb_up),
              ],
            ),
          ],
        ),
        // barra de navegação inferior
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "pesquisa",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "usuario",
            ),
          ],
        ),
        // barra lateral || botao hamburger
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Text("inicio"),
              Text("inicio"),
              Text("inicio"),
            ],
          ),
        ),
        // botao flutuante
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("botao clicado");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
