import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_application/Weather_bloc.dart';
import 'package:weather_application/Weather_event.dart';
import 'package:weather_application/Weather_state.dart';

// import '../data/model/weather.dart';
import 'main.dart';

class WeatherDetailPage extends StatefulWidget {
  final Weather masterWeather;

  const WeatherDetailPage({
    Key key,
    @required this.masterWeather,
  }) : super(key: key);

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void didChangeDepedencies() {
    super.didChangeDependencies();
    //immediately trigger the event
    BlocProvider.of<WeatherBloc>(context)
      ..add(GetDetailedWeather(widget.masterWeather.cityName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Detail"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        //display weather detail using bloc
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return buildLoading();
            }
            if (state is WeatherLoaded) {
              return buildColumnWithData(context, state.weather);
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
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
          //display celcius with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        Text(
          //display farenheit with 1 decimal place
          "${weather.temperatureFarenheit?.toStringAsFixed(1)} °F",
          style: TextStyle(fontSize: 80),
        )
      ],
    );
  }
}
