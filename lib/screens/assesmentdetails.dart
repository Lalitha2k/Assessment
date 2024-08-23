import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 136, 183, 223),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "What do you get?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  IconFeature(icon: Icons.health_and_safety, label: "Key Body Vitals"),
                  IconFeature(icon: Icons.insights, label: "Posture Analysis"),
                  IconFeature(icon: Icons.fitness_center, label: "Body Composition"),
                  IconFeature(icon: Icons.report, label: "Instant Report"),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "How we do it?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
              const SizedBox(height: 12),
              const Text(
                "We do not store or share your personal data",
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
              const SizedBox(height: 12),
              const InstructionList(),
            ],
          ),
        ),
      ),
    );
  }
}

class IconFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconFeature({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class InstructionList extends StatelessWidget {
  const InstructionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("1. Ensure that you are in a well-lit space."),
        SizedBox(height: 8),
        Text("2. Allow camera access and place your device against a stable object or wall."),
        SizedBox(height: 8),
        Text("3. Avoid wearing baggy clothes."),
        SizedBox(height: 8),
        Text("4. Make sure you exercise as per the instruction provided by the trainer."),
      ],
    );
  }
}
