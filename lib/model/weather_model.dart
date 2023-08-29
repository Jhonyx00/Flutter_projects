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
