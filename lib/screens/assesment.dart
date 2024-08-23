// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define the Assessment model
class Assessment {
  final String title;
  final String description;
  final String imageUrl;

  Assessment({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Assessment.fromMap(Map<String, dynamic> data) {
    return Assessment(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['Image'] ?? '',
    );
  }
}

// Function to fetch assessments from Firestore
Future<List<Assessment>> fetchAssessments() async {
  final snapshot = await FirebaseFirestore.instance.collection('Assessments').get();
  return snapshot.docs.map((doc) => Assessment.fromMap(doc.data())).toList();
}

Widget buildAssessmentSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0), // Padding around the section
    child: FutureBuilder<List<Assessment>>(
      future: fetchAssessments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No assessments available'));
        }

        final assessments = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8), // Space between title and cards
            ...assessments.take(2).map((assessment) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0), // Space between cards
                child: buildAssessmentCard(context, assessment),
              );
            }).toList(),
            const SizedBox(height: 8), // Space before the View all button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllAssessmentsScreen(assessments: assessments)),
                  );
                },
                child: const Text("View all"),
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget buildAssessmentCard(BuildContext context, Assessment assessment) {
  return Container(
    padding: const EdgeInsets.all(16.0), // Padding inside the card
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(12), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 3,
        ),
      ],
    ),
    margin: const EdgeInsets.symmetric(horizontal: 8.0), // Increase horizontal size
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.network(
              assessment.imageUrl,
              width: 100, // Image size
              height: 100, // Image size
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
            const SizedBox(width: 12), // Space between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assessment.title,
                    style: const TextStyle(
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between title and description
                  Text(
                    assessment.description,
                    style: const TextStyle(
                      fontSize: 14, // Font size
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10), // Space before the button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssessmentDetailsScreen(
                            title: assessment.title,
                            duration: "4 min", // Pass the relevant duration or any other data
                            imageUrl: assessment.imageUrl,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow, color: Colors.blue), // Play button
                    label: const Text("Start", style: TextStyle(color: Colors.blue)), // Button text
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Button background color
                      onPrimary: Colors.blue, // Text color
                      side: BorderSide(color: const Color.fromARGB(255, 231, 232, 233)), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class AllAssessmentsScreen extends StatelessWidget {
  final List<Assessment> assessments;

  const AllAssessmentsScreen({Key? key, required this.assessments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Assessments"),
        backgroundColor: const Color.fromARGB(255, 136, 183, 223),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0), // Padding around the list
        itemCount: assessments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0), // Space between list items
            child: buildAssessmentCard(context, assessments[index]),
          );
        },
      ),
    );
  }
}
class AssessmentDetailsScreen extends StatelessWidget {
  final String title;
  final String duration;
  final String imageUrl;

  const AssessmentDetailsScreen({
    Key? key,
    required this.title,
    required this.duration,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and title section
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFa8e063), // Light green
                        Color(0xFF56ab2f), // Dark green
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40), // Rounded corners
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.timer, color: Colors.white70),
                                const SizedBox(width: 8),
                                Text(
                                  duration,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // "What do you get?" section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What do you get?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      IconFeature(
                          icon: Icons.health_and_safety,
                          label: "Key Body Vitals"),
                      IconFeature(
                          icon: Icons.insights,
                          label: "Vital Insights"),
                      IconFeature(
                          icon: Icons.recommend, label: "Quick Recommends"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // "How do we do it?" section
                  const Text(
                    "How do we do it?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Light green background section
                  Container(
                    color: const Color(0xFFE8F5E9), // Very light green
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: const [
                        Icon(Icons.security, color: Color.fromARGB(255, 30, 180, 143)),
                        SizedBox(width: 8),
                        Text(
                          "We do not store or share your personal data",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,color: Color.fromARGB(255, 15, 116, 90)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Ensure that you are in a well-lit space"),
                        const SizedBox(height: 8),
                        Text("2. Allow camera access and place your device against a stable object or wall"),
                        const SizedBox(height: 8),
                        Text("3. Avoid wearing baggy clothes"),
                        const SizedBox(height: 8),
                        Text("4. Make sure you exercise as per the instruction provided by the trainer"),
                        const SizedBox(height: 8),
                        Text("5. Watch the short preview before each exercise"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class IconFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconFeature({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F7FA), // Light color
            borderRadius: BorderRadius.circular(30), // Round shape
          ),
          child: Icon(icon, size: 30, color: const Color(0xFF00796B)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF00796B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
