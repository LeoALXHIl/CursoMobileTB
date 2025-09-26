// Classe responsável por buscar informações no Spotify e converter em OBJ

import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyController {
  // Colocar os dados da API
  // static -- atributo da classe não do objeto
  static const String _baseURL = "https://api.spotify.com/v1";
  static const String _accountsURL = "https://accounts.spotify.com/api/token";
  static const String _clientId = "0ea0b58af3b2401a8297c4ad62de504d";
  static const String _clientSecret = "9c1ad3cb63634fde9b6c9c8ffbb3bd8a";
  static String? _token;

  static Future<String> _getToken() async {
    if (_token != null) return _token!;

    final credentials = base64.encode(utf8.encode("$_clientId:$_clientSecret"));
    final response = await http.post(
      Uri.parse(_accountsURL),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    print("Spotify Token Request Status: ${response.statusCode}");
    print("Spotify Token Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      print("Token obtained successfully: ${_token!.substring(0, 20)}...");
      return _token!;
    } else if (response.statusCode == 400) {
      throw Exception("Token inválido: Credenciais do Spotify (Client ID ou Secret) incorretas. Verifique os valores em SpotifyController.");
    } else if (response.statusCode == 401) {
      throw Exception("Token inválido: Credenciais do Spotify não autorizadas. Verifique se o app está em modo de desenvolvimento e as credenciais estão corretas.");
    } else {
      throw Exception("Falha ao obter token do Spotify: ${response.statusCode} - ${response.body}. Verifique a conexão com a internet e as credenciais do Spotify.");
    }
  }

  // Método para buscar música com base no texto
  // Método static ou seja método executado pela classe não pelo objeto
  static Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    final token = await _getToken();
    // Converter String em URL
    final queryUrl = Uri.parse("$_baseURL/search?q=${Uri.encodeComponent(query)}&type=track&limit=20");
    // http.get com headers
    final response = await http.get(queryUrl, headers: {
      'Authorization': 'Bearer $token',
    });

    print("Spotify Search Request Status: ${response.statusCode}");
    print("Spotify Search Response Body: ${response.body}");

    // Se resposta for ok == 200
    if (response.statusCode == 200) {
      // Converter json em string (dart)
      final data = json.decode(response.body);
      // Retorna convertido String em list<map><String, dynamic>>
      return List<Map<String, dynamic>>.from(data["tracks"]["items"]);
    } else if (response.statusCode == 401) {
      _token = null; // Invalida o token para reobter na próxima tentativa
      throw Exception("Token inválido: O token do Spotify expirou ou é inválido. Verifique as credenciais e tente novamente.");
    } else if (response.statusCode == 400) {
      throw Exception("Requisição inválida: Verifique o termo de busca e tente novamente.");
    } else {
      // Caso contrário cria uma exception
      throw Exception("Falha ao Carregar músicas da API: ${response.statusCode} - ${response.body}");
    }
  }
}
