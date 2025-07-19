import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';

class DonationLedgerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donation Ledger")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('donations').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final donation = Donation.fromMap(docs[index].data() as Map<String, dynamic>);
              return ListTile(
                title: Text(donation.donorName),
                subtitle: Text("₹${donation.amount.toStringAsFixed(2)}"),
                trailing: Text("${donation.date.day}/${donation.date.month}/${donation.date.year}"),
              );
            },
          );
        },
      ),
    );
  }
}
