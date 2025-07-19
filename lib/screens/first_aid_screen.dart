import 'package:flutter/material.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tips = [
  {'title': 'CPR', 'desc': 'Call emergency, start chest compressions.'},
  {'title': 'Bleeding', 'desc': 'Apply pressure, use a clean cloth.'},
  {'title': 'Burns', 'desc': 'Cool burn with water, do not apply ice.'},
  {'title': 'Choking', 'desc': 'Give quick upward pressure on belly to help cough out blockage.'},
  {'title': 'Fractures', 'desc': 'Do not move, get help quickly.'},
  {'title': 'Snake Bite', 'desc': 'Stay calm, keep limb still and low, get medical help fast.'},
  {'title': 'Unconsciousness', 'desc': 'Check response, call 108, clear airway, check breathing, give CPR, turn on side, watch closely.'},
  {'title': 'Sunburn', 'desc': 'Move to shade, cool skin with water, apply aloe vera, drink water.'},
  {'title': 'Electrocuted', 'desc': 'Turn off power, do not touch victim, call 108, check breathing, give CPR if needed.'},
  {'title': 'Nosebleed', 'desc': 'Sit down, lean forward, pinch nose gently, breathe through mouth.'},
  {'title': 'Heat Stroke', 'desc': 'Move to cool place, drink water, cool skin with wet cloth.'},
  {'title': 'Fainting', 'desc': 'Lay down, raise legs, loosen tight clothes, give fresh air.'},
  {'title': 'Poisoning', 'desc': 'Call emergency, do not make person vomit unless told.'},
  {'title': 'Insect Bite', 'desc': 'Clean area, apply cold pack, do not scratch.'},
  {'title': 'Sprain', 'desc': 'Rest, ice the area, compress with bandage, raise the leg or arm.'},
  {'title': 'Hypothermia', 'desc': 'Move to warm place, remove wet clothes, cover with blanket.'},
  {'title': 'Asthma Attack', 'desc': 'Help person sit up, use inhaler if available, call emergency if needed.'},
  {'title': 'Seizure', 'desc': 'Keep person safe, clear area, do not hold down, call emergency.'},
  {'title': 'Cat Scratch', 'desc': 'Clean wound with soap and water, apply antiseptic, watch for infection.'},
  {'title': 'Dog Scratch', 'desc': 'Wash wound well, apply antiseptic, seek medical help if deep or bleeding.'},
];

    return Scaffold(
      appBar: AppBar(title: const Text('First Aid Guide')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(tips[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(tips[index]['desc']!),
              leading: const Icon(Icons.health_and_safety, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
