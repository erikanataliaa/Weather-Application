import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:weather_application/Weather_bloc.dart';
import 'package:weather_application/features/detail_page/view/weather_search_page.dart';
import 'features/detail_page/data/repository/repository.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperatureCelsius;
  final double temperatureFarenheit;

  Weather({
    @required this.cityName,
    @required this.temperatureCelsius,
    this.temperatureFarenheit,
  });

  @override
  List<Object> get props => [
        cityName,
        temperatureCelsius,
        temperatureFarenheit,
      ];
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: BlocProvider(
        create: (BuildContext context) => WeatherBloc(FakeWeatherRepository()),
        child: WeatherSearchPage(),
      ),
    );
  }
}
