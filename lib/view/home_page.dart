import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/config/strings.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_api.dart';
import 'package:weather_app/styles/text_style.dart';
import 'package:weather_app/view/aditional_info.dart';
import 'package:weather_app/view/current_weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/view/weather_by_hour.dart';
import '../icons/icons.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double lat = 0;
  double lon = 0;
  bool tap = false;
  late Future<WeatherByHourResponse> _WeatherByHourResponse;

  @override
  void initState() {
    super.initState();
    _WeatherByHourResponse = _getWeather(19.387846, -99.132718);
  }

  Future<WeatherByHourResponse> _getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=b2be242641138b0a0d389309a8d92053&exclude=minutely&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return WeatherByHourResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> determinarPosicion() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinarPosicion();
    lat = position.latitude;
    lon = position.longitude;
  }

  TextEditingController cityController = TextEditingController();

  WeatherService client = WeatherService();
  Weather data = Weather();

//search button
  Future<void> getData() async {
    String cityName =
        cityController.text.isNotEmpty ? cityController.text : 'Mexico city';
    data = await client.getWeatherData(cityName);
    // _getWeather(cityName);

    // _getWeather(cityName);
  }

//location icon
  Future<void> getLocationData() async {
    getCurrentLocation();
    data = await client.getWeatherDataByLocation(lat, lon);
    _WeatherByHourResponse = _getWeather(lat, lon);
  }

  String weatherType(int id) {
    if (id == 800) {
      return sunnyIcon;
    } else if (id == 801) {
      return cloudyIcon;
    } else if (id <= 600) {
      return rainyIcon;
    } else if (id <= 804) {
      return cloudIcon;
    } else if (id < 700) {
      return snowyIcon;
    } else if (id < 300) {
      return stormyIcon;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 18, 48),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          AppStrings.weatherString,
          style: TextStyles.titleApp,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    tap = true;
                    getLocationData();
                  });
                  FocusScope.of(context).unfocus();
                },
                child: const Icon(Icons.location_on_outlined)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                          hintText: AppStrings.searchString,
                          labelText: null,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          focusedBorder: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          filled: true,
                          fillColor: Color.fromARGB(200, 235, 235, 235)),
                    ),
                    Positioned(
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                tap = false;
                                getData();
                              });
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(Icons.search))),
                  ],
                ),
              ),
              FutureBuilder(
                future: tap ? getLocationData() : getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          currentWeather(
                              weatherType(data.id!),
                              "${data.temperature} °C",
                              "${data.cityName}",
                              "${data.country}",
                              "${data.description}"),
                          const SizedBox(
                            height: 35,
                          ),
                          aditionalInformation(
                            '${data.windSpeed} m/s',
                            '${data.humidity}%',
                            '${data.feelsLike}',
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const Spacer();
                },
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppStrings.todayString,
                    style: TextStyles.titleOpacity,
                  ),
                ),
              ),
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Expanded(
                  child: FutureBuilder<WeatherByHourResponse>(
                    future: _WeatherByHourResponse,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error'));
                      } else {
                        final weatherResponse = snapshot.data;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weatherResponse!.hourly.length,
                          itemBuilder: (context, index) {
                            final hourly = weatherResponse.hourly[index];

                            DateTime dateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    ((hourly.dt) * 1000));
                            String formattedTime =
                                "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                            return Card(
                              color: const Color.fromARGB(176, 255, 255, 255),
                              child: weatherByHour(
                                formattedTime,
                                weatherType(hourly.weather.id),
                                '${hourly.temp.toString()} ºC',
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
