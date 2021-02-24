import 'dart:math';

import 'package:weather_application/main.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
  Future<Weather> fetchDetailedWeather(String cityName);
}

class NetworkError extends Error {}

class FakeWeatherRepository implements WeatherRepository {
  double cachedTempCelsius;

  @override
  Future<Weather> fetchWeather(String cityName) {
    //Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();

        //simulate some network error
        if (random.nextBool()) {
          throw NetworkError();
        }

        cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

        return Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius,
        );
      },
    );
  }

  @override
  Future<Weather> fetchDetailedWeather(String cityName) {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius,
          temperatureFarenheit: cachedTempCelsius * 1.8 + 32,
        );
      },
    );
  }
}
