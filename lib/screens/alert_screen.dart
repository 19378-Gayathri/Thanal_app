import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String selectedDistrict = 'Wayanad';
  late Future<List<Map<String, String>>> futureAlerts;

  final List<String> districts = [
    'Kolkata',
    'Wayanad',
    'Kozhikode',
    'Ernakulam',
    'Thiruvananthapuram',
    'Kannur',
    'Palakkad',
    'Thrissur',
    'Kottayam',
    'Alappuzha',
    'Kollam',
    'Pathanamthitta',
  ];

  final Map<String, String> districtToCity = {
    'Kolkata': 'Kolkata',
    'Wayanad': 'Kalpetta',
    'Kozhikode': 'Kozhikode',
    'Ernakulam': 'Kochi',
    'Thiruvananthapuram': 'Thiruvananthapuram',
    'Kannur': 'Kannur',
    'Palakkad': 'Palakkad',
    'Thrissur': 'Thrissur',
    'Kottayam': 'Kottayam',
    'Alappuzha': 'Alappuzha',
    'Kollam': 'Kollam',
    'Pathanamthitta': 'Pathanamthitta',
  };

  @override
  void initState() {
    super.initState();
    final apiLocation = districtToCity[selectedDistrict] ?? selectedDistrict;
    futureAlerts = WeatherService().fetchWeatherAlerts(apiLocation);
  }

  void _onDistrictChanged(String? newDistrict) {
    if (newDistrict != null) {
      setState(() {
        selectedDistrict = newDistrict;
        final apiLocation = districtToCity[selectedDistrict] ?? selectedDistrict;
        futureAlerts = WeatherService().fetchWeatherAlerts(apiLocation);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Alerts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedDistrict,
              isExpanded: true,
              items: districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: _onDistrictChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: futureAlerts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final alerts = snapshot.data ?? [];

                if (alerts.isEmpty) {
                  return const Center(child: Text('✅ No active alerts.'));
                }

                return ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert['title'] ?? 'No Title',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(alert['time'] ?? '', style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            Text(alert['description'] ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
