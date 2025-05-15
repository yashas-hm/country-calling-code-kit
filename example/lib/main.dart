import 'dart:io';

import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Calling Code Kit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Demo(),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  Country? country;

  @override
  void initState() {
    getCountry();
    super.initState();
  }

  void getCountry() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      country = await getDefaultCountry() ?? countries.first;
    } else {
      country = countries.first;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Country Calling Code Kit Demo')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Text('Selected Country', style: TextStyle(fontSize: 40)),
              if (country != null)
                Image.asset(
                  country!.flag,
                  width: 250,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              if (country != null)
                Text(
                  'Name: ${country!.name}\nCode: ${country!.countryCode.toString().toUpperCase()}\nCall Code: ${country!.callCode}',
                  style: TextStyle(fontSize: 20),
                ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  country = await showCountryPickerModalSheet(context: context);
                  setState(() {});
                },
                child: Text(
                  'Select Country using bottom sheet',
                ),
              ),
              MaterialButton(
                color: Colors.greenAccent,
                onPressed: () async {
                  country = await showCountryPickerDialog(context: context);
                  setState(() {});
                },
                child: Text(
                  'Select Country using dialog',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
