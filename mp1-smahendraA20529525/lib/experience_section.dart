import 'package:flutter/material.dart';
class ExperienceSection extends StatelessWidget {
  final String imagePath;
  final String jobTitle;
  final String companyName;
  final String dateRange;
  final String location;

  const ExperienceSection({
    required this.imagePath,
    required this.jobTitle,
    required this.companyName,
    required this.dateRange,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: 30.0,
          height: 30.0,
        ),
        SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(companyName),
            Text(dateRange),
            Text(location),
            SizedBox(height: 16.0),
          ],
        ),
      ],
    );
  }
}

