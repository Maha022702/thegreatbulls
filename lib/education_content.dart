import 'dart:convert';

// Education tab course data structure
class EducationTabCourse {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final int price;
  final String duration;
  final List<String> features;
  final String details;
  final List<String> topics;

  EducationTabCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.price,
    required this.duration,
    required this.features,
    required this.details,
    required this.topics,
  });

  factory EducationTabCourse.defaultCourses() {
    return EducationTabCourse.fromJson({});
  }

  static List<EducationTabCourse> defaultCourses() {
    return [
      EducationTabCourse(
      id: 'test',
      title: 'Test',
      description: 'Test',
      icon: 'star',
      color: 'blue',
      price: 1000,
      duration: '1 month',
      features: [
        'Test'
      ],
      details: 'Test',
      topics: [
        'Test'
      ],
    )
    ];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'color': color,
    'price': price,
    'duration': duration,
    'features': features,
    'details': details,
    'topics': topics,
  };

  factory EducationTabCourse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return EducationTabCourse(
        id: '',
        title: '',
        description: '',
        icon: '',
        color: 'blue',
        price: 0,
        duration: '',
        features: [],
        details: '',
        topics: [],
      );
    }
    return EducationTabCourse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? 'blue',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      details: json['details'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
    );
  }
}
