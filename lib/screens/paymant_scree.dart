import 'package:flutter/material.dart';

class PaymantScreen extends StatelessWidget {
  const PaymantScreen({Key? key}) : super(key: key);

  static const routeName = '/paymant-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymant'),
      ),
      body: const Text('Paymant'),
    );
  }
}
