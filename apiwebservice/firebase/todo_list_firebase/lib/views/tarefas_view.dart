import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}
//atributos
final _db = FirebaseFirestore.instance;// controller para enviar tarefas para o baco de dados firestore
final User? _user = FirebaseAuth.instance.currentUser;// pega o usuario logado
final _tarefasField = TextEditingController(); // controller do campo de tarefa

//metodo para adicionar tarefa
void _addTarefa(BuildContext context) async{
  if(_tarefasField.text.trim().isEmpty && _user ==null) return;
  //adicionar tarefas ao banco
  try {
    await _db.collection("usuarios")
    .doc(_user!.uid)
    .collection("tarefas")
    .add({
      "titulo":_tarefasField.text.trim(),
      "concluida":false,
      "dataCriacao": Timestamp.now()
    });
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao Aicionar Tarefa: $e"),)
    );
    
  }
} 


//metodo para atualizar status da tarefa
void _updateTarefa(String tarefaId, bool concluida) async{
  try {
    await _db.collection("usuarios")
    .doc(_user!.uid)
    .collection("tarefas")
    .doc(tarefaId)
    .update({"concluida": concluida});
  } catch (e) {
    print("Erro ao atualizar tarefa: $e");
  }
}



//metodo para deletar tarefa
void _deleteTarefa(String tarefaId) async{
  try {
    await _db.collection("usuarios")
    .doc(_user!.uid)
    .collection("tarefas")
    .doc(tarefaId)
    .delete();
  } catch (e) {
    print("Errro ao deletar tarefa: $e");
  }
}

//build da tela
class _TarefasViewState extends State<TarefasView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Tarefas"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16), 
      child: Column(
        children: [
          TextField(
            controller: _tarefasField,
            decoration: InputDecoration(
              labelText: "Nova Tarefa",
              border: OutlineInputBorder(),
              suffix: IconButton(
                onPressed: () => _addTarefa(context), 
                icon: Icon(Icons.add))
            ),
          ),
          SizedBox(height: 20,),
          Expanded(child: StreamBuilder<QuerySnapshot>( //armazena o resultado da consulta e exibe na tela
            stream: _db.collection("usuarios")
            .doc(_user?.uid)
            .collection("tarefas")
            .orderBy("dataCriacao", descending: true)
            .snapshots(), 
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
                return Center(child: Text("Nenhuma Tarefa Encontrada"));
             
              }
              final tarefas = snapshot.data!.docs;
              return ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index){
                  final tarefa = tarefas[index];
                  final tarefaData = tarefa.data() as Map<String, dynamic>;
                  bool concluida = tarefaData["concluida"] ?? false;
                return ListTile(
                  title: Text(tarefaData["titulo"]),
                  leading: Checkbox(
                    value: concluida,
                    onChanged: (value){
                      setState(() {
                        concluida = value!;
                      });
                      _updateTarefa(tarefa.id, value!);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue,),
                        onPressed: () => _updateTarefa(tarefa.id, concluida),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () => _deleteTarefa(tarefa.id),
                      ),
                    ],
                  ),
                );
              
            });
          })),
        ],
      ),
      ),
    );
  }
}