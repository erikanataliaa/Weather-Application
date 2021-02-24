import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:weather_application/features/detail_page/bloc/Weather_event.dart';
import 'package:weather_application/features/detail_page/bloc/Weather_state.dart';
import 'package:weather_application/features/detail_page/data/repository/repository.dart';

class NetworkError extends Error {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial());

  // WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    //emitting a state from the asynchronus generator
    yield WeatherLoading();
    //branching the executed logic by checking the event type
    if (event is GetWeather) {
      //emit either loaded or error
      try {
        final weather = await repository.fetchWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't fetch weather. Is the device online?");
        yield WeatherInitial();
      }
    } else if (event is GetDetailedWeather) {
      try {
        final weather = await repository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't fetch weather. Is the device online?");
        yield WeatherInitial();
      }
    }
  }
}
