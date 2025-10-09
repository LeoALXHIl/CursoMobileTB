import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/photo_model.dart';

class PhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<PhotoModel?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(photo.path);
    final savedImage = await File(photo.path).copy('${appDir.path}/$fileName');

    final position = await Geolocator.getCurrentPosition();

    String? city;
    try {
      final response = await http.get(Uri.parse('http://api.openweathermap.org/geo/1.0/reverse?lat=${position.latitude}&lon=${position.longitude}&limit=1&appid=6ce5df76c5c0a02708fa0e4dd4b31b52'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          city = data[0]['name'];
        }
      }
    } catch (e) {
      // Keep city as null if API fails
    }

    return PhotoModel(
      path: savedImage.path,
      dateTime: DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
    );
  }
}
