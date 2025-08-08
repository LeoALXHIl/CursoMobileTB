import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget{
  //atributos
  final bool temaEscuro;
  final String nomeUsuario;
  final Function(bool, String) onSalvar;

  //construtor
  ConfigPage({
    required this.temaEscuro, required this.nomeUsuario, required this.onSalvar
  });
  
  @override
  State<StatefulWidget> createState() {
    return _ConfigPageState();
  }
}

class _ConfigPageState extends State<ConfigPage>{
  //atributos
  // ldate inicialmente null vai rreceber o valor depois
  late bool _temaEscuro;
  //campos de formularios
  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    //atribui o valor da String/Json
    _temaEscuro = widget.temaEscuro;
    _nomeController = TextEditingController(text: widget.nomeUsuario);
  }

  //metodo para salvaer as configuraçoes do usuario 
  void salvarConfiguracoes() async{
    Map<String,dynamic> config = {
      "temaEscuro": _temaEscuro,
      "nome": _nomeController.text.trim()
    };
    // chama o shared preferences e converte o map para string/json, salva o valor no shared preferences
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(config);
    prefs.setString("config", jsonString);

    //função chama a atualização
    widget.onSalvar(_temaEscuro,_nomeController.text.trim());
  }

  // Construção dos widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preferencias do Usuario"),),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: Text("Tema Escuro"),
            value: _temaEscuro,
           onChanged: (bool value){
                setState(() {
                  _temaEscuro = value;
                });
              }),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome do Usuario"),
              ),
              SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async{
                salvarConfiguracoes();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Preferências salvas")));

              }, 
              child: Text("Salvar Preferencias")),
              SizedBox(height: 40),
            Divider(),
            Text(
              "Resumo Atual:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Text("tema: ${_temaEscuro ? "Escuro" : "claro"}"),
            Text("Usuario: ${_nomeController.text}"),
          ],
        ),
      ),
    );
  }
}
