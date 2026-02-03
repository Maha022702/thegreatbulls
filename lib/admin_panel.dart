import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'education_content.dart';
import 'main.dart';

/// Lean admin panel focused exclusively on the Education Tab.
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool _isSaving = false;
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final courses = appState.educationTabCourses;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Education Tab Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Back to public site',
            onPressed: () => context.go('/'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              appState.adminLogout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Only Education Tab is editable. Publishing pushes a GitHub commit so Vercel can deploy immediately.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : () => _commitEducationChangesToGitHub(courses),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.upload_file),
                  label: Text(_isSaving ? 'Publishing...' : 'Publish Changes'),
                ),
                const SizedBox(width: 12),
                if (_statusMessage != null)
                  Expanded(
                    child: Text(
                      _statusMessage!,
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: courses.isEmpty
                  ? const Center(
                      child: Text(
                        'Education Tab is empty. Update defaults or push new content via GitHub and refresh.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      itemCount: courses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) => _buildCourseCard(courses[index], index, appState),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(EducationTabCourse course, int index, AppState appState) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(course.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${course.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(course.description, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                Chip(label: Text(course.duration), backgroundColor: Colors.black26),
                Chip(label: Text(course.details), backgroundColor: Colors.black26),
              ],
            ),
            if (course.features.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Features', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: course.features
                    .map((feature) => Chip(label: Text(feature), backgroundColor: Colors.white10))
                    .toList(),
              ),
            ],
            if (course.topics.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Topics', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: course.topics
                    .map((topic) => Chip(
                          label: Text(topic),
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.white30),
                        ))
                    .toList(),
              ),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () => _showCourseEditor(index, course),
                child: const Text('Edit Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _commitEducationChangesToGitHub(List<EducationTabCourse> courses) async {
    if (courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No courses to publish')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _statusMessage = null;
    });

    try {
      final adminToken = html.window.localStorage['admin_token'] ?? '';
      final requestBody = jsonEncode({
        'courses': courses.map((course) => course.toJson()).toList(),
        'message': '📚 Update education tab courses from admin panel',
        'courseCount': courses.length,
      });

        final response = await html.window.fetch(
          '/api/github/commit-education-courses',
          {
            'method': 'POST',
            'headers': {
              'Content-Type': 'application/json',
              'X-Admin-Token': adminToken,
            },
            'body': requestBody,
          },
        );

        final ok = js_util.getProperty(response, 'ok') as bool? ?? false;
        final status = js_util.getProperty(response, 'status') as int? ?? 0;

        if (ok) {
          final responseData = await js_util.promiseToFuture(js_util.callMethod(response, 'json', []));
          final sha = responseData['commitSha'];
          final url = responseData['commitUrl'] ?? 'Commit URL not provided';
          setState(() => _statusMessage = 'Committed $sha');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Committed $sha\n📝 $url'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } else {
          final errorText = await js_util.promiseToFuture(js_util.callMethod(response, 'text', []));
          final message = 'GitHub API $status';
          setState(() => _statusMessage = '$message - $errorText');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ $message'), backgroundColor: Colors.red),
            );
          }
        }
    } catch (error, stack) {
      setState(() => _statusMessage = 'Unable to publish: $error');
      debugPrintStack(label: 'Education commit error', stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Unable to publish: $error'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showCourseEditor(int index, EducationTabCourse course) {
    final titleController = TextEditingController(text: course.title);
    final descriptionController = TextEditingController(text: course.description);
    final priceController = TextEditingController(text: course.price.toString());
    final durationController = TextEditingController(text: course.duration);
    final detailsController = TextEditingController(text: course.details);
    final featuresController = TextEditingController(text: course.features.join('\n'));
    final topicsController = TextEditingController(text: course.topics.join('\n'));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit course'),
          backgroundColor: Colors.grey[900],
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('Title', titleController),
                _buildTextField('Description', descriptionController, maxLines: 3),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Price', priceController, keyboardType: TextInputType.number)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTextField('Duration', durationController)),
                  ],
                ),
                _buildTextField('Details', detailsController),
                _buildTextField('Features (one per line)', featuresController, maxLines: 4),
                _buildTextField('Topics (one per line)', topicsController, maxLines: 4),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final updated = EducationTabCourse(
                  id: course.id,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  icon: course.icon,
                  color: course.color,
                  price: int.tryParse(priceController.text.replaceAll(RegExp('[^0-9]'), '')) ?? course.price,
                  duration: durationController.text.trim(),
                  features: featuresController.text
                      .split('\n')
                      .map((line) => line.trim())
                      .where((line) => line.isNotEmpty)
                      .toList(),
                  details: detailsController.text.trim(),
                  topics: topicsController.text
                      .split('\n')
                      .map((line) => line.trim())
                      .where((line) => line.isNotEmpty)
                      .toList(),
                );
                Provider.of<AppState>(context, listen: false).updateEducationTabCourse(index, updated);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
