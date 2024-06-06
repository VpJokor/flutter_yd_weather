import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import '../widget/my_search_bar.dart';

class SelectCityPage extends StatefulWidget {
  const SelectCityPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: MySearchBar(
        hintText: "搜索城市（中文/拼音）",
        backgroundColor: context.backgroundColor,
        showDivider: true,
        autofocus: false,
        onChanged: (searchKey) {
        },
        submittedHintText: "请输入搜索关键字",
        onSubmitted: (searchKey) {
        },
      ),
    );
  }
}
