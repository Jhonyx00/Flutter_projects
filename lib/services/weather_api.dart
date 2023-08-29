import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherService {
  Future<Weather> getWeatherData(String? location) async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=c0aa9806242627e162c6afe0e84c2c14&units=metric');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  Future<Weather> getWeatherDataByLocation(
      double? latitude, double? longitude) async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=c0aa9806242627e162c6afe0e84c2c14&units=metric');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }
}

class WeatherByHourResponse {
  final List<Hourly> hourly;

  WeatherByHourResponse({required this.hourly});

  factory WeatherByHourResponse.fromJson(Map<String, dynamic> json) {
    return WeatherByHourResponse(
      hourly: List<Hourly>.from(
          json['hourly'].map((hourly) => Hourly.fromJson(hourly))),
    );
  }
}

class Hourly {
  final int dt;
  var temp;
  final WeatherByHour weather;

  Hourly({required this.dt, required this.temp, required this.weather});

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      dt: json['dt'],
      temp: json['temp'],
      weather: WeatherByHour.fromJson(json['weather'][0]),
    );
  }
}

class WeatherByHour {
  final String main;
  final int id;

  WeatherByHour({required this.main, required this.id});

  factory WeatherByHour.fromJson(Map<String, dynamic> json) {
    return WeatherByHour(
      id: json['id'],
      main: json['main'],
    );
  }
}
