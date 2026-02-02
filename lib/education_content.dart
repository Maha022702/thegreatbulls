import 'dart:convert';

// Course Management Models
class Course {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String level; // Beginner, Intermediate, Advanced
  final int durationDays;
  final List<CourseModule> modules;
  final List<CourseResource> resources;
  final String status; // Active, Draft, Archived
  final DateTime createdDate;
  final int enrolledStudents;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.level,
    required this.durationDays,
    required this.modules,
    required this.resources,
    required this.status,
    required this.createdDate,
    required this.enrolledStudents,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'level': level,
      'durationDays': durationDays,
      'modules': modules.map((m) => m.toJson()).toList(),
      'resources': resources.map((r) => r.toJson()).toList(),
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'enrolledStudents': enrolledStudents,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      level: json['level'] ?? 'Beginner',
      durationDays: json['durationDays'] ?? 0,
      modules: (json['modules'] as List<dynamic>?)
          ?.map((m) => CourseModule.fromJson(m))
          .toList() ?? [],
      resources: (json['resources'] as List<dynamic>?)
          ?.map((r) => CourseResource.fromJson(r))
          .toList() ?? [],
      status: json['status'] ?? 'Draft',
      createdDate: json['createdDate'] != null 
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      enrolledStudents: json['enrolledStudents'] ?? 0,
    );
  }
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final List<String> lessonIds;

  CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.lessonIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'lessonIds': lessonIds,
    };
  }

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      lessonIds: List<String>.from(json['lessonIds'] ?? []),
    );
  }
}

class CourseResource {
  final String id;
  final String name;
  final String type; // PDF, VIDEO, DOCUMENT, CODE
  final String url;
  final String description;
  final int sizeBytes;

  CourseResource({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.description,
    required this.sizeBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'description': description,
      'sizeBytes': sizeBytes,
    };
  }

  factory CourseResource.fromJson(Map<String, dynamic> json) {
    return CourseResource(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'DOCUMENT',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      sizeBytes: json['sizeBytes'] ?? 0,
    );
  }
}

// Education content data structure
class EducationContent {
  final String heroTitle;
  final String heroSubtitle;
  final String eliteValueText;
  final String eliteValueDescription;
  final List<FeatureSection> featureSections;

  EducationContent({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.eliteValueText,
    required this.eliteValueDescription,
    required this.featureSections,
  });

  factory EducationContent.defaultContent() {
    return EducationContent(
      heroTitle: 'Revolutionary Features',
      heroSubtitle: 'Discover what makes The Great Bulls the future of trading',
      eliteValueText: 'Built for elite, latency-sensitive traders',
      eliteValueDescription: 'Single cockpit for AI signals, real-time execution, and compliance-friendly logging. Zero fluff—every module is actionable and measurable.',
      featureSections: [
        FeatureSection(
          title: '🤖 AI & Machine Learning',
          features: [
            Feature(
              icon: 'robot',
              title: 'AI Price Predictions',
              description: 'Advanced machine learning models analyze historical data, market sentiment, and technical indicators to predict price movements with up to 85% accuracy.',
              detail: 'Trained on 10+ years of NSE data',
              color: 'purple',
            ),
            Feature(
              icon: 'brain',
              title: 'Sentiment Analysis',
              description: 'Real-time analysis of news articles, social media, and market data to gauge market sentiment and predict volatility.',
              detail: 'Processes 1000+ sources per minute',
              color: 'blue',
            ),
            Feature(
              icon: 'chart-line',
              title: 'Pattern Recognition AI',
              description: 'Computer vision algorithms automatically detect 50+ chart patterns including head & shoulders, double tops, triangles, and flags.',
              detail: 'Real-time pattern alerts with confidence scores',
              color: 'green',
            ),
          ],
        ),
        FeatureSection(
          title: '📊 Advanced Analytics',
          features: [
            Feature(
              icon: 'search',
              title: 'Technical Indicators',
              description: '50+ technical indicators including RSI, MACD, Bollinger Bands, Fibonacci retracements, and custom indicators.',
              detail: 'Real-time calculation with alerts',
              color: 'orange',
            ),
            Feature(
              icon: 'chart-bar',
              title: 'Multi-Timeframe Analysis',
              description: 'Analyze charts across multiple timeframes simultaneously from 1-minute to monthly charts.',
              detail: 'Synchronized cross-timeframe analysis',
              color: 'teal',
            ),
            Feature(
              icon: 'balance-scale',
              title: 'Risk Management',
              description: 'Automated position sizing, stop-loss calculations, and risk-reward ratio analysis.',
              detail: 'Built-in risk management tools',
              color: 'red',
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heroTitle': heroTitle,
      'heroSubtitle': heroSubtitle,
      'eliteValueText': eliteValueText,
      'eliteValueDescription': eliteValueDescription,
      'featureSections': featureSections.map((section) => section.toJson()).toList(),
    };
  }

  factory EducationContent.fromJson(Map<String, dynamic> json) {
    return EducationContent(
      heroTitle: json['heroTitle'] ?? 'Revolutionary Features',
      heroSubtitle: json['heroSubtitle'] ?? 'Discover what makes The Great Bulls the future of trading',
      eliteValueText: json['eliteValueText'] ?? 'Built for elite, latency-sensitive traders',
      eliteValueDescription: json['eliteValueDescription'] ?? 'Single cockpit for AI signals, real-time execution, and compliance-friendly logging.',
      featureSections: (json['featureSections'] as List<dynamic>?)
          ?.map((section) => FeatureSection.fromJson(section))
          .toList() ?? [],
    );
  }
}

class FeatureSection {
  final String title;
  final List<Feature> features;

  FeatureSection({
    required this.title,
    required this.features,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'features': features.map((feature) => feature.toJson()).toList(),
    };
  }

  factory FeatureSection.fromJson(Map<String, dynamic> json) {
    return FeatureSection(
      title: json['title'] ?? '',
      features: (json['features'] as List<dynamic>?)
          ?.map((feature) => Feature.fromJson(feature))
          .toList() ?? [],
    );
  }
}

class Feature {
  final String icon;
  final String title;
  final String description;
  final String detail;
  final String color;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.detail,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'title': title,
      'description': description,
      'detail': detail,
      'color': color,
    };
  }

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      icon: json['icon'] ?? 'star',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      detail: json['detail'] ?? '',
      color: json['color'] ?? 'blue',
    );
  }
}