

import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String? userDistrict;

  

  final Map<String, List<Map<String, String>>> districtHelplines = {
    'Wayanad': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Health(DMO)': '04935 240390'},
      {'Collectorate':'04936202251'},
      {'KSRTC':'Sultan Bathery: 04936 220217'},
      {'KSRTC':'Mananthavady: 04935 240640'},
      {'KSRTC':'Kalpetta: 04936 203040'},
      {'KSEB':' 04935-240289'},
    ],
    'Ernakulam': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'KSRTC':'Aluva: 0484-2624242'},
      {'KSRTC':'Angamali: 0484-2453050'},
      {'KSRTC':'Ernakulam: 0484-2372033'},
      {'KSRTC':'Kothamangalam: 0485-2862202'},
      {'KSRTC':'Koothattukulam: 0485-2253444'},
      {'KSRTC':'Moovattupuzha: 0485-2832321'},
      {'KSRTC':'North paravur: 0484-2442373'},
      {'KSRTC':'Perummbavoor: 0484-2523416'},
      {'KSRTC':'Piravom: 0485-2265533'},
      {'KSEB':'0484-2392248'},
      {'Collectorate':'0484-24223001'},
      {'Health(DMO)': '0484-2360802'}, 
    ],
    'Idukki': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Collectorate':'+91 4862232242'},
      {'Health(DMO)': ' 04862-233030'},
      {'KSEB':'Kattappana Electrical Division: 04868272348'},
      {'KSEB':'Thodupuzha Electrical Division: 04862220140 '}, 
      {'KSRTC':'Thodupuzha: 04862 222388'}, 
      {'KSRTC':'Munnar: 04865 230201'},
      {'KSRTC':'Moolamattom: 04862 252045'}, 
      {'KSRTC':'Kattappana: 04862 252333'},
      {'KSRTC':'Idukki: 04862 232244'},
      {'KSRTC':'Vandiperiyar: 04862 252733'},
      ], 
    'Kasaragod': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Health(DMO)': '0467 220 3118'},
      {'KSEB': '04998-225622'},
      {'KSRTC':'0499-4230677'},
      {'Collectrate': '+91-4994-256400'},
    ],
    'Kannur': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'KSRTC': '0497-2707777'},
      {'KSEB': ' 0497-2707777 '},
      {'Health(DMO': '0497 270 0194'},
      {'Collectorate': '0497 270 0243'},
    ],
    'Kozhikode': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Health(DMO)': '04935 240390'},
      {'Collectorate':'04936202251'},
      {'Health(DMO)': '04935 240390'},
      {'Collectorate':'04936202251'},
      {'KSRTC':'Vadakara: 0496-2523377'},
      {'KSRTC':'Thottilpalam: 0496-2566200'},
      {'KSRTC':'Thiruvambady: 0495-2254500'},
      {'KSRTC':'Thamarassery: 0495-2222217'},
      {'KSRTC':'Kozhikode: 0495-2723796'},
      {'KSEB':' 04935-240289'},
    ],
    'Malappuram': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Health(DMO)': '0483 273 7857'},
      {'Collectorate': '0483 273 4922'},
      {'KSEB Malappuram Office': '0483-2734913 '},
      {'KSEB Manjeri Circle Office': ' 0483-2766848'},
      {'KSRTC': ' 0483-2734950'},
    ],
    'Palakkad': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Health(DMO)': '0491 250 5264'},
      {'Collectorate': '0491 250 5309'},
      {'KSEB': '9496001912'},
      {'KSRTC Bus Stand': ' 0491-2520098'},
      {'Vadakkencherry': '04922255001'},
      {'Mannarkkad': '04924225150'},
      {'Chittur': '04923227488 '},
    ],
    'Thrissur': [
     {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Collectorate': '0487 236 1020'},
      {'Health(DMO)': '0487 233 3242'},
      {'KSRTC': '0487 2421150'},
      {'KSRTC Thrissur Town': ' 0487 2556450'},
      {'Puthukkad': '0480 2751648'},
      {'Mala': '0480 2890438'},
      {'Kodungallur': '0480 2803155'},
      {'Chalakudy': ' 0480 2701638'},
      {'KSEB': '0487-2607337'},
    ],
    'Kottayam': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'KSRTC': '+91 4812562908'},
      {'KSEB': '+91 4812568050'},
      {'Collectorate': '9447029007'},
      {'Health(DMO)': ' 0481 256 2778'}, 
    ],
    'Alappuzha': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'KSRTC': '0477-2252501'},
      {'KSEB': '0477-2245436'},
      {'Collectorate': '0477 225 1720'},
      {'Health(DMO)': '0477 225 1650'},
    ],
    'Pathanamthitta': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Pathanamthitta District Transport Officer': ''},
      {'Health(DMO)': '0468-2228220, 994610547'},
      {'Collectorate': '0468 222 2505'},
      {'KSEB': '0468 222 2337'},
      {'KSRTC DTO Pathanamthitta': '0468 2229213'},
      {'Adoor ': '04734 224767, 224764'},
      {'Konni': ' 0468 2244555'},
      {'Chengannur': '0479 2452213, 2452352'},
      {'Mallappally': ' 0469 2785080'},
      {'Pandalam ': '04734 255800'},
      {'Pamba': ' 04735 203445'},
      {'Ranni': '04735 225253'},
      {'Thiruvalla ': '0469 2601345, 2602945'},
    ],
     'Kollam': [
      {'Police': '100'},
      {'Chengannur': ' 0479 2452213, 2452352'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Traffic alert': '1099'},   
      {'Highway Alert': '9846100100'},
      {'Rail Alert': '9846200100'},
      {'Computer Emergency Response Team': '0471-2725646'},
      {'Kerala Police Message Centre': '9497900000'},
    ],
    'Thiruvananthapuram': [
      {'Police': '100'},
      {'Ambulance': '102'},
      {'Fire': '101'},
      {'Control room': '0471-2730067'},
      {'Media Center': '0471-2730087'},
      {'Disaster Management Services': '0471-2730045'},
      {'Railway Police Alert': '9846200100'},
      {'Highway Alert': '9846100100'},
      {'Road Accident Emergency Service': '108'},
      {'Children In Difficult Situation': '1098'}, 
    ],
  };

  final List<Map<String, String>> generalContacts = [
    {'Police':'100'},
    {'Ambulance': '102'},
    {'Fire': '101'},
    {'Disaster Management': '1077'},
    {'Women Helpline': '1091'},
    {'Pink Petrol':'1515'},
  ];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Bluish-green background
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: Colors.teal[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              'General Emergency Contacts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...generalContacts.map(
              (contact) => Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Colors.teal),
                  title: Text(contact.keys.first),
                  trailing: Text(contact.values.first,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {},
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1.2),
            const SizedBox(height: 10),
            if (userDistrict != null)
              Text(
                'Helpline Contacts for $userDistrict',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            if (userDistrict != null && districtHelplines.containsKey(userDistrict))
              ...districtHelplines[userDistrict!]!.map(
                (contact) => Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.call, color: Colors.teal),
                    title: Text(contact.keys.first),
                    trailing: Text(contact.values.first,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {},
                  ),
                ),
              )
            else if (userDistrict != null)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No district-specific contacts found.',
                    style: TextStyle(fontSize: 16)),
              ),
            const SizedBox(height: 24),
            const Text(
              'Select District',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal),
              ),
              child: DropdownButton<String>(
                value: userDistrict,
                hint: const Text('Select your district'),
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: districtHelplines.keys
                    .map(
                      (district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    userDistrict = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
