import 'package:flutter/material.dart';

class EducationSection extends StatelessWidget {
  final List<EducationInfo> educationList;

  const EducationSection({
    Key? key,
    required this.educationList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: educationList.length,
      itemBuilder: (context, index) {
        return EducationItem(educationInfo: educationList[index]);
      },
    );
  }
}

class EducationItem extends StatelessWidget {
  final EducationInfo educationInfo;

  const EducationItem({
    Key? key,
    required this.educationInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          educationInfo.imagePath,
          width: 30.0,
          height: 30.0,
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              educationInfo.institution,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(educationInfo.degree),
            Text(educationInfo.date),
            Text(educationInfo.grade),
          ],
        ),
      ],
    );
  }
}

class EducationInfo {
  final String imagePath;
  final String institution;
  final String degree;
  final String date;
  final String grade;

  EducationInfo({
    required this.imagePath,
    required this.institution,
    required this.degree,
    required this.date,
    required this.grade,
  });
}
