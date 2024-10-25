import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetStartedView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GetStartedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
