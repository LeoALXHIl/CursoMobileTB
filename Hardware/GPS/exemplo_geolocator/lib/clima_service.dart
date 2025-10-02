import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ClimaService {
    String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
    String apiKey = "6ce5df76c5c0a02708fa0e4dd4b31b52";

    Future<Map<String,dynamic>?> getCityWeatherByPosition(Position position) async{
        try{
            final response = await http.get(Uri.parse("$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey"));

            if(response.statusCode == 200){
                return jsonDecode(response.body);
            } else{
                throw Exception();
            }
        } catch(e){
            rethrow;
        }
    }
}