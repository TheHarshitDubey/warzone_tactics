import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warzone_tactics/services/auth_services.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Warzone Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.logout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!;
          int gold = data['gold'];
          int armyPower = data['armyPower'];
          int win = data['wins'];
          int loss = data['losses'];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Gold: $gold", style: const TextStyle(fontSize: 18)),
                Text("Army Power: $armyPower", style: const TextStyle(fontSize: 18)),
                Text("Wins: $win", style: const TextStyle(fontSize: 18)),
                Text("Loss: $loss", style: const TextStyle(fontSize: 18)),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: gold >= 100
                      ? () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'gold': gold - 100,
                            'armyPower': armyPower + 10,
                          });
                        }
                      : null,
                  child: const Text("Train Army (Cost: 100 Gold)"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    int enemyPower = Random().nextInt(100) + 10;

                    if (armyPower > enemyPower) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'gold': gold + 200,
                        'wins': win + 1,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Victory! Enemy Power: $enemyPower")),
                      );
                    } else {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'losses': loss + 1,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Defeat! Enemy Power: $enemyPower")),
                      );
                    }
                    // print('Your Power: $armyPower');
                    // print("enemyPower: $enemyPower");
                  },
                  
                  child: const Text("Attack Enemy"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}