import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(title: 'Meu Perfil Persistente', home: MeuPerfilPage()));

class MeuPerfilPage extends StatefulWidget {
  const MeuPerfilPage({Key? key}) : super(key: key);
  @override
  _MeuPerfilPageState createState() => _MeuPerfilPageState();
}

class _MeuPerfilPageState extends State<MeuPerfilPage> {
  final _nomeController = TextEditingController(), _idadeController = TextEditingController();
  String _corFavorita = 'Azul', _nomeSalvo = '', _idadeSalva = '', _corSalva = 'Azul';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _nomeSalvo = prefs.getString('nome') ?? '';
        _idadeSalva = prefs.getString('idade') ?? '';
        _corSalva = prefs.getString('corFavorita') ?? 'Azul';
      });
    });
  }

  Future<void> _salvarDados() async {
    if (_nomeController.text.isEmpty || _idadeController.text.isEmpty) return _mostrarSnackBar('Preencha todos os campos!');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', _nomeController.text);
    await prefs.setString('idade', _idadeController.text);
    await prefs.setString('corFavorita', _corFavorita);
    setState(() {
      _nomeSalvo = _nomeController.text;
      _idadeSalva = _idadeController.text;
      _corSalva = _corFavorita;
    });
    _mostrarSnackBar('Dados salvos com sucesso!');
  }

  Future<void> _limparDados() async {
    await (await SharedPreferences.getInstance()).clear();
    setState(() {_nomeSalvo = ''; _idadeSalva = ''; _corSalva = 'Azul';});
    _mostrarSnackBar('Dados limpos com sucesso!');
  }

  void _mostrarSnackBar(String mensagem) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _corSalva == 'Azul'
            ? Colors.blue[100]
            : _corSalva == 'Verde'
                ? Colors.green[100]
                : Colors.red[100],
        appBar: AppBar(title: const Text('Meu Perfil Persistente'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Preencha suas informações:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildTextField('Nome', _nomeController),
                  const SizedBox(height: 10),
                  _buildTextField('Idade', _idadeController, isNumber: true),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _corFavorita,
                    decoration: InputDecoration(labelText: 'Cor Favorita', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    items: const [
                      DropdownMenuItem(value: 'Azul', child: Text('Azul')),
                      DropdownMenuItem(value: 'Verde', child: Text('Verde')),
                      DropdownMenuItem(value: 'Vermelho', child: Text('Vermelho')),
                    ],
                    onChanged: (newValue) => setState(() => _corFavorita = newValue!),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(onPressed: _salvarDados, icon: const Icon(Icons.save), label: const Text('Salvar')),
                      ElevatedButton.icon(
                        onPressed: _limparDados,
                        icon: const Icon(Icons.delete),
                        label: const Text('Limpar'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text('Dados Salvos:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Nome: $_nomeSalvo\nIdade: $_idadeSalva\nCor Favorita: $_corSalva'),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) => TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      );
}
