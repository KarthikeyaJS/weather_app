import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherServices('your_api_key');
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();

  // Fetch weather for the current city
  void _fetchCurrentCityWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    _fetchWeather(cityName);
  }

  // Fetch weather for a specific city
  void _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sun.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
        return 'assets/cloud.json';
      case 'fog':
        return 'assets/fog.json';
      case 'haze':
        return 'assets/haze.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  Color getBackgroundColor(String? mainCondition) {
    if (mainCondition == null) return Colors.blue; // Default color
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
        return Colors.grey; // Cloudy
      case 'fog':
        return Colors.blueGrey; // Foggy
      case 'haze':
        return Colors.brown; // Hazy
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Colors.blue; // Rainy
      case 'thunderstorm':
        return Colors.purple; // Thunderstorm
      case 'clear':
        return Colors.orange; // Clear
      default:
        return Colors.blue; // Default color
    }
  }

  Color getFontColor(String? mainCondition) {
    if (mainCondition == null) return Colors.black; // Default color
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
        return Colors.black; // Dark text for cloudy
      case 'fog':
      case 'haze':
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return Colors.white; // Light text for darker backgrounds
      case 'clear':
        return Colors.black; // Dark text for clear
      default:
        return Colors.black; // Default color
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch current city weather on load
    _fetchCurrentCityWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getBackgroundColor(_weather?.mainCondition),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _weather?.cityName ?? "loading city...",
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 30,
                  color: getFontColor(_weather?.mainCondition),
                ),
              ),
              Text(
                DateFormat('EEE, MMM d, y h:mm a').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 16,
                  color: getFontColor(_weather?.mainCondition),
                ),
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text(
                '${_weather?.temperature.round()}°C',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 30,
                  color: getFontColor(_weather?.mainCondition),
                ),
              ),
              Text(
                _weather?.mainCondition ?? "",
                style: TextStyle(
                  fontSize: 20,
                  color: getFontColor(_weather?.mainCondition),
                ),
              ),
              const SizedBox(height: 127), // Add some space
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search your city',
                    hintText: 'Enter city name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _fetchWeather(value);
                      _cityController
                          .clear(); // Clear the input field after submission
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
