import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '757adc50f23846f9bc3153046251207';

  Future<List<Map<String, String>>> fetchWeatherAlerts(String location) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=1&alerts=yes',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['alerts'] != null && data['alerts']['alert'] != null) {
        final alertsData = data['alerts']['alert'] as List<dynamic>;

        return alertsData.map<Map<String, String>>((alert) {
          return {
            'title': alert['headline'] ?? 'No Title',
            'time': alert['effective'] ?? '',
            'description': alert['desc'] ?? alert['instruction'] ?? alert['event'] ?? '',
          };
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load weather alerts');
    }
  }
}

