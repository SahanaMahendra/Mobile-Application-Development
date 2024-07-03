import 'package:flutter/material.dart';
class SkillsSection extends StatelessWidget {
  final List<String> skills;

  SkillsSection({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: generateChips(),
    );
  }

  List<Widget> generateChips() {
    return skills.map((skill) => Chip(label: Text(skill))).toList();
  }
}