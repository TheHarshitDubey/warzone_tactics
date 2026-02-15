import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final AudioPlayer audioPlayer=AudioPlayer();

    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/war_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.65),
          ),

          // Content
          SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!;
                int gold = data['gold'] ?? 0;
                int armyPower = data['armyPower'] ?? 0;
                int wins = data['wins'] ?? 0;
                int losses = data['losses'] ?? 0;
                int totalMatches = wins + losses;
                double winRate = totalMatches == 0
                    ? 0
                    : (wins / (totalMatches)) * 100;
                String getPerformanceRating(double winRate){
                  if(winRate>=80)return "Elite Commander";
                  if(winRate>=80)return "Skilled Warrior";
                  if(winRate>=80)return "Rising Fighter";
                  return "In Training";
                }
                String getEnemyMove(int playerHealth, int enemyHealth){
                  if(playerHealth<=25) return "Finisher Attack";
                  else if (enemyHealth<=30) return "Defensive Mode";
                  else if (enemyHealth<playerHealth) return "Strategic Counter";
                  else return "Balanced Strike";
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          "WARZONE TACTICS",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      buildStatCard(Icons.monetization_on, "Gold", "$gold"),
                      buildStatCard(Icons.shield, "Army Power", "$armyPower"),
                      buildStatCard(Icons.emoji_events, "Wins", "$wins"),
                      buildStatCard(Icons.close, "Losses", "$losses"),
                      buildStatCard(Icons.percent, "Win Rate",
                          "${winRate.toStringAsFixed(1)}%"),
                      buildStatCard(Icons.star, "Rank", getPerformanceRating(winRate)),

                      const SizedBox(height: 30),

                      buildWarButton(
                        title: "Train Army (Cost: 100 Gold)",
                        color: Colors.green,
                        onTap:()async{
                          await audioPlayer.play(AssetSource('assets/sounds/train'));
                        
                        gold >= 100
                            ? () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                  'gold': gold - 100,
                                  'armyPower': armyPower + 10,
                                });
                              }
                            : null;
                        } 
                      ),

                      const SizedBox(height: 20),

                      // Attack Button
                      buildWarButton(
                        title: "Attack Enemy",
                        color: Colors.red,
                        onTap: ()async{
                          await audioPlayer.play(AssetSource('assets/sounds/attack'));
                          () async {
                          int enemyPower =
                              Random().nextInt(armyPower + 50) + 10;

                          if (armyPower >= enemyPower) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update({
                              'gold': gold + 200,
                              'wins': wins + 1,
                            });

                            showMessage(context,
                                "Victory! Enemy Power: $enemyPower");
                          } else {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update({
                              'losses': losses + 1,
                            });

                            showMessage(context,
                                "Defeat! Enemy Power: $enemyPower");
                          } String enemyMove=getEnemyMove(armyPower, enemyPower);
                          showMessage(context, "Enemy uses: $enemyMove");
                        };
                        }
                      ),

                      const SizedBox(height: 30),

                      const Center(
                        child: Text(
                          '"Lead your troops to victory!"',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      color: Colors.grey.shade900.withOpacity(0.8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title,style: TextStyle(color: Color(0xFFE0E0E0)),),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFFE0E0E0)
          ),
        ),
      ),
    );
  }

  Widget buildWarButton({
    required String title,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16,color: Color(0xFFE0E0E0)),
      ),
    );
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}