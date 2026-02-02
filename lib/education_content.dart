import 'dart:convert';

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