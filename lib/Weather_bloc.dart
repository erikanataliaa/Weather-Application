import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:weather_application/NetworkError.dart';
import 'package:weather_application/Weather_event.dart';
import 'package:weather_application/Weather_state.dart';
import 'package:weather_application/repository.dart';
import 'package:weather_application/weather_bloc.dart';

import './Weather_bloc.dart';
// import '../data/repository.dart';

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
