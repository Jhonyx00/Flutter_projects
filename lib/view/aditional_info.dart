import 'package:flutter/material.dart';
import 'package:weather_app/config/strings.dart';
import '../styles/text_style.dart';

Widget aditionalInformation(String wind, String humidity, String feelsLike) {
  return Container(
    decoration: BoxDecoration(
        color: const Color.fromARGB(58, 255, 255, 255),
        borderRadius: BorderRadius.circular(20)),
    width: double.infinity,
    padding: const EdgeInsets.all(18.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    wind,
                    style: TextStyles.infoFont,
                  ),
                ),
                const Text(
                  AppStrings.windString,
                  style: TextStyles.titleOpacity,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    humidity,
                    style: TextStyles.infoFont,
                  ),
                ),
                const Text(
                  AppStrings.humidityString,
                  style: TextStyles.titleOpacity,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$feelsLike °C',
                    style: TextStyles.infoFont,
                  ),
                ),
                const Text(
                  AppStrings.feelsLikeString,
                  style: TextStyles.titleOpacity,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
