/*import 'package:flutter/material.dart';

Widget buildChallengesSection() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Challenges",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("View All", style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Today's Challenge: Push Up 20x"),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: 0.5),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("10/20 Complete"),
                  ElevatedButton(onPressed: () {}, child: const Text("Continue")),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
} */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String title;
  final String imageUrl;

  Challenge({
    required this.title,
    required this.imageUrl,
  });

  factory Challenge.fromMap(Map<String, dynamic> data) {
    return Challenge(
      title: data['title'] ?? '',
      imageUrl: data['image'] ?? '',
    );
  }
}

Future<List<Challenge>> fetchChallenges() async {
  final snapshot = await FirebaseFirestore.instance.collection('Challeneges').get();
  return snapshot.docs.map((doc) => Challenge.fromMap(doc.data())).toList();
}

class AllChallengesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Challenges'),
      ),
      body: FutureBuilder<List<Challenge>>(
        future: fetchChallenges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No challenges available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final challenge = snapshot.data![index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    challenge.imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                ),
                title: Text(challenge.title),
                onTap: () {
                  // Handle challenge click, if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}

Widget buildChallengesSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder<List<Challenge>>(
      future: fetchChallenges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No challenges available'));
        }

        final currentChallenge = snapshot.data!.first; // Display the first challenge

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3, // Adjust as needed
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Challenges",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to AllChallengesScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllChallengesScreen()),
                      );
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Challenge!",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentChallenge.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: 0.5,
                            color: Colors.blue,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "10/20 Complete",
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle Continue button click
                            },
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                            label: Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        currentChallenge.imageUrl,
                        height: 120,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
