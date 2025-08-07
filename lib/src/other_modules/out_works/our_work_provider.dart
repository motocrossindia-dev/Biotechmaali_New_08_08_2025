import 'dart:developer';

import '../../../import.dart';

class WorkItem {
  final String title;
  final String imageUrl;
  final String type;
  final String? youtubeUrl;
  final bool showConnectButton;

  WorkItem({
    required this.title,
    required this.imageUrl,
    required this.type,
    this.youtubeUrl,
    this.showConnectButton = false,
  });
}

// models/team_member.dart
class TeamMember {
  final String name;
  final String role;
  final String imageUrl;

  TeamMember({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

// providers/garden_provider.dart
class OurWorkProvider with ChangeNotifier {
  List<WorkItem> workItems = [
    WorkItem(
      title:
          'Elevate Your Outdoor/Transforming Terraces into Lush Garden Retreats',
      imageUrl: 'assets/png/images/home_screen_img_1.jpg',
      type: 'team',
    ),
    WorkItem(
      title: 'Growing For Every Generation',
      imageUrl: 'assets/garden.jpg',
      type: 'video',
      youtubeUrl: 'https://www.youtube.com/watch?v=9nQ6d3A2cTs',
    ),
    WorkItem(
      title: 'Design Your Dreamscape: Personalized Landscaping',
      imageUrl: 'assets/png/images/home_screen_img_2.jpg',
      type: 'design',
      showConnectButton: true,
    ),
    WorkItem(
      title: 'Expert Advice, Anytime Personalized Garden Consultations',
      imageUrl: 'assets/png/images/home_screen_img_2.jpg',
      type: 'consultation',
      showConnectButton: true,
    ),
  ];

  List<String> creativeProjects = List.generate(
    8,
    (index) => 'assets/png/images/home_screen_img_1.jpg',
  );

  List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Sophie',
      role: 'CEO & Founder',
      imageUrl: 'assets/png/images/home_screen_img_2.jpg',
    ),
    TeamMember(
      name: 'Chris',
      role: 'Lead Designer',
      imageUrl: 'assets/png/images/home_screen_img_2.jpg',
    ),
    TeamMember(
      name: 'Emma',
      role: 'Garden Expert',
      imageUrl: 'assets/png/images/home_screen_img_2.jpg',
    ),
    TeamMember(
      name: 'James',
      role: 'Landscape Architect',
      imageUrl: 'assets/png/images/home_screen_img_2.jpg',
    ),
  ];

  void connectWithExpert(String expertType) {
    // Implement connection logic here
    log('Connecting with $expertType expert');
    notifyListeners();
  }
}
