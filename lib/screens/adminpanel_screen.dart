import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  void updateStatus(String docId, String status) {
    FirebaseFirestore.instance.collection('volunteers').doc(docId).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Volunteer Admin Panel")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('volunteers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error loading data"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final volunteers = snapshot.data!.docs;

          if (volunteers.isEmpty) return Center(child: Text("No volunteers registered"));

          return ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final doc = volunteers[index];
              final data = doc.data() as Map<String, dynamic>;

              final name = data['name'] ?? 'Unnamed Volunteer';
              final address = data['address'] ?? 'No address provided';
              final phone = data['phone'] ?? 'No phone provided';
              final expertiseList = data['expertise'] as List<dynamic>? ?? [];
              final status = data['status'] ?? 'pending';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Address: $address'),
                      Text('Phone: $phone'),
                      Text('Expertise: ${expertiseList.join(', ')}'),
                      Text('Status: $status'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status != 'verified')
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => updateStatus(doc.id, 'verified'),
                          tooltip: 'Verify',
                        ),
                      if (status != 'rejected')
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => updateStatus(doc.id, 'rejected'),
                          tooltip: 'Reject',
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
