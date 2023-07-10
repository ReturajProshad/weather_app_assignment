import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather_data.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  WeatherData _weatherData = WeatherData();

  Future<void> fetchWeatherData() async {
    setState(() {
      _weatherData.isLoading = true;
      _weatherData.errorMessage = '';
    });

    final apiKey = 'b4b4d28d24f82a36318e480ff76a9027';
    final latitude = 25.807241;
    final longitude = 89.629478;
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=imperial';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        _weatherData.location = data['name'];
        _weatherData.temperature = data['main']['temp'].toString();
        _weatherData.minTemperature = data['main']['temp_min'].toString();
        _weatherData.maxTemperature = data['main']['temp_max'].toString();
        _weatherData.weatherDescription = data['weather'][0]['description'];
        _weatherData.weatherIconUrl =
            'https://openweathermap.org/img/w/${data['weather'][0]['icon']}.png';
        _weatherData.isLoading = false;
      });
    } else {
      setState(() {
        _weatherData.isLoading = false;
        _weatherData.errorMessage = 'Failed to fetch weather data';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Center(
        child: _weatherData.isLoading
            ? CircularProgressIndicator()
            : _weatherData.errorMessage.isNotEmpty
                ? Text(_weatherData.errorMessage)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weatherData.location,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Image.network(
                        _weatherData.weatherIconUrl,
                        width: 64,
                        height: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Temperature: ${_weatherData.temperature}°F',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Min Temperature: ${_weatherData.minTemperature}°F',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Max Temperature: ${_weatherData.maxTemperature}°F',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _weatherData.weatherDescription,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
      ),
    );
  }
}