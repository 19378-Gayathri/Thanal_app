import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<Map<String, dynamic>> checklist = [
    {'key': 'first aid kit', 'done': false, 'icon': Icons.medical_services},
    {'key': 'water supply', 'done': false, 'icon': Icons.water_drop},
    {'key': 'flashlight', 'done': false, 'icon': Icons.flashlight_on},
    {'key': 'documents', 'done': false, 'icon': Icons.description},
    {'key': 'food', 'done': false, 'icon': Icons.fastfood},
    {'key': 'charger', 'done': false, 'icon': Icons.battery_charging_full},
    {'key': 'whistle', 'done': false, 'icon': Icons.notifications_active},
    {'key': 'batteries', 'done': false, 'icon': Icons.battery_full},
    {'key': 'radio', 'done': false, 'icon': Icons.radio},
    {'key': 'face mask', 'done': false, 'icon': Icons.masks},
    {'key': 'gloves', 'done': false, 'icon': Icons.back_hand},
    {'key': 'medications', 'done': false, 'icon': Icons.local_pharmacy},
    {'key': 'warm clothes', 'done': false, 'icon': Icons.checkroom},
    {'key': 'blanket', 'done': false, 'icon': Icons.bed},
    {'key': 'multi-tool', 'done': false, 'icon': Icons.build},
    {'key': 'sanitizer', 'done': false, 'icon': Icons.sanitizer},
    {'key': 'rope', 'done': false, 'icon': Icons.nature_people},
    {'key': 'matches/lighter', 'done': false, 'icon': Icons.fireplace},
    {'key': 'emergency contact list', 'done': false, 'icon': Icons.contacts},
    {'key': 'cash', 'done': false, 'icon': Icons.attach_money},
  ];

  @override
  Widget build(BuildContext context) {
    print("Rebuilding ChecklistScreen with locale: ${context.locale}"); 
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text('emergency checklist'.tr()),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: checklist.length,
          itemBuilder: (context, index) {
            final item = checklist[index];
            return Card(
              color: item['done'] ? Colors.teal[100] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.teal.shade200, width: 1),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: CheckboxListTile(
                title: Text(
                  item['key'].toString().tr(), 
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration:
                        item['done'] ? TextDecoration.lineThrough : null,
                    color: item['done'] ? Colors.grey : Colors.black,
                  ),
                ),
                value: item['done'],
                onChanged: (bool? value) {
                  setState(() {
                    item['done'] = value!;
                  });
                },
                secondary: Icon(
                  item['icon'],
                  color: item['done'] ? Colors.grey : Colors.teal,
                  size: 28,
                ),
                activeColor: Colors.teal,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            );
          },
        ),
      ),
    );
  }
}
