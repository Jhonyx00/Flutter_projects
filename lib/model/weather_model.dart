class Weather {
  String? cityName;
  int? id;
  var feelsLike;
  int? uV;
  double? temperature;
  int? humidity;
  int? pressure;
  double? minTemp;
  double? maxTemp;
  int? visibility;
  String? country;
  double? windSpeed;
  int? windDirection;
  String? condition;
  String? description;

  Weather({
    this.uV,
    this.cityName,
    this.id,
    this.visibility,
    this.country,
    this.windSpeed,
    this.temperature,
    this.minTemp,
    this.maxTemp,
    this.pressure,
    this.windDirection,
    this.humidity,
    this.feelsLike,
    this.condition,
    this.description,
  });

  Weather.fromJson(Map<String, dynamic> json) {
    uV = json['main']['uvi'];
    cityName = json['name'];
    id = json['weather'][0]['id'];
    visibility = json['visibility'];
    country = json['sys']['country'];
    windSpeed = json['wind']['speed'];
    temperature = json['main']['temp'];
    minTemp = json['main']['temp_min'];
    maxTemp = json['main']['temp_max'];
    pressure = json['main']['pressure'];
    windDirection = json['wind']['deg'];
    humidity = json['main']['humidity'];
    feelsLike = json['main']['feels_like'];
    condition = json['weather'][0]['main'];
    description = json['weather'][0]['description'];
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
