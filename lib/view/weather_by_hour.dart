import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/styles/text_style.dart';

Widget weatherByHour(String time, String icon, String temp) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyles.titleHourlyWeather,
            ),
            SizedBox(
                width: 50,
                height: 50,
                child: Lottie.network(icon, fit: BoxFit.cover)),
            Text(temp, style: TextStyles.titleHourlyWeather),
          ]),
    ),
  );
}
