import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/config/strings.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_api.dart';
import 'package:weather_app/styles/text_style.dart';
import 'package:weather_app/view/aditional_info.dart';
import 'package:weather_app/view/current_weather.dart';
import 'package:geolocator/geolocator.dart';
import '../icons/icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double lat = 0;
  double lon = 0;
  bool tap = false;

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

  Future<void> getData() async {
    String cityName =
        cityController.text.isNotEmpty ? cityController.text : 'Mexico city';
    data = await client.getWeatherData(cityName);
  }

  Future<void> getLocationData() async {
    getCurrentLocation();
    data = await client.getWeatherDataByLocation(lat, lon);
  }

  String weatherType() {
    if (data.id == 800) {
      return sunnyIcon;
    } else if (data.id == 801) {
      return cloudyIcon;
    } else if (data.id! <= 600) {
      return rainyIcon;
    } else if (data.id! <= 804) {
      return cloudIcon;
    } else if (data.id! < 700) {
      return snowyIcon;
    } else if ((data.id)! < 300) {
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
              Expanded(
                child: FutureBuilder(
                  future: tap ? getLocationData() : getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            currentWeather(
                                weatherType(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
