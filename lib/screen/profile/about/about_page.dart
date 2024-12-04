import 'package:flutter/material.dart';
import 'package:todo/utils/common.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: Common.isLargeScreen(context)
                  ? 200
                  : Common.isMediumScreen(context)
                      ? 100
                      : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                "asset/images/splashscreen.png",
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Floran : Todo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Todo App is designed to make managing tasks simple and stress-free. It helps you plan, prioritize, and track everything in one place. Whether it’s daily chores, work projects, or personal goals, our features keep you organized and on track.",
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Our goal is to help you achieve more with less effort. With an easy-to-use interface, secure data, and real-time syncing, staying productive has never been easier.",
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Enjoy your day.",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
