import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config/constants.dart';
import '../model/city_data.dart';

class CityManagerPage extends StatefulWidget {
  const CityManagerPage({super.key});

  @override
  State<CityManagerPage> createState() => _CityManagerPageState();
}

class _CityManagerPageState extends State<CityManagerPage> {
  final _cityDataBox = Hive.box<CityData>(Constants.cityDataBox);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
