import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(home:Myapp()));
}
class Myapp extends StatelessWidget{
// lista de imagens
final List<String> imagens =[
      'https://images.unsplash.com/photo-1739130524827-5fa364835c41?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0fHx8ZW58MHx8fHx8',
      'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
      'https://images.unsplash.com/photo-1518837695005-2083093ee35b',
      'https://images.unsplash.com/photo-1739130524827-5fa364835c41?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0fHx8ZW58MHx8fHx8',
      'https://images.unsplash.com/photo-1741531472824-b3fc55e2ff9c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1741526179588-c6e13e956309?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1506619216599-9d16d0903dfd',
      'https://images.unsplash.com/photo-1494172961521-33799ddd43a5',
      'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4',
];


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Galeria de Imagens"),
    ),
    body: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: CarouselSlider(
              options: CarouselOptions(height: 300, autoPlay: true),
              items: imagens.map((url) {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(url, fit: BoxFit.cover, width: 1000),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8, ),
            itemCount: imagens.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _mostrarimagem(context,imagens[index]),
                child: Image.network(imagens[index],fit: BoxFit.cover,),

              );
            },
          )), // rolagem da tela
        ],
      ),
    ),
  );
}
void _mostrarimagem(BuildContext context, String url){
  showDialog(context: context, builder: (context) => Dialog(
    child: Image.network(url),
  ));
}
}