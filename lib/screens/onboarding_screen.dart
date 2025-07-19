import 'package:flutter/material.dart';
import 'location_permission.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
  {
    "title": "Real-time Alerts",
    "description": "Get instant disaster alerts for your area.",
    "icon": Icons.warning
  },
  {
    "title": "Offline Survival Tools",
    "description": "Access checklists, guides, and contacts even without network.",
    "icon": Icons.checklist
  },
  {
    "title": "Volunteer and Donation Help",
    "description": "Find or offer help during disasters.",
    "icon": Icons.volunteer_activism
  },
  {
    "title": "AI Chatbot + Elder Mode",
    "description": "Talk to our assistant or switch to easy-access Elder Mode.",
    "icon": Icons.elderly
  },
];


  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LocationPermissionScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  onboardingData[index]["icon"],
                  size: 100,
                  color: Colors.teal,
                ),
                const SizedBox(height: 30),
                Text(
                  onboardingData[index]["title"],
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  onboardingData[index]["description"],
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _skip,
                      child: const Text("SKIP", style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(_currentPage == onboardingData.length - 1 ? "Get Started" : "NEXT"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
