import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool elderMode = false;
  bool isAdmin = false;
  bool _isAdminLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAdminLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is bool) {
        setState(() {
          isAdmin = args;
          _isAdminLoaded = true;
        });
      } else {
        _isAdminLoaded = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = elderMode ? 14 : 12;
    final double iconSize = elderMode ? 26 : 20;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thanal Dashboard', style: TextStyle(fontSize: fontSize)),
        actions: [
          Row(
            children: [
              Text('Elder Mode', style: TextStyle(fontSize: fontSize * 0.8)),
              Switch(
                value: elderMode,
                onChanged: (value) {
                  setState(() {
                    elderMode = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 250, // Moderate size for boxes
        padding: const EdgeInsets.all(12),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          buildCard(
            icon: Icons.warning,
            label: 'Live Alerts',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/alert'),
            borderColor: Colors.redAccent,
            showBadge: true,
            badgeText: 'Urgent',
          ),
          buildCard(
            icon: Icons.checklist,
            label: 'Checklist Access',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/checklist'),
            borderColor: Colors.blueAccent,
          ),
          buildCard(
            icon: Icons.phone_in_talk,
            label: 'Emergency Contacts',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/emergency_contacts'),
            borderColor: Colors.orangeAccent,
          ),
          buildCard(
            icon: Icons.medical_services,
            label: 'First Aid',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/first-aid'),
            borderColor: Colors.green,
          ),
          buildCard(
            icon: Icons.chat,
            label: 'Chatbot',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/chatbot'),
            borderColor: Colors.teal,
          ),
          buildCard(
            icon: Icons.report,
            label: 'Report Incident',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/report'),
            borderColor: Colors.deepOrange,
          ),
          buildCard(
            icon: Icons.how_to_reg,
            label: 'Volunteer Registration',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/volunteer'),
            borderColor: Colors.purple,
          ),
          buildCard(
            icon: Icons.help_outline,
            label: 'View Donation Ledger',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/donation-ledger'),
            borderColor: Colors.indigo,
          ),
          buildCard(
            icon: Icons.add_circle_outline,
            label: 'Add Donation',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/donation-form'),
            borderColor: Colors.indigo,
          ),
          buildCard(
            icon: Icons.dashboard_customize,
            label: 'Volunteer Dashboard',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/volunteer_dashboard'),
            borderColor: Colors.blueGrey,
          ),
          buildCard(
            icon: Icons.mic,
            label: 'Voice Assistant',
            fontSize: fontSize,
            iconSize: iconSize,
            onTap: () => Navigator.pushNamed(context, '/voice'),
            borderColor: Colors.blue,
          ),
          if (isAdmin)
            buildCard(
              icon: Icons.admin_panel_settings,
              label: 'Admin Panel',
              fontSize: fontSize,
              iconSize: iconSize,
              onTap: () => Navigator.pushNamed(context, '/admin'),
              borderColor: Colors.red[900]!,
            ),
        ],
      ),
    );
  }

  Widget buildCard({
    required IconData icon,
    required String label,
    required double fontSize,
    required double iconSize,
    required VoidCallback onTap,
    Color borderColor = Colors.blue,
    bool showBadge = false,
    String badgeText = '',
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: borderColor.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: iconSize, color: borderColor),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (showBadge)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 0.7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}