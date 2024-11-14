import 'package:flutter/material.dart';

import 'package:cafetariat/widgets/dashboard_widget.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Welcome to the Dashboard",
              style: Theme.of(context).textTheme.titleLarge, // Updated text style
            ),
          ),
          const Expanded(
            child: DashboardWidget(), // Embeds the DashboardWidget within the Home screen
          ),
        ],
      ),
    );
  }
}
