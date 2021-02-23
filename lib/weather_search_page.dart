import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc_v1_tutorial/data/model/weather.dart';
import 'package:weather_application/Weather_bloc.dart';
import 'package:weather_application/Weather_event.dart';
import 'package:weather_application/Weather_state.dart';
import 'package:weather_application/main.dart';
// import 'package:weather_application/repository.dart';

import 'Weather_bloc.dart';
import 'weather_detail_page.dart';

class WeatherSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherInitial) {
                return builtInitialInput();
              }
              if (state is WeatherLoading) {
                return builtLoading();
              }
              if (state is WeatherLoaded) {
                return buildColumnWithData(context, state.weather);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget builtInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget builtLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          //display temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        RaisedButton(
          child: Text('See Details'),
          color: Colors.lightBlue[100],
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<WeatherBloc>(context),
                child: WeatherDetailPage(
                  masterWeather: weather,
                ),
              ),
            ));
          },
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    //fetch weather from repos and display it
    //get the bloc using bloc provider
    //false positive lint warning, safe to ignore until it gets fixed

    // ignore: close_sinks
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    //initiate getting the weather
    weatherBloc.add(GetWeather(cityName));
  }
}
