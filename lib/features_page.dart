import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'education_content.dart';
import 'main.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'robot':
        return FontAwesomeIcons.robot;
      case 'brain':
        return FontAwesomeIcons.brain;
      case 'chart-line':
        return FontAwesomeIcons.chartLine;
      case 'search':
        return FontAwesomeIcons.search;
      case 'chart-bar':
        return FontAwesomeIcons.chartBar;
      case 'balance-scale':
        return FontAwesomeIcons.balanceScale;
      default:
        return FontAwesomeIcons.star;
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      case 'red':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final content = appState.currentEducationContent;
        return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => context.go('/'),
        ),
        title: Row(
          children: const [
            FaIcon(FontAwesomeIcons.bullseye, color: Colors.amber, size: 24),
            SizedBox(width: 10),
            Text('Features', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.amber, Colors.orange, Colors.amber],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.star, size: 60, color: Colors.black),
                    const SizedBox(height: 20),
                    Text(
                      content.heroTitle,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      content.heroSubtitle,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Elite Value Snapshot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.amber.withOpacity(0.25)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.eliteValueText,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    SizedBox(height: 10),
                    Text(
                      content.eliteValueDescription,
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            // Features Grid
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: content.featureSections.map((section) {
                  return Column(
                    children: [
                      _buildFeatureSection(
                        section.title,
                        section.features.map((feature) {
                          return _buildDetailedFeature(
                            _getIconFromString(feature.icon),
                            feature.title,
                            feature.description,
                            feature.detail,
                            _getColorFromString(feature.color),
                          );
                        }).toList(),
                      ),
                      if (section != content.featureSections.last)
                        const SizedBox(height: 60),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildFeatureSection(String title, List<Widget> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 30),
        ...features,
      ],
    );
  }

  Widget _buildDetailedFeature(IconData icon, String title, String description, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, size: 32, color: color),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}