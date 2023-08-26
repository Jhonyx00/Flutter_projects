import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/styles/text_style.dart';

Widget currentWeather(String icon, String temp, String location, String country,
    String description) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            description,
            style: TextStyles.infoFont,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            width: 150,
            height: 150,
            child: Lottie.network(icon, fit: BoxFit.cover)),
        const SizedBox(
          height: 10,
        ),
        Text(
          temp,
          style: const TextStyle(
              fontSize: 65, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "$location, $country",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        )
      ],
    ),
  );
}
