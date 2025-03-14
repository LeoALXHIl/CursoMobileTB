import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // estudo do scaffold
      home: Scaffold(
        // app bar barra de navegação superior
        appBar: AppBar(title: Text("exemplo appBar")),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // corpo do aplicativo
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50, // Ajuste o tamanho da largura
                        height: 50, // Ajuste o tamanho da altura
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180),
                          color: const Color.fromARGB(255, 245, 203, 200),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/img/image.png"),
                        radius: 100,
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Leonardo Aleixo",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Alinha os ícones no centro
                children: List.generate(5, (index) => Icon(
                  Icons.star, 
                  color: Colors.amberAccent,
                )),
              ),
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5), 
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5, 
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text("texto 1"),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.all(10), 
                    padding: EdgeInsets.all(5), 
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5, 
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text("texto 2"),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.all(10), // Margem externa de 20 pixels
                    padding: EdgeInsets.all(5), // Espaçamento interno de 10 pixels
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5, // Efeito de sombra
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text("texto 3"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50), // Espaço entre as linha
              SizedBox(height: 50), // Espaço entre as linhas
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 10),
                      Text("Home"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Text("Search"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text("Profile"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text("Settings"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.help),
                      SizedBox(width: 10),
                      Text("Help"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // barra de navegação inferior
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "pesquisa",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "usuario"),
          ],
        ),
        // barra lateral || botao hamburger
        drawer: Drawer(
          child: ListView(
            children: <Widget>[Text("inicio"), Text("inicio"), Text("inicio")],
          ),
        ),
        // botao flutuante
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // ignore: avoid_print
            print("botao clicado");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}