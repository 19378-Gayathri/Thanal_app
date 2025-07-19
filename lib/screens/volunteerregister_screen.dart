import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerRegisterScreen extends StatefulWidget {
  const VolunteerRegisterScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerRegisterScreen> createState() => _VolunteerRegisterScreenState();
}

class _VolunteerRegisterScreenState extends State<VolunteerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _address = '';
  String _phone = '';
  List<String> _selectedExpertise = [];

  bool _isLoading = false;

  final List<String> _expertiseOptions = [
    'Evacuation',
    'Medical Aid',
    'Food Distribution',
    'Elderly Assistance',
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedExpertise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields and select at least one expertise.')),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await FirebaseFirestore.instance.collection('volunteers').doc(user.uid).set({
        'name': _name,
        'address': _address,
        'phone': _phone,
        'expertise': _selectedExpertise,
        'status': 'pending',
        'availability': true,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted. Await verification.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green
      appBar: AppBar(
        title: const Text('Volunteer Registration'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Enter your name' : null,
                          onSaved: (value) => _name = value!.trim(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Enter your address' : null,
                          onSaved: (value) => _address = value!.trim(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Enter your phone number' : null,
                          onSaved: (value) => _phone = value!.trim(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Areas of Expertise',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ..._expertiseOptions.map((expertise) {
                          return CheckboxListTile(
                            title: Text(expertise),
                            activeColor: Colors.teal,
                            value: _selectedExpertise.contains(expertise),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  _selectedExpertise.add(expertise);
                                } else {
                                  _selectedExpertise.remove(expertise);
                                }
                              });
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _submit,
                            icon: const Icon(Icons.send),
                            label: const Text('Submit Registration'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
