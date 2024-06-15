import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';

class WeatherMainPage extends StatefulWidget {
  const WeatherMainPage({super.key});

  @override
  State<WeatherMainPage> createState() => _WeatherMainPageState();
}

class _WeatherMainPageState extends State<WeatherMainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.backgroundColor,
    );
  }
}
