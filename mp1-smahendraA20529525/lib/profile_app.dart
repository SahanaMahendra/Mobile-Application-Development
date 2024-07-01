import 'package:flutter/material.dart';
import 'experience_section.dart';
import 'education_section.dart';
import 'skill_section.dart';


class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        backgroundColor: Color.fromARGB(255, 230, 230, 223), 
        body: SingleChildScrollView(
          child: ProfileScreen(),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 150.0,
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/background_picture.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0, bottom: 0.0),
                  child: CircleAvatar(
                    radius: 75.0,
                    backgroundColor: Color.fromARGB(255, 246, 248, 249),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile_picture.jpg',
                        width: 140.0,
                        height: 160.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          buildSectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSectionHeader(title: 'Sahana Mahendra'),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: const Text(
                    'Passionate about creating seamless and innovative mobile experiences, I am a skilled mobile application developer specializing in Flutter and Dart. My journey in the world of mobile development has equipped me with the expertise to turn creative ideas into functional and user-friendly applications.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          buildSectionContainer(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      buildSectionHeader(title: 'Education'),
      EducationSection(
        educationList: [
          EducationInfo(
            imagePath: 'assets/images/iit_picture.jpg',
            institution: 'Illinois Institute of Technology',
            degree: 'Masters degree, Computer Science',
            date: 'Jan 2023',
            grade: 'Grade: 3.6',
          ),
          EducationInfo(
            imagePath: 'assets/images/vtu_picture.jpg',
            institution: 'Visvesvaraya Technological University',
            degree: 'Bachelor of Engineering, E&C',
            date: 'Aug 2017',
            grade: 'Grade: 3.4',
          ),
          
        ],
      ),
    ],
  ),
),
          SizedBox(height: 16.0),
          SizedBox(height: 16.0),
          buildSectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSectionHeader(title: 'Skills'),
                SkillsSection(
                  skills: const ['Java', 'Dart', 'React', 'GitHub', 'HTML', 'SQL', 'Flutter', 'CSS'],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          buildSectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSectionHeader(title: 'Experience'),
                const ExperienceSection(
                  imagePath: 'assets/images/ds_picture.jpg',
                  jobTitle: 'Quality Engineer Specialist',
                  companyName: 'Dassault Systèmes',
                  dateRange: 'Feb 2020 - Jan 2023',
                  location: 'Bangalore',
                ),
                const ExperienceSection(
                  imagePath: 'assets/images/cgi_picture.jpg',
                  jobTitle: 'Software Engineer',
                  companyName: 'CGI',
                  dateRange: 'Aug 2017 - Feb 2020',
                  location: 'Bangalore',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionContainer({required Widget child}) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  Widget buildSectionHeader({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}