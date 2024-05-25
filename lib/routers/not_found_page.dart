import 'package:flutter/material.dart';
import '../widget/my_app_bar.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        centerTitle: '页面不存在',
      ),
      body: Center(
        child: Text("页面不存在"),
      ),
    );
  }
}
