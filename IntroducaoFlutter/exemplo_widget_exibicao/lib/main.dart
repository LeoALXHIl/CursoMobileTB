import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  // build visual widget build
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Exemplo Widget Exibição")),
      body: Center(
        child: Column(
          children: [
            Text("Um Texto Qualquer",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),),
            Image.network("https://imgs.search.brave.com/1yRkFaoj6otuXETMqxdiCZng9QPll5s074Scg1QzXB4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/a2luZHBuZy5jb20v/cGljYy9tLzM1NS0z/NTU3NDgyX2ZsdXR0/ZXItbG9nby1wbmct/dHJhbnNwYXJlbnQt/cG5nLnBuZw", 
            width: 200,
            height: 200,
            fit: BoxFit.cover,),
            Image.asset("assets/img/einstein.png",
            width: 200,
            height: 200,
            fit: BoxFit.cover),
            Icon(Icons.tiktok,
            size: 100,
            color: Colors.amber,)
          ],
        ),
      ),
    ),
  );
  }
}